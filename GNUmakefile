#
# Author: hans.riethmann@ortecin.ch
# $Id: GNUmakefile 2157 2009-12-03 12:50:12Z f476459 $
#

NAME		:= zalio
PREFIX		:= /opt
RELOC		:= reloc
DESTDIR		 =
CONFIG_FILES	 = $(PREFIX)/$(NAME)/etc/elasticsearch-snmp.conf \
                   (PREFIX)/$(NAME)/lib/SNMP/elasticsearch/oidmap.pm 
CONFIG_DIRS	 = 
CODE_OBJECTS	 = /usr/share/snmp/mibs/ZALIO-MIB.txt \
                   /usr/share/snmp/mibs/ZALIO-elasticsearch-MIB.txt

# .../share/man[0-9]/... must not be included, perl module man pages
# have file names like .../share/man/man3/LWP::Debug.3pm, where the '::'
# confuse the hell out of make
#CODE_FILES	 = $(subst $(RELOC),$(PREFIX),$(RELOC)/salt/bin/ramf2grains)
CODE_FILES	 = 
CODE_DIRS	 = 
CODE_OBJECTS	 = $(addprefix root/etc/rc.d/init.d/logstash-, concentrator collector web)

all::

OID             := $(patsubst .%,%,$(shell snmptranslate -IR -On zalEs))

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
