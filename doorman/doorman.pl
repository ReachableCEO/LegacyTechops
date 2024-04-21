#!/usr/bin/perl -W
###############################################################################
#
# doorman.pl - Use inexpensive USB RFID reader to allow access to a physical
#              portal controlled by an inexpensive USB relay, via a background
#              HTTP portal for authentication.
#
#################################################################[ AJC 2018 ]##
use strict;
use Linux::Input;
use Data::Dumper;
use WWW::Mechanize;
use File::Basename qw{basename};
use IO::Select;

###############################################################################
#
# Configuration directoves
#
###############################################################################

# Direct /dev link to device.  Use by-id when possible
my $device = "/dev/input/by-id/usb-13ba_Barcode_Reader-event-kbd";

my $usbrelay = "/usr/bin/usbrelay";
my $usbrelay_device = "3X9XI_1";

# The URL of the authentication server
my $url = "http://doors.pfv.turnsys.net/";

# Location of syslog's userspace logger utility
my $rsyslog = "/usr/bin/logger";

# Card IDs that bypass network auth
my %backdoors = (

  "0009399422" => 'Charles NW',
  "0009106067" => 'Josef C',

);

# For logging syslog messages to stdout as well as syslog.
my $debug = "true";
#my $debug = "false";

###############################################################################
#
# Subroutines
#
###############################################################################

#################################################
# logger - Send logs to syslog, or stdout if
#          DEBUG is defined.
#################################################
sub logger {

  my $logtext = shift;
  if ($debug eq "true") { print localtime()  . " " . basename($0) . ": " . "$logtext\n"  };
  system( $rsyslog . " \"" . basename($0) . ": " . "$logtext\"" );
  
}

#################################################
# unlock_door - Handle the USB relay to unlock
#               actuator.
#################################################
sub unlock_door() {
  
  system $usbrelay . " " . $usbrelay_device . "=1 >/dev/null 2>&1";
  sleep 10;
  system $usbrelay . " " . $usbrelay_device . "=0 >/dev/null 2>&1";
  logger "Locking door.";

  return 0;

}

#################################################
# authenticate - check backdoors and legit HTTP
#                source to see if ID is valid.
#                Unlocks door if appropriate.
#################################################
sub authenticate {

  my $id = shift;

  if ( defined $backdoors{$id} ) {

    logger $backdoors{$id} . " override key accepted.  Unlocking door.";
    unlock_door;

  } else {

    # Open a connection to auth server.
    my $connection = WWW::Mechanize->new( autocheck => 0, quiet => 1);
    $connection->get ($url . $id);
  
    # Touch a file named as the card ID number to make the card work.
    if ($connection->status == 200) {

      logger "Card $id is valid.  Unlocking door.";
      unlock_door;

    } else {

      # File is not cleanly returned, so it's invalid.
      logger "Card $id is invalid! (" . $connection->status() . ")";

    }

  }

}

#################################################
# keytranslate - Reduce the returned keypress 
#                value, and translate into the
#                actual number pressed.
#################################################
sub keytranslate {

  my $keypress = shift;

  return 1 if ($keypress == 30);
  return 2 if ($keypress == 31);
  return 3 if ($keypress == 32);
  return 4 if ($keypress == 33);
  return 5 if ($keypress == 34);
  return 6 if ($keypress == 35);
  return 7 if ($keypress == 36);
  return 8 if ($keypress == 37);
  return 9 if ($keypress == 38);
  return 0 if ($keypress == 39);
  return $keypress;

}


###############################################################################
# 
# main - This is where the whole thing comes together.
#
###############################################################################

# scoped values for loop work
my $oldvalue = 0;
my $dupe_flag = 0;
my $id = "";
my $done_flag = 0;

# Open all USB input devices, and stash in a hash until needed.
my @devicenames = map { "/dev/input/by-id/" . basename($_) } </dev/input/by-id/*>;
my %devices;

my $selector = IO::Select->new();

foreach (@devicenames) {
  my $device = Linux::Input->new($_);
  $selector->add($device->fh);
  $devices{$device->fh} = $device;
}

logger basename($0) . " started.";

system $usbrelay . " " . $usbrelay_device . "=0 >/dev/null 2>&1";


# stay in an infinite loop.
while ( 1 ) {

  # Do this if we have a device with some input
  while (my @fh = $selector->can_read) {

    # For each file handle that has stuff to read
    foreach my $fh (@fh) {

      my $input = $devices{$fh};

      # Read the input that's waiting
      while (my @events = $input->poll(0.01)) {

        # Convert keystrokes to useful data
        foreach (@events) {
          # break  up the input struct into useful scalars.
          my $code = %$_{code};
          my $value = %$_{value};
          my $type = %$_{type};     
          my $number = keytranslate($value & 127);

          # This seems to indicate a KEYP/KEYDOWN event
          if ( $code == 4 && $type == 4 ) {


            # If we just saw this, it's KEYUP now, so ignore
            if ($value == $oldvalue && $dupe_flag == 0) {
              $dupe_flag = 1;
              next
            } else {
              $dupe_flag = 0;
            }

            # 0-9 for number, 40 for end of string.
            if ( $number > 9 && $number != 40) { logger "Problem reading ID\n"; next} 

            if ( $number == 40) {
              $done_flag = 1;
            } else {
              $id .= $number;
            }
            
            $oldvalue = $value;

          } # if ($code == 4 && $type == 4)

        }  # foreach (@events)
     
      } # while (my @events = $input->poll(0.01))

    } # foreach my $fh (@fh)

    # Do something with the completed code.
    if ( $done_flag == 1) {

      logger "ID $id scanned.";

      authenticate($id); 
     
      $id = "";
      $done_flag = 0;

    } else {

      next

    }

  } # while (my @fh = $selector->can_read)


} # while (1)

