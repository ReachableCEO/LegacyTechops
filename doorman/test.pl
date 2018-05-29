#!/usr/bin/perl -W
###############################################################################
#
# doorman.pl - Use inexpensive USB RFID reader to allow access to a physical
#              portal controlled by an inexpensive USB relay, via a background
#              HTTP portal for authentication.
#
#################################################################[ AJC 2018 ]##
use warnings;
use strict;
use Linux::Input;
use IO::Select;
use File::Basename qw{basename};
use Data::Dumper;

###############################################################################
#
# Configuration directoves
#
###############################################################################

# Direct /dev link to device.  Use by-id when possible

###############################################################################
# 
# main - This is where the whole thing comes together.
#
###############################################################################
sub main {

    # Add all input devices
    my @devicenames = map { "/dev/input/by-id/" . basename($_) } </dev/input/by-id/*>;
    my %devices;

    my $selector = IO::Select->new();

    foreach (@devicenames) {
      my $device = Linux::Input->new($_);
      $selector->add($device->fh);
      $devices{$device->fh} = $device;
    }

  while(1) {

    while (my @fh = $selector->can_read) {
      foreach my $fh (@fh) {
        my $input = $devices{$fh};
        while (my @events = $input->poll(0.01)) {
          foreach (@events) {
            print Dumper($_);
          }
        }

    }
    }

    
  }

}

main();

