/*
Copyright (c) 2014 OpenMqtt <daniel@openmqtt.org>
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice,
   this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
3. Neither the name of mosquitto nor the names of its
   contributors may be used to endorse or promote products derived from
   this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
*/

#include <cstdio>
#include <cstring>

#include "openmqtt.h"

#include <iostream>
#include <fstream>
#include "ini.h"
#include "inireader.h"

#include <mosquittopp.h>
#include <iostream>

openmqtt::openmqtt(const char *id) : mosquittopp(id)
{
	//FIRST LOAD THE CONFIGURATION FILE AND ALL VALUES
	std::fstream fs;

	INIReader reader("openmqtt.conf");

	if (reader.ParseError() < 0) {
		//can't open local conf file, try system conf file
		INIReader reader("/etc/openmqtt/openmqtt.conf");
		if (reader.ParseError() < 0) {
			//std::cout << "Can't load 'openmqtt.conf'\n";
			printf("Can't load 'openmqtt.conf'!");
		}
	}
	url = reader.Get("NETWORK", "url", "");
	port = reader.GetInteger("NETWORK", "port", 1883);
	cert = reader.Get("NETWORK", "cert", "");
	if (cert.length() > 0) {
		fs.open(cert.c_str());
		if (fs.is_open() != true) {
		    //std:cout << "Specified cert file does not exist!\n";
		    printf("Specified cert file does not exist!");
		}
		fs.close();
	}
};

bool openmqtt::init_connection() 
{
	int keepalive = 60;

	std::cout << "Initiating connection to "
            << "" << url
            << " (" << port
            << ")\n";

	std::string guid = newUUID();
	std::cout << "guid=" << guid << "\n";

	/* Connect immediately. This could also be done by calling
	 * openmqtt->connect(). */
	if (url.length() > 0) {
		connect(url.c_str(), port, keepalive);
		return 1;
	} else {
		return 0;
	}
};

void openmqtt::on_connect(int rc)
{
	printf("Connected with code %d.\n", rc);
	if (rc == 0) {
		/* Only attempt to subscribe on a successful connect. */
		subscribe(NULL, "temperature/celsius");
	}
};

void openmqtt::on_subscribe(int mid, int qos_count, const int *granted_qos)
{
	printf("Subscription succeeded.\n");
};

void openmqtt::on_message(const struct mosquitto_message *message)
{
	double temp_celsius, temp_farenheit;
	char buf[51];

	if(!strcmp(message->topic, "temperature/celsius")){
		memset(buf, 0, 51*sizeof(char));
		/* Copy N-1 bytes to ensure always 0 terminated. */
		memcpy(buf, message->payload, 50*sizeof(char));
		temp_celsius = atof(buf);
		temp_farenheit = temp_celsius*9.0/5.0 + 32.0;
		snprintf(buf, 50, "%f", temp_farenheit);
		publish(NULL, "temperature/farenheit", strlen(buf), buf);
	}
};



std::string openmqtt::newUUID() {
#ifdef WIN32
    UUID uuid;
    UuidCreate ( &uuid );

    unsigned char * str;
    UuidToStringA ( &uuid, &str );

    std::string s( ( char* ) str );

    RpcStringFreeA ( &str );
#else
    uuid_t uuid;
    uuid_generate_random ( uuid );
    char s[37];
    uuid_unparse ( uuid, s );
#endif
    return s;
};