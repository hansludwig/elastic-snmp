#	Author: hans.riethmann@ortecin.ch
#
Summary: SNMP agent extensions for elasticsearch
Name: elasticsearch-snmp
Version: 1.0.0
Release: 0
#Copyright: GPL
Packager: ortecin GmbH <hans.riethmann@ortecin.ch>
Vendor: zal.io
URL: http://www.zal.io
License: proprietary
Group: System Environment/Base
AutoReqProv: no
Requires: net-snmp-perl perl-ExtUtils-Embed perl-libwww-perl perl-JSON-XS
BuildArch: noarch
BuildRoot: %_topdir/BUILDROOT/%{name}
Prefix: /opt
#%define appuser elasticsearch
%define service snmpd

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
APPUSER=%{appuser}
make PREFIX=%{prefix} NAME=%{name} DESTDIR=$RPM_BUILD_ROOT \
     APPUSER=${APPUSER:-root} install

# adjust files to package in GNUmakefile, in particular
%files -f files.lst
%dir %attr(2775, -, %{appuser}) %{prefix}/%{name}/patterns
%dir %attr(0755, -, %{appuser}) %{prefix}/%{name}/etc/rsyslog.d
%dir %attr(0755, -, %{appuser}) %{prefix}/%{name}/etc/logrotate.d
%dir %attr(2755, -, %{appuser}) %{prefix}/%{name}/data
%dir %attr(2775, -, %{appuser}) %{prefix}/%{name}/data/logs
# as long as we have RHEL 5 systems around this is needed, otherwise
# an attempt to install a package built on RHEL 6 on a RHEL 5 system
# produces the following error messages:
#[root@ux0116 x86_64]# rpm -U logfilemgmt-0.1.2-0.x86_64.rpm
#error: Failed dependencies:
#        rpmlib(FileDigests) <= 4.6.0-1 is needed by logfilemgmt-0.1.2-0.x86_64
#        rpmlib(PayloadIsXz) <= 5.2-1 is needed by logfilemgmt-0.1.2-0.x86_64
%define _source_filedigest_algorithm md5
%define _binary_filedigest_algorithm md5
%define _source_payload nil
%define _binary_payload nil

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
  # status returns 0 if the service is running, we only restart it if it is
  service %{service} status > /dev/null && service rsyslog stop
  service %{service} start
fi

%postun
# see above
if [ "$1" = 0 ]; then
  rm -rf %{prefix}/%{name}
fi

