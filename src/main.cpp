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
  int rc;
  class openmqtt *om;

  mosqpp::lib_init();
  om = new openmqtt("openmqtt");

  if (om->init_connection()) {
    while(1) {
      rc = om->loop();
      if(rc) {
        om->reconnect();
      }
    }
  } else {
    std::cout << "Unable to connect to network.";
  }
  
  mosqpp::lib_cleanup();
  return(0);
}
