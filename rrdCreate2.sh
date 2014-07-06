#!/bin/bash 
# TEMPS every 300 seconds for 11 sources
# timeout is 600 seconds
# rra's of hour, day, week month and year
# min average and max values
rrdtool create /opt/temperature/temperature.rrd --start N --step 300 \
DS:outsouth:GAUGE:600:-55:125 \
DS:kitchen:GAUGE:600:-55:125 \
DS:livingroom:GAUGE:600:-55:125 \
DS:utility:GAUGE:600:-55:125 \
DS:garage:GAUGE:600:-55:125 \
DS:fdoor:GAUGE:600:-55:125 \
DS:backbedroom:GAUGE:600:-55:125 \
DS:frontbedroom:GAUGE:600:-55:125 \
DS:sidebedroom:GAUGE:600:-55:125 \
DS:outnorth:GAUGE:600:-55:125 \
DS:attic:GAUGE:600:-55:125 \
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
