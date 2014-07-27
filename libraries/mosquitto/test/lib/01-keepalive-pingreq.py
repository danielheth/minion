#!/usr/bin/env python

# Test whether a client sends a pingreq after the keepalive time

# The client should connect to port 1888 with keepalive=4, clean session set,
# and client id 01-keepalive-pingreq
# The client should send a PINGREQ message after the appropriate amount of time
# (4 seconds after no traffic).

import inspect
import os
import subprocess
import socket
import sys
import time

# From http://stackoverflow.com/questions/279237/python-import-a-module-from-a-folder
cmd_subfolder = os.path.realpath(os.path.abspath(os.path.join(os.path.split(inspect.getfile( inspect.currentframe() ))[0],"..")))
if cmd_subfolder not in sys.path:
    sys.path.insert(0, cmd_subfolder)

import mosq_test

rc = 1
keepalive = 4
connect_packet = mosq_test.gen_connect("01-keepalive-pingreq", keepalive=keepalive)
connack_packet = mosq_test.gen_connack(rc=0)

pingreq_packet = mosq_test.gen_pingreq()
pingresp_packet = mosq_test.gen_pingresp()

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
sock.settimeout(10)
sock.bind(('', 1888))
sock.listen(5)

client_args = sys.argv[1:]
env = dict(os.environ)
env['LD_LIBRARY_PATH'] = '../../lib:../../lib/cpp'
try:
    pp = env['PYTHONPATH']
except KeyError:
    pp = ''
env['PYTHONPATH'] = '../../lib/python:'+pp
client = subprocess.Popen(client_args, env=env)

try:
    (conn, address) = sock.accept()
    conn.settimeout(keepalive+10)

    if mosq_test.expect_packet(conn, "connect", connect_packet):
        conn.send(connack_packet)

        if mosq_test.expect_packet(conn, "pingreq", pingreq_packet):
            time.sleep(1.0)
            conn.send(pingresp_packet)

            if mosq_test.expect_packet(conn, "pingreq", pingreq_packet):
                rc = 0

    conn.close()
finally:
    client.terminate()
    client.wait()
    sock.close()

exit(rc)

