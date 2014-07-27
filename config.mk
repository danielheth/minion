# =============================================================================
# User configuration section.
#
# Largely, these are options that are designed to make minion run
# easily in restrictive environments by removing features.
#
# Modify the variable below to enable/disable features.
#
# Can also be overriden at the command line, e.g.:
#
# make WITH_TLS=no
# =============================================================================





# =============================================================================
# End of user configuration
# =============================================================================


# Also bump lib/minion.h, lib/python/setup.py, CMakeLists.txt,
# installer/minion.nsi, installer/minion-cygwin.nsi
VERSION=0.0.1
TIMESTAMP:=$(shell date "+%F %T%z")

# Client library SO version. Bump if incompatible API/ABI changes are made.
SOVERSION=1

# Man page generation requires xsltproc and docbook-xsl
XSLTPROC=xsltproc
# For html generation
DB_HTML_XSL=man/html.xsl

#MANCOUNTRIES=en_GB

UNAME:=$(shell uname -s)
ifeq ($(UNAME),SunOS)
	ifeq ($(CC),cc)
		CFLAGS?=-O
	else
		CFLAGS?=-Wall -ggdb -O2
	endif
else
	CFLAGS?=-Wall -ggdb -O2
endif

LIB_CFLAGS:=${CFLAGS} ${CPPFLAGS} -I. -I.. -I../lib
LIB_CXXFLAGS:=$(LIB_CFLAGS) ${CPPFLAGS}
LIB_LDFLAGS:=${LDFLAGS}

BROKER_CFLAGS:=${LIB_CFLAGS} ${CPPFLAGS} -DVERSION="\"${VERSION}\"" -DTIMESTAMP="\"${TIMESTAMP}\"" -DWITH_BROKER
CLIENT_CFLAGS:=${CFLAGS} ${CPPFLAGS} -I../lib -DVERSION="\"${VERSION}\""

ifeq ($(UNAME),FreeBSD)
	BROKER_LIBS:=-lm
else
	BROKER_LIBS:=-ldl -lm
endif
LIB_LIBS:=
PASSWD_LIBS:=

ifeq ($(UNAME),Linux)
	BROKER_LIBS:=$(BROKER_LIBS) -lrt
	LIB_LIBS:=$(LIB_LIBS) -lrt
endif

CLIENT_LDFLAGS:=$(LDFLAGS) -L../lib ../lib/libminion.so.${SOVERSION}

ifeq ($(UNAME),SunOS)
	ifeq ($(CC),cc)
		LIB_CFLAGS:=$(LIB_CFLAGS) -xc99 -KPIC
	else
		LIB_CFLAGS:=$(LIB_CFLAGS) -fPIC
	endif

	ifeq ($(CXX),CC)
		LIB_CXXFLAGS:=$(LIB_CXXFLAGS) -KPIC
	else
		LIB_CXXFLAGS:=$(LIB_CXXFLAGS) -fPIC
	endif
else
	LIB_CFLAGS:=$(LIB_CFLAGS) -fPIC
	LIB_CXXFLAGS:=$(LIB_CXXFLAGS) -fPIC
endif

ifneq ($(UNAME),SunOS)
	LIB_LDFLAGS:=$(LIB_LDFLAGS) -Wl,--version-script=linker.version -Wl,-soname,libminion.so.$(SOVERSION)
endif

ifeq ($(UNAME),QNX)
	BROKER_LIBS:=$(BROKER_LIBS) -lsocket
	LIB_LIBS:=$(LIB_LIBS) -lsocket
endif

ifeq ($(WITH_WRAP),yes)
	BROKER_LIBS:=$(BROKER_LIBS) -lwrap
	BROKER_CFLAGS:=$(BROKER_CFLAGS) -DWITH_WRAP
endif

ifeq ($(WITH_TLS),yes)
	BROKER_LIBS:=$(BROKER_LIBS) -lssl -lcrypto
	LIB_LIBS:=$(LIB_LIBS) -lssl -lcrypto
	BROKER_CFLAGS:=$(BROKER_CFLAGS) -DWITH_TLS
	LIB_CFLAGS:=$(LIB_CFLAGS) -DWITH_TLS
	PASSWD_LIBS:=-lcrypto
	CLIENT_CFLAGS:=$(CLIENT_CFLAGS) -DWITH_TLS

	ifeq ($(WITH_TLS_PSK),yes)
		BROKER_CFLAGS:=$(BROKER_CFLAGS) -DWITH_TLS_PSK
		LIB_CFLAGS:=$(LIB_CFLAGS) -DWITH_TLS_PSK
		CLIENT_CFLAGS:=$(CLIENT_CFLAGS) -DWITH_TLS_PSK
	endif
endif

ifeq ($(WITH_THREADING),yes)
	LIB_LIBS:=$(LIB_LIBS) -lpthread
	LIB_CFLAGS:=$(LIB_CFLAGS) -DWITH_THREADING
endif

ifeq ($(WITH_STRICT_PROTOCOL),yes)
	LIB_CFLAGS:=$(LIB_CFLAGS) -DWITH_STRICT_PROTOCOL
	BROKER_CFLAGS:=$(BROKER_CFLAGS) -DWITH_STRICT_PROTOCOL
endif

ifeq ($(WITH_BRIDGE),yes)
	BROKER_CFLAGS:=$(BROKER_CFLAGS) -DWITH_BRIDGE
endif

ifeq ($(WITH_PERSISTENCE),yes)
	BROKER_CFLAGS:=$(BROKER_CFLAGS) -DWITH_PERSISTENCE
endif

ifeq ($(WITH_MEMORY_TRACKING),yes)
	ifneq ($(UNAME),SunOS)
		BROKER_CFLAGS:=$(BROKER_CFLAGS) -DWITH_MEMORY_TRACKING
	endif
endif

#ifeq ($(WITH_DB_UPGRADE),yes)
#	BROKER_CFLAGS:=$(BROKER_CFLAGS) -DWITH_DB_UPGRADE
#endif

ifeq ($(WITH_SYS_TREE),yes)
	BROKER_CFLAGS:=$(BROKER_CFLAGS) -DWITH_SYS_TREE
endif

ifeq ($(WITH_SRV),yes)
	LIB_CFLAGS:=$(LIB_CFLAGS) -DWITH_SRV
	LIB_LIBS:=$(LIB_LIBS) -lcares
endif

ifeq ($(UNAME),SunOS)
	BROKER_LIBS:=$(BROKER_LIBS) -lsocket -lnsl
	LIB_LIBS:=$(LIB_LIBS) -lsocket -lnsl
endif


INSTALL?=install
prefix=/usr/local
mandir=${prefix}/share/man
localedir=${prefix}/share/locale
STRIP?=strip
