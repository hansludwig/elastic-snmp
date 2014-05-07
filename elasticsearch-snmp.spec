#	Author: hans.riethmann@ortecin.ch
#
Summary: SNMP agent extensions for elasticsearch
Name: elasticsearch-snmp
Version: 0.2.0
Release: 1
#Copyright: GPL
Packager: ortecin GmbH <hans.riethmann@ortecin.ch>
Vendor: zal.io
URL: http://www.zal.io
License: proprietary
Group: System Environment/Base
AutoReqProv: no
Requires: net-snmp-perl perl-libwww-perl perl-JSON-XS daemonize
BuildArch: noarch
BuildRoot: %_topdir/BUILDROOT/%{name}
Prefix: /opt
%define service esagentx

%description
This agent gets the information from an elasticsearch cluster / node
REST api and maps this information into a MIB tree.

%prep
%setup -T -D -n %{name}

%build
%define debug_package %{nil}
%define __jar_repack %{nil}

%install
rm -rf $RPM_BUILD_ROOT
make PREFIX=%{prefix} NAME=%{name} DESTDIR=$RPM_BUILD_ROOT \
     APPUSER=${APPUSER:-root} install

# adjust files to package in GNUmakefile, in particular
%files -f files.lst

# values of $1 based on rpm context and scriptlet
# +------------+---------+---------+-----------+
# |            | install | upgrade | uninstall |
# +------------+---------+---------+-----------+
# | %pretrans  | $1 == 0 | $1 == 0 | (N/A)     |
# | %pre       | $1 == 1 | $1 == 2 | (N/A)     |
# | %post      | $1 == 1 | $1 == 2 | (N/A)     |
# | %preun     | (N/A)   | $1 == 1 | $1 == 0   |
# | %postun    | (N/A)   | $1 == 1 | $1 == 0   |
# | %posttrans | $1 == 0 | $1 == 0 | (N/A)     |
# +------------+---------+---------+-----------+
%pre

%post
if [ "%{service}" ]; then
  chkconfig %{service} on
  # status returns 0 if the service is running, we only restart it if it is
  service %{service} status > /dev/null && service %{service} stop
  service %{service} start
fi

%preun
if [ "$1" = 0 ]; then
  if [ "%{service}" ]; then
    service %{service} stop
    chkconfig --del %{service}
  fi
fi

%postun
# see above
if [ "$1" = 0 ]; then
  rm -rf %{prefix}/%{name}
fi
