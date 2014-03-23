# $otiId: 73:c6daa13f96b8 Sat Dec 04 01:13:51 2010 +0100 hans $
#
Summary: rsync based backup script
Name: elasticsearch-snmp
Version: 0.1
Release: 1
Copyright: GPL
Group: Applications/System
Source: http://ortecin.ch/downloads/%{name}-%{version}.tgz
Vendor: ortecin Gmbh, Waffenplatzstrasse 40, 8002 Zurich
BuildRoot: %_topdir/buildroot/oti%{name}
BuildArchitectures: noarch
# we want multiple --link-dest support
Requires: net-snmp-perl perl-ExtUtils-Embed perl-libwww-perl perl-JSON-XS

%description

