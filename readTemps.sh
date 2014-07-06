#!/bin/bash
readDs()
{
	# uses global tempR to pass temperature back

	# which sensor to read
        sensor=$1
	
	# count of attempts to read the sensor
	let count=0

	# local variable to hold success/fail of read
	local p=""
        while [ "$p" != "YES" ]
	do
        	ds18b20=`cat /sys/bus/w1/devices/$sensor/w1_slave`
		#echo $ds18b20 " " $count
		# return contains YES if crc is good
		p=`echo $ds18b20 |grep "YES"`
		# empty is an error 
        	if [ "$p" != "" ] 
        	then
			temp=`echo $ds18b20 | awk ' { print $22 } '| cut -d= -f2`
			let tr3=$temp/1000
                	let tr3d=$temp%1000
                	let tr3d=$tr3d/100
                	tempR="$tr3.$tr3d"
			# 85 degrees is an error
			if [ "$tr3" != "85" ]
			then
				p="YES"
			fi
        	else
			let count=$count+1
                	tempR=""
			# log failed attempts for analysis
			#dt=`date +"%F %X" -u`
                	#echo "$dt $sensor $ds18b20 $count" >> /opt/temperature/log/failed

			# 4 attempts to read good value
			if [ $count -gt 4 ]
			then
				p="YES"
			fi
        	fi
	done
}

# insert the modules
# added w1-gpio and w1-therm to /etc/modules
# so should be loaded at boot
#modprobe w1-gpio
#modprobe w1-therm

probe1=28-000004ca9f02
probe2=28-000004cbdd81
probe3=28-000004cb5e44
probe4=28-000004cb1041
probe5=28-000004cba3e6

kitchen=$probe1
#28-000004a17b90
readDs $kitchen
tktchn=$tempR

outside=$probe2
#28-000004a17079
readDs $outside
toutsth=$tempR

living_room=28-000004a1cc9f
#readDs $living_room
#tlvrm=$tempR

# cpu temp
temp=`cat /sys/class/thermal/thermal_zone0/temp`
let t=temp/1000
let d=temp%1000
let d=$d/100
tcpu="$t.$d"

dt=`date +"%F %X" -u`

# set empty values to '.' so we dont loose registration on output
if [ "$tktchn" == "" ]
then
	tktchn="."
fi
if [ "$toutsth" == "" ]
then
        toutsth="."
fi
# log raw values to text file
echo $dt" "$tcpu $tktchn $toutsth >> /opt/temperature/log/temps.txt
#echo $dt" "$tcpu $tktchn $toutsth 

# log values to rd databases
# rrd 11 temperatures
# avg only
err=`/usr/bin/rrdtool update /opt/temperature/log/temperatures.rrd N:$toutsth:$tktchn:::::::::`
#echo "err $err"

# rrd with min,avg and max
err=`/usr/bin/rrdtool update /opt/temperature/log/temperature.rrd N:$toutsth:$tktchn:::::::::`
#echo "err $err"



