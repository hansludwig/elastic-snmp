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
                   $(PREFIX)/$(NAME)/opennms/elasticsearch.xml \
                   /etc/snmp/snmp.conf \
                   /etc/snmp/snmpd.local.conf
CONFIG_DIRS	 = 
CODE_FILES	 = $(PREFIX)/$(NAME)/bin/es-agentx \
                   $(PREFIX)/$(NAME)/lib/SNMP/elasticsearch.pm \
                   /etc/rc.d/init.d/esagentx \
                   /usr/share/snmp/mibs/ZALIO-MIB.txt \
                   /usr/share/snmp/mibs/ZALIO-elasticsearch-MIB.txt
CODE_DIRS	 = 

all::

mib: $(RELOC)/$(NAME)/lib/SNMP/elasticsearch/oidmap.pm

salt: $(RELOC)/$(NAME)/opennms/elasticsearch.xml
	scp $< oti-5701:/home/salt/prod/service/monitoring/files/datacollection_elasticsearch.xml

$(RELOC)/$(NAME)/lib/SNMP/elasticsearch/oidmap.pm: tools/mib2c.elasticsearch.conf root/usr/share/snmp/mibs/ZALIO-elasticsearch-MIB.txt 
	@$(ING-MESSAGE) creat $@
	$(ATSIGN)\
	export MIBS=ALL; \
        export MIBDIRS="+$(PWD)/root/usr/share/snmp/mibs"; \
	mkdir -p $(@D); \
	cd $(@D); \
	mib2c -c $(PWD)/$< $(OID)

$(PREFIX)/$(NAME)/lib/SNMP/elasticsearch/oidmap.pm: $(RELOC)/$(NAME)/lib/SNMP/elasticsearch/oidmap.pm

$(RELOC)/$(NAME)/opennms/elasticsearch.xml: tools/mib2c.opennms.conf root/usr/share/snmp/mibs/ZALIO-elasticsearch-MIB.txt
	@$(ING-MESSAGE) creat $@
	$(ATSIGN)\
	export MIBS=ALL; \
        export MIBDIRS="+$(PWD)/root/usr/share/snmp/mibs"; \
	mkdir -p $(@D); \
	cd $(@D); \
	mib2c -c $(PWD)/$< $(OID)

$(PREFIX)/$(NAME)/opennms/elasticsearch.xml: $(RELOC)/$(NAME)/opennms/elasticsearch.xml

root/usr/share/snmp/mibs/ZALIO-elasticsearch-MIB.txt: ZALIO-elasticsearch-MIB

ZALIO-elasticsearch-MIB:
	@$(ING-MESSAGE) lint $@
	$(ATSIGN)\
	export SMIPATH=root/usr/share/snmp/mibs; \
	smilint $@ 2>&1 | sed 's|^|>>> |'

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
	$(RM)r $(RELOC)/$(NAME)/lib/SNMP/elasticsearch
	$(RM) $(RELOC)/$(NAME)/opennms/elasticsearch.xml

