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

#include <string>
#include <stdio.h>
#include <iostream>
#include <fstream>
#include "ini.h"
#include "inireader.h"
#include <mosquittopp.h>
#include "openmqtt.h"

//#include <urlmon.h>

/*
bool fexists(const std::string& filename)
{
  ifstream ifile(filename.c_str());
  return !ifile.good();
} //Usage:  fexists("first.ini) = boolean
*/

int main(int argc, char *argv[])
{
  std::fstream fs;
  std::string server_url;
  int server_port;
  std::string server_cert;
  
  INIReader reader("openmqtt.conf");

  if (reader.ParseError() < 0) {
        //std::cout << "Can't load 'openmqtt.conf'\n";
        printf("Can't load 'openmqtt.conf'!");
        return 1;
  }
  server_url = reader.Get("SERVER", "url", "");
  server_port = reader.GetInteger("SERVER", "port", 1883);
  server_cert = reader.Get("SERVER", "cert", "");
  if (server_cert.length() > 0) {
    fs.open (server_cert.c_str());
    if (fs.is_open() != true) {
        //std:cout << "Specified cert file does not exist!\n";
        printf("Specified cert file does not exist!");
        return 1;
    }
    fs.close();
  }

  /*
  std::cout << "Config loaded from 'openmqtt.conf': "
            << "url=" << reader.Get("SERVER", "url", "")
            << ", port=" << reader.GetInteger("SERVER", "port", -1)
            << ", cert=" << reader.Get("SERVER", "cert", "")
            << "\n";
  */

  //std::cout << "downloading uuidgen...";
  //HRESULT hr = URLDownloadToFile ( NULL, _T("https://filerepo.org/uuidgen.exe"), _T("uuidgen.exe"), 0, NULL );
  //std::cout << "Done!" << endl;


  class mqtt_openmqtt *openmqtt;
  int rc;

  mosqpp::lib_init();

  openmqtt = new mqtt_openmqtt("openmqtt", server_url.c_str(), server_port);
  
  while(1){
    rc = openmqtt->loop();
    if(rc){
      openmqtt->reconnect();
    }
  }

  mosqpp::lib_cleanup();



  return(0);
}






