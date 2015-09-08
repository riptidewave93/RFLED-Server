RFLED-Server
============

Python Scripts to run UDP servers to emulate a LimitlessLED WiFi Bridge 4.0 unit.

Install
=======

 * Change the variables in both scripts to meet your needs
 * Start the scripts and they will start the UDP listeners

Startup Script
==============

 * Ensure scripts are in /usr/local/bin/
 * Place script into /etc/init.d/
 * Run update-rc.d rfled-server defaults to set up
 
Running
=======

 * Run "/etc/init.d/rfled-server start" to start scripts without a restart
