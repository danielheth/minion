#!/bin/bash

#
# Make file for my "mqtt" C++ application
#
# note all cpp files must be listed here

g++ -Wall -W -Werror src/main.cpp src/ini.cpp src/INIReader.cpp -o bin/mqtt