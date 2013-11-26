ultrasoniccyclecounter
======================

Arduino and Ruby code to count open-close cycles of a target object using an ultrasonic range sensor.

The Arduino code is housed within the UltrasonicCycleCounter directory. client.rb is the CLI Ruby client for the Arduino.

Usage: ruby client.rb [serial_port] [inches_to_target]

Example: ruby client.rb /dev/ttyACM0 40

See the Innovations Technology Solutions blog for more details on this project. http://innovationsts.com/?p=4458 

