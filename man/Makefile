include ../config.mk

.PHONY : all clean install uninstall dist 

all :  minion.8 minion.conf.5

clean :

reallyclean : clean
	-rm -f *.orig

dist : minion.8 minion.conf.5

install :
	$(INSTALL) -d ${DESTDIR}$(mandir)/man8
	$(INSTALL) -m 644 minion.8 ${DESTDIR}${mandir}/man8/minion.8
	$(INSTALL) -d ${DESTDIR}$(mandir)/man5
	$(INSTALL) -m 644 minion.conf.5 ${DESTDIR}${mandir}/man5/minion.conf.5

uninstall :
	-rm -f ${DESTDIR}${mandir}/man8/minion.8
	-rm -f ${DESTDIR}${mandir}/man5/minion.conf.5

minion.8 : minion.8.xml
	$(XSLTPROC) $^

minion.conf.5 : minion.conf.5.xml manpage.xsl
	$(XSLTPROC) $<

potgen :
	 xml2po -o po/minion/minion.8.pot minion.8.xml
	 xml2po -o po/minion.conf/minion.conf.5.pot minion.conf.5.xml

# To merge new translations do:
# /usr/bin/xml2po -p de.po chapter1.xml > chapter1.de.xml
