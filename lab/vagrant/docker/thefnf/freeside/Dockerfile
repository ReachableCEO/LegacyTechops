FROM debian:7
ENV VERSION 3.3
RUN echo deb http://freeside.biz/~ivan/freeside-wheezy/ ./ >/etc/apt/sources.list.d/freeside.list  && \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y --force-yes --no-install-recommends adduser apache2 apache2-mpm-prefork apache2-utils curl gcc gnupg ghostscript gsfonts gzip latex-xcolor \
    less libapache-dbi-perl libapache2-mod-perl2 libapache2-request-perl libapache-session-perl \
    libbusiness-creditcard-perl libcache-cache-perl libcache-simple-timedexpiry-perl libchart-perl \
    libclass-container-perl libclass-data-inheritable-perl libclass-returnvalue-perl libcolor-scheme-perl \
    libio-compress-perl libconvert-binhex-perl libcrypt-passwdmd5-perl libcrypt-ssleay-perl libcss-squish-perl \
    libdate-manip-perl libdbd-mysql-perl libdbd-pg-perl libdbi-perl libdbix-dbschema-perl libdbix-searchbuilder-perl \
    libdevel-stacktrace-perl libdevel-symdump-perl liberror-perl libexception-class-perl \
    libfile-counterfile-perl libfile-rsync-perl libfont-afm-perl libfreezethaw-perl libfrontier-rpc-perl \
    libgd-gd2-perl libgd-graph-perl libgd2-xpm libhtml-format-perl libhtml-mason-perl libhtml-parser-perl \
    libhtml-scrubber-perl libhtml-tagset-perl libhtml-tree-perl libhtml-widgets-selectlayers-perl libio-stringy-perl \
    libipc-run-perl libipc-run3-perl libipc-sharelite-perl libjavascript-rpc-perl libjson-perl \
    liblingua-en-inflect-perl liblingua-en-nameparse-perl liblocale-gettext-perl liblocale-maketext-fuzzy-perl \
    liblocale-maketext-lexicon-perl liblocale-subcountry-perl liblog-dispatch-perl libmailtools-perl libmime-tools-perl \
    libmodule-versions-report-perl libnet-daemon-perl libnet-ping-external-perl libnet-scp-perl libnet-ssh-perl \
    libnet-whois-raw-perl libnetaddr-ip-perl libnumber-format-perl libpam-modules libpam-runtime libpaper-utils \
    libparams-validate-perl libparse-recdescent-perl libpcre3 libpg-perl libregexp-common-perl \
    libspreadsheet-writeexcel-perl libstring-approx-perl libstring-shellquote-perl libterm-readkey-perl \
    libtest-inline-perl libtext-autoformat-perl libtext-charwidth-perl libtext-csv-perl libtext-csv-xs-perl libtext-iconv-perl \
    libtext-quoted-perl libtext-reform-perl libtext-template-perl libtext-wrapi18n-perl libtext-wrapper-perl \
    libtie-ixhash-perl libtime-duration-perl libtime-modules-perl libtimedate-perl libtree-simple-perl \
    libuniversal-require-perl liburi-perl libwant-perl libwww-perl libxml-parser-perl libyaml-perl lmodern make \
    perl perl-base perl-modules texlive \
    texlive-latex-extra texinfo traceroute ttf-bitstream-vera ttf-dustin ucf zlib1g \
    libdatetime-perl libdatetime-format-strptime-perl libfile-slurp-perl libspreadsheet-parseexcel-perl \
    libauthen-passphrase-perl libnet-domain-tld-perl libbusiness-us-usps-webtools-perl libxml-simple-perl \
    libemail-sender-perl libemail-sender-transport-smtp-tls-perl libemail-sender-perl \
    libemail-sender-transport-smtp-tls-perl libhtml-defang-perl libdatetime-format-natural-perl libcgi-pm-perl \
    libfile-sharedir-perl libmodule-versions-report-perl libtext-wikiformat-perl libnet-server-perl \
    libhttp-server-simple-perl libhtml-rewriteattributes-perl libmime-types-perl libperlio-eol-perl \
    libgnupg-interface-perl libdata-ical-perl libcalendar-simple-perl libdatetime-set-perl \
    libhook-lexwrap-perl libhttp-server-simple-mason-perl libxml-rss-perl libipc-run-safehandles-perl libpoe-perl \
    libsoap-lite-perl libhtml-tableextract-perl libhtml-element-extended-perl libcam-pdf-perl libgd-barcode-perl \
    libnet-openssh-perl libgeo-coder-googlev3-perl libgeo-googleearth-pluggable-perl libnet-snmp-perl \
    libcrypt-openssl-rsa-perl libpdf-webkit-perl wkhtmltopdf xvfb \
    sam2p psmisc libsys-sigaction-perl liblog-dispatch-perl libconvert-color-perl libdate-simple-perl libemail-valid-perl \
    libencode-perl libexcel-writer-xlsx-perl libhtml-mason-psgihandler-perl libhtml-quoted-perl libio-string-perl \
    libregexp-common-net-cidr-perl libregexp-ipv6-perl libsnmp-perl libtext-password-pronounceable-perl \
    libparse-fixedlength-perl && \
  cd /usr/src && \
  curl http://www.freeside.biz/freeside/freeside-$VERSION.tar.gz |tar xz && \
  adduser freeside --system --group  --shell /bin/bash && \
  rm -rf /var/www/*
ADD Makefile /usr/src/freeside-$VERSION/Makefile
RUN cd /usr/src/freeside-$VERSION && \
  make perl-modules && \
  make install-perl-modules && \
  make create-config && \
  make install-docs && \
  make install-apache
USER freeside