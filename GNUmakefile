#
# Author: hans.riethmann@ortecin.ch
# $Id: GNUmakefile 2157 2009-12-03 12:50:12Z f476459 $
#

NAME		:= zalio
PREFIX		:= /opt
RELOC		:= reloc
DESTDIR		 =
CONFIG_FILES	 = $(PREFIX)/$(NAME)/etc/elasticsearch-snmp.conf
CONFIG_DIRS	 = 
CODE_OBJECTS	 = 

# .../share/man[0-9]/... must not be included, perl module man pages
# have file names like .../share/man/man3/LWP::Debug.3pm, where the '::'
# confuse the hell out of make
#CODE_FILES	 = $(subst $(RELOC),$(PREFIX),$(RELOC)/salt/bin/ramf2grains)
CODE_FILES	 = 
CODE_DIRS	 = 
CODE_OBJECTS	 = $(addprefix root/etc/rc.d/init.d/logstash-, concentrator collector web)

all::

OID             := $(patsubst .%,%,$(shell snmptranslate -IR -On zalEs))
MIBNAME         := ZALIO-elasticsearch-MIB
x:
	echo RELOC $(RELOC)

mib: $(RELOC)/$(NAME)/lib/agent_$(OID).pl
$(RELOC)/$(NAME)/lib/agent_$(OID).pl: root/usr/share/snmp/mibs/$(MIBNAME).txt tools/mib2c.perl.conf
	@$(ING-MESSAGE) creat $@
	$(ATSIGN)\
	cd $(@D); \
	mib2c -c $(PWD)/tools/mib2c.perl.conf $(OID)



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
