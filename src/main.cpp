/*
 * main.cpp
 *
 *  Created on: May 12, 2014
 *      Author: daniel
 */
#include <stdio.h>
#include <iostream>
#include "ini.h"
#include "INIReader.h"

//#include <urlmon.h>

/*
bool fexists(const std::string& filename)
{
  ifstream ifile(filename.c_str());
  return !ifile.good();
} //Usage:  fexists("first.ini) = boolean
*/

int main()
{
  INIReader reader("mqtt.conf");

  if (reader.ParseError() < 0) {
        std::cout << "Can't load 'mqtt.conf'\n";
        return 1;
  }
  std::cout << "Config loaded from 'mqtt.conf': "
            << "url=" << reader.Get("MQTT", "url", "")
            << ", port=" << reader.GetInteger("MQTT", "port", -1)
            << ", cafile=" << reader.Get("MQTT", "cafile", "")
            << "\n";


  //std::cout << "downloading uuidgen...";
  //HRESULT hr = URLDownloadToFile ( NULL, _T("https://filerepo.org/uuidgen.exe"), _T("uuidgen.exe"), 0, NULL );
  //std::cout << "Done!" << endl;


  return(0);
}




