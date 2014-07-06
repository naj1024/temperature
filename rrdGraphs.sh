#!/bin/bash 
DIR="/opt/temperature/log/"
DIRG="/opt/temperature/plots"
RRD="$DIR/temperatures.rrd"
RRD2="$DIR/temperature.rrd"

#set to C/F for Celsius/Farenheight 
TEMP_SCALE="C"

#define the desired colors for the graphs 
INTEMP_COLOR="#CC0000" 
OUTTEMP_COLOR="#0000FF"
AVGCOLOUR="#00FF00"
MAXCOLOUR="#CC0000"
MINCOLOUR="#0000FF"

#hourly 
rrdtool graph $DIRG/hourly.png --start -4h \
-t"Boiler hour" -v"deg C" \
--legend-position="east" -u30 -l0 \
-w800 -h200 \
DEF:kitchen=$RRD:kitchen:AVERAGE \
LINE1:kitchen$INTEMP_COLOR:"Outlet" \
DEF:outsouth=$RRD:outsouth:AVERAGE \
LINE1:outsouth$OUTTEMP_COLOR:"Inlet"

#daily 
rrdtool graph $DIRG/daily.png --start -1d \
-t"Boiler day" -v"deg C" \
--legend-position="east" -u30 -l0 \
-w800 -h200 \
DEF:kitchen=$RRD:kitchen:AVERAGE \
LINE1:kitchen$INTEMP_COLOR:"Outlet" \
DEF:outsouth=$RRD:outsouth:AVERAGE \
LINE1:outsouth$OUTTEMP_COLOR:"Inlet"

#weekly 
rrdtool graph $DIRG/weekly.png --start -1w \
-t"Bolier week" -v"deg C" \
--legend-position="east" -u30 -l0 \
-w800 -h200 \
DEF:kitchen=$RRD:kitchen:AVERAGE \
DEF:outsouth=$RRD:outsouth:AVERAGE \
LINE1:kitchen$INTEMP_COLOR:"Outlet" \
LINE1:outsouth$OUTTEMP_COLOR:"Inlet"

#monthly 
rrdtool graph $DIRG/monthly.png --start -1m \
-t"Boiler month" -v"deg C" \
--legend-position="east" -u30 -l0 \
-w800 -h200 \
DEF:kitchen=$RRD2:kitchen:AVERAGE \
DEF:outsouth=$RRD2:outsouth:AVERAGE \
LINE1:kitchen$INTEMP_COLOR:"Outlet" \
LINE1:outsouth$OUTTEMP_COLOR:"Inlet"

#yearly outside
rrdtool graph $DIRG/yearlyout.png --start -1y \
-t"Boiler inlet year" -v"deg C" \
--legend-position="east" -u30 -l0 \
-w800 -h200 \
DEF:max=$RRD2:outsouth:MAX \
DEF:min=$RRD2:outsouth:MIN \
DEF:avg=$RRD:outsouth:AVERAGE \
LINE1:max$MAXCOLOUR:"max" \
LINE1:min$MINCOLOUR:"min" \
LINE1:avg$AVGCOLOUR:"avg"

#yearly kitchen
rrdtool graph $DIRG/yearlykitchen.png --start -1y \
-t"Boiler outlet year" -v"deg C" \
--legend-position="east" -u30 -l0 \
-w800 -h200 \
-u 40 -l0 -r \
DEF:max=$RRD2:kitchen:MAX \
DEF:min=$RRD2:kitchen:MIN \
DEF:avg=$RRD:kitchen:AVERAGE \
LINE1:max$MAXCOLOUR:"max" \
LINE1:min$MINCOLOUR:"min" \
LINE1:avg$AVGCOLOUR:"avg"


