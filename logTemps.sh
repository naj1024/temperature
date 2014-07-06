#!/bin/bash
# script to read temperature probes and log them to file and rrd database
#

# LOG directory for data files
LOG=/opt/temperature/log

readDs()
{
	# read the temperature probe
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
                	#echo "$dt $sensor $ds18b20 $count" >> $LOG/failed

			# 4 attempts to read good value
			if [ $count -gt 4 ]
			then
				p="YES"
			fi
        	fi
	done
}


createRrd()
{
	# create RRD databse to hold min,max,avg for hour,day,week,month,year
	name=$1

	# TEMPS every 300 seconds for 11 sources
	# timeout is 600 seconds
	# rra's of hour, day, week month and year
	# min average and max values
	rrdtool create $LOG/$name.rrd --start N --step 300 \
	DS:$name:GAUGE:600:-55:125 \
	RRA:MIN:0.5:1:12 \
	RRA:MIN:0.5:1:288 \
	RRA:MIN:0.5:12:168 \
	RRA:MIN:0.5:12:720 \
	RRA:MIN:0.5:288:365 \
	RRA:AVERAGE:0.5:1:12 \
	RRA:AVERAGE:0.5:1:288 \
	RRA:AVERAGE:0.5:12:168 \
	RRA:AVERAGE:0.5:12:720 \
	RRA:AVERAGE:0.5:288:365 \
	RRA:MAX:0.5:1:12 \
	RRA:MAX:0.5:1:288 \
	RRA:MAX:0.5:12:168 \
	RRA:MAX:0.5:12:720 \
	RRA:MAX:0.5:288:365 
}


# insert the modules
# added w1-gpio and w1-therm to /etc/modules
# so should already be loaded at boot
#modprobe w1-gpio
#modprobe w1-therm

# check that we have the modules installed
mods=`lsmod | grep w1_therm`
if [ "$mods" == "" ]
then
	echo "w1-gpio and w1-therm modules not loaded"
	exit 1
fi

# list of ds sensors
probes=`ls /sys/devices/w1_bus_master1/ | grep 28-`

if [ -d $LOG ]
then
	mkdir -p $LOG
	if [ ! -d $LOG ]
	then
		echo "Cant create $LOG directory"
		exit 1
	fi
fi

# log each sensor in its own file
for probe in $probes
do
	readDs $probe
	if [ "$tempR" != "" ]
	then
		temp=$tempR

		# date format
		dt=`date +"%F %X" -u`
		
		# log raw values to text file
		echo "$dt $temp" >> $LOG/$probe.txt

		# rrd databases
		if [ ! -f $LOG/$probe.rrd ]
		then
			createRrd $probe
		fi
		err=`/usr/bin/rrdtool update $LOG/$probe.rrd N:$temp:`
	fi
done


