# OpenMqtt
OpenMqtt is striving to provide a management application for use across multiple platforms and uses the MQTT communications protocol.  The mqtt agent is being built to link into the OpenMqtt.org broker network and allow communications and control of millions of computers.

## Compiling Your Own Mqtt Agents
Compiling is extremely easy but does require a few things.

The following packages are required for openmqtt:

* tcp-wrappers (optional, package name libwrap0-dev)
* openssl (version 1.0.0 or greater if TLS-PSK support is needed)
* On Windows, the Redhat pthreads library is required if threading support is
  to be included.

To compile, run "make", but also see the file config.mk for more details on the
various options that can be compiled in.

Where possible use the Makefiles to compile. This is particularly relevant for
the client libraries as symbol information will be included.  Use cmake to
compile on Windows or Mac.

If you have any questions, problems or suggestions (particularly related to
installing on a more unusual device like a plug-computer) then please get in
touch using the details in readme.txt.


### Mosquitto Source

Mosquitto source which is available from http://mosquitto.org/download/.  
Find the mosquitto-1.3.2.tar.gz link and download it.  
Untar this into ./libraries/mosquitto


#### Compiling Mosquitto C++ Libraries for use...

>$ cd mosquitto/lib

>$ make

2. copy the resulting cpp file into the appropriate place on your system...

>$ sudo cp cpp/libmosquittopp.so.1 /lib/

This will create the required binaries for pulling into your projects.



