#!/usr/bin/env python

import socket

# Set admin server settings
UDP_IP = '' # Leave empty for Broadcast support
ADMIN_PORT = 48899

# Local settings of your Raspberry Pi, used for app discovery
INT_IP = '10.0.1.61'
INT_MAC = '111a02bf232b'

# Code Starts Here #

# Create UDP socket, bind to it
adminsock = socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
adminsock.bind((UDP_IP, ADMIN_PORT))

# Loop forever
while True:
    admindata, adminaddr = adminsock.recvfrom(64) # buffer size is 64 bytes
    # Did we get a message?
    if admindata is not None: 
        # print("admin command: ", str(admindata)) # Debugging
        # If the client app is syncing to a unit
        if str(admindata).find("Link_Wi-Fi") != -1:
            RETURN = INT_IP + ',' + INT_MAC + ',' # Return our IP/MAC 
            # print("admin return: ", RETURN) # Debugging
            adminsock.sendto(bytes(RETURN, "utf-8"),adminaddr) # Send Response
        else:
            adminsock.sendto(bytes('+ok', "utf-8"),adminaddr) # Send OK for each packet we get
    else:
        break