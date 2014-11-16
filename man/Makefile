include ../config.mk

.PHONY : all clean install uninstall dist 

all :  openmqtt.8 openmqtt.conf.5

clean :

reallyclean : clean
	-rm -f *.orig

dist : openmqtt.8 openmqtt.conf.5

install :
	$(INSTALL) -d ${DESTDIR}$(mandir)/man8
	$(INSTALL) -m 644 openmqtt.8 ${DESTDIR}${mandir}/man8/openmqtt.8
	$(INSTALL) -d ${DESTDIR}$(mandir)/man5
	$(INSTALL) -m 644 openmqtt.conf.5 ${DESTDIR}${mandir}/man5/openmqtt.conf.5

uninstall :
	-rm -f ${DESTDIR}${mandir}/man8/openmqtt.8
	-rm -f ${DESTDIR}${mandir}/man5/openmqtt.conf.5

openmqtt.8 : openmqtt.8.xml
	$(XSLTPROC) $^

openmqtt.conf.5 : openmqtt.conf.5.xml manpage.xsl
	$(XSLTPROC) $<

potgen :
	 xml2po -o po/openmqtt/openmqtt.8.pot openmqtt.8.xml
	 xml2po -o po/openmqtt.conf/openmqtt.conf.5.pot openmqtt.conf.5.xml

# To merge new translations do:
# /usr/bin/xml2po -p de.po chapter1.xml > chapter1.de.xml
