CFLAGS=-Wall -ggdb -I../libraries/mosquitto/lib -I../libraries/mosquitto/lib/cpp
LDFLAGS=-L../../lib ../libraries/mosquitto/lib/cpp/libmosquittopp.so.1 ../libraries/mosquitto/lib/libmosquitto.so.1

.PHONY: all clean

all : openmqtt

openmqtt : main.o inireader.o ini.o openmqtt.o
	${CXX} $^ -o $@ ${LDFLAGS}

main.o : main.cpp
	${CXX} -c $^ -o $@ ${CFLAGS}

inireader.o : inireader.cpp
	${CXX} -c $^ -o $@ ${CFLAGS}

ini.o : ini.cpp
	${CXX} -c $^ -o $@ ${CFLAGS}

openmqtt.o : openmqtt.cpp
	${CXX} -c $^ -o $@ ${CFLAGS}

clean : 
	-rm -f *.o openmqtt
