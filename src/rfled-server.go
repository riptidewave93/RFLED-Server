package main

import (
        "bufio"
        "bytes"
        "flag"
        "log"
        "net"
        "os/user"
        "strconv"
        "github.com/tarm/serial"
)

// Logging function used by the application
// w: false = log, true = fatal
// x: debug flag
// y: false = not debug output, true = debug output
// z: message
func applog(w bool, x bool, y bool, z string) {
        if x && y {
                if !w {
                        log.Printf("DEBUG: %q \n", z)
                } else {
                        log.Fatal("DEBUG: ", z)
                }
        } else if !y {
                if !w {
                        log.Printf("%q \n", z)
                } else {
                        log.Fatal(z)
                }
        }
}

// Used to clean up all the error checks we do
func error_check(err error, log bool) {
        if err != nil {
                applog(true, log, false, err.Error())
        }
}

// Function to handle requests to the LED server shit
func led_req(conn net.Conn, log bool, s *serial.Port) {
        // Read message into buffer
        buf, err := bufio.NewReader(conn).ReadBytes('\n')
        error_check(err,log)
        // remove \n as we only use that to know we got the end of input
        buf = bytes.Trim(buf, "\x0a")
        applog(false, log, true, "LED: message was " + string(buf))

        // now we have the message, send via serial
        _, err = s.Write(buf)
        error_check(err,log)

        // Close the connection when you're done with it.
        conn.Close()
}

func main() {
        // Set our UART vars
        comport := flag.String("serial", "/dev/ttyAMA0", "Serial device to use")
        comspeed := flag.Int("baud", 9600, "Serial baudrate")
        debug := flag.Bool("debug", false, "Enable verbose debugging")

        // Set our IP vars
        ip := flag.String("ip", "0.0.0.0", "IP address to listen on")
        //adm_port := flag.Int("admport", 48899, "Port for the admin server")
        led_port := flag.Int("ledport", 8899, "Port for the led server")
        flag.Parse()

        // Check if we are root
        usr,err := user.Current()
        if usr.Uid != "0" {
                applog(true, *debug, false, "Not running as root, exiting!")
        }
        error_check(err,*debug)

        // load serial connection
        c := &serial.Config{Name: *comport, Baud: *comspeed}
        s, err := serial.OpenPort(c)
        error_check(err,*debug)

        // Start Admin server

        // Start LED server
        led_listen, err := net.Listen("tcp", *ip+":"+strconv.Itoa(*led_port))
        error_check(err,*debug)
        defer led_listen.Close()

        // Start main app loop!
        applog(false, *debug, false, "rfled-server started!")
        for {
                // Function for Admin Server

                // Function for LED Server
                led_sock, err := led_listen.Accept()
                error_check(err,*debug)
                go led_req(led_sock, *debug, s)
        }
}
