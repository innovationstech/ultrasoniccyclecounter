#  Author: Innovations Technology Solutions
#  www.innovationsts.com
#  Date: Nov, 25 2013
#  Version: v1.0
#  This library is free software; you can redistribute it and/or
#  modify it under the terms of the GNU Lesser General Public
#  License as published by the Free Software Foundation; either
#  version 2.1 of the License, or (at your option) any later version.
#
#  This software is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#  Lesser General Public License for more details.
#
#  You should have received a copy of the GNU Lesser General Public
#  License along with this software; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
require 'serialport'

# Make sure we got the right number of arguments
if ARGV.size < 2
  puts "Usage: ruby client.rb [serial_port] [inches_to_target]"
  puts "Example: ruby client.rb /dev/ttyACM0 40"

  exit
end

# Latch variables so we only trigger once on a close or open
is_open = false
is_closed = false

# Keeps track of the number of open-close cycles
cycle_count = 0

# Parameters used to set up the serial port
port_str  = ARGV[0] # The serial port is grabbed from the command line arguments
baud_rate = 9600
data_bits = 8
stop_bits = 1
parity = SerialPort::NONE
 
 # Set up the serial port with the settings from above
sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)

# We have to set the read timeout to a very high value or we may get partial reads
sp.read_timeout=(1000)

# Grab the distance to the target from the command line arguments
inches_to_target = ARGV[1].to_i

 # Wait to make sure the serial port is initialized
sleep(2)

# Loop forever reading from the serial port
while true do
	# Grab the next string from the serial port
	value = sp.gets.chomp
	
	# Check to see if we have a closed condition within a +/- 3 inch range (adjust as needed)
	if not value.nil? and value.to_i > inches_to_target - 3 and value.to_i < inches_to_target + 3
		# Make sure the target wasn't already closed
		if not is_closed
			#puts "Closed"

			# If the target was previously open we want to increment the cycle count
			if is_open
				# Keep track of the cycle count
				cycle_count += 1

				# Let the user know what the current cycle count is
				puts cycle_count
			end			

			# Flip the latch bits so that we only enter here once
			is_closed = true
			is_open = false
		end
	# We're outside the range the defines the closed condition
	else
		# Make sure the target wasn't already open
		if not is_open
			#puts "Open"

			# Flip the latch bits so that we only enter here once
			is_open = true
			is_closed = false
		end
	end
end