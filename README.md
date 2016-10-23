RFLED-Server
==========

Golang binary to emulate a LimitlessLED WiFi Bridge 4.0 unit.

Install
----
  1. Download the latest release from the [Releases](https://github.com/riptidewave93/RFLED-Server/releases)
   page for your architecture.
  2. Copy the contents of ./rfled-server/* to / on your disk as root
  3. Configure your settings in /etc/default/rfled-server as needed
  4. Enable the init.d script `systemctl enable rfled-server`
  5. Start the service `service rfled-server start`
  6. ???
  7. Profit!

Build from Source
----
  1. Setup a go build environment, and run `./build.sh`
  2. Once ran, you can run `./build.sh package` as root to generate a release .tar.gz
  3. Follow the above Install steps with the tar.gz in ./releases for your architecture.
  4. ?????
  5. Profit!
  
Other Forks
----

You may also interested in:

* Updated python fork that supports multiple bridges: [pfink/rfled-server-python](https://github.com/pfink/rfled-server-python)
