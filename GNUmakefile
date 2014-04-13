#
# Author: hans.riethmann@ortecin.ch
# $Id: GNUmakefile 2157 2009-12-03 12:50:12Z f476459 $
#

NAME		:= elasticsearch-snmp
# The OID of       ZALIO-elasticsearch-MIB::zalEs
OID             := .1.3.6.1.4.1.43278.10.10
PREFIX		:= /opt
RELOC		:= reloc
DESTDIR		 =
CONFIG_FILES	 = $(PREFIX)/$(NAME)/etc/elasticsearch-snmp.conf \
                   $(PREFIX)/$(NAME)/lib/SNMP/elasticsearch/oidmap.pm \
                   /etc/snmp/snmp.conf \
                   /etc/snmp/snmpd.local.conf \
                   /etc/sysconfig/snmpd
CONFIG_DIRS	 = 
CODE_FILES	 = $(PREFIX)/$(NAME)/bin/es-agentx \
                   $(PREFIX)/$(NAME)/lib/SNMP/elasticsearch.pm \
                   /usr/share/snmp/mibs/ZALIO-MIB.txt \
                   /usr/share/snmp/mibs/ZALIO-elasticsearch-MIB.txt
CODE_DIRS	 = 

all::

mib: $(RELOC)/$(NAME)/lib/SNMP/elasticsearch/oidmap.pm

$(RELOC)/$(NAME)/lib/SNMP/elasticsearch/oidmap.pm: tools/mib2c.elasticsearch.conf root/usr/share/snmp/mibs/ZALIO-elasticsearch-MIB.txt 
	@$(ING-MESSAGE) creat $@
	$(ATSIGN)\
	mkdir -p $(@D); \
	cd $(@D); \
	mib2c -c $(PWD)/$< $(OID)

$(PREFIX)/$(NAME)/lib/SNMP/elasticsearch/oidmap.pm: $(RELOC)/$(NAME)/lib/SNMP/elasticsearch/oidmap.pm

# make will not complain if this file does not exist, however
# without this things wont work! Makw sure it's there!
-include build/make.common

files-list-post: files-list
	@$(ING-MESSAGE) creat $@
	$(ATSIGN)\

# this assumes that BUILDROOT is underneath %_topdir
clean::
	$(RM) make*.out
	$(RM) rpmbuild.log
	$(RM) *.tmp
	$(RM) debug*.list
	$(RM) files.lst
	$(RM)r reloc/$(NAME)/lib/SNMP/elasticsearch

