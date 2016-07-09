#!/usr/bin/env python

import socket
import serial

# Set LED Control server settings
UDP_IP = '' # Leave empty for Broadcast support
LED_PORT = 8899

# Serial Settings
TTL_PORT = "/dev/ttyAMA0"
TTL_SPEED = 9600
ser = serial.Serial(TTL_PORT, TTL_SPEED) # Connect to serial

# Create UDP socket, bind to it
sock = socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
sock.bind((UDP_IP, LED_PORT))

while True:
    data, addr = sock.recvfrom(64) # buffer size is 64 bytes

    if data is not None:
        # print("led command: ", str(data)) # Debugging
        ser.write(data[:2]) # Write packet data out (2 bytes only)
