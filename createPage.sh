#!/bin/bash

# temperature log file
TFILE=/opt/temperature/log/temps.txt

# gnuplot scripts
GPall=/opt/temperature/bin/temps.p
GP48=/opt/temperature/bin/temps48.p

# all data
/usr/bin/gnuplot $GPall

# last xhrs
linesPerDay=288
days=3
let lines=$days*$linesPerDay
#echo $lines
T48FILE=/opt/temperature/log/temps48.txt
tail -$lines $TFILE > $T48FILE
/usr/bin/gnuplot $GP48 

# copy all the plots to the web server
cp /opt/temperature/plots/* /var/www

# get latest temp from the file
# format of temp file
# 2013-04-08 19:10:04 43.3 19.0 9.3
header=`tail -1 $TFILE`

# create the web page
# index.html
INDX=/tmp/index.html
echo "<html><head>" > $INDX 
echo "<meta http-equiv="refresh" content="300"></head>" >> $INDX 
echo "<body><h1>Temperatures</h1>" >> $INDX
echo "<p>UTC $header</p>" >> $INDX
echo "<img src="temps.png" alt="all temperatures"/>" >> $INDX
echo "<br><img src="temps48.png" alt="last few days"/>" >> $INDX
#echo "<br><img src="hourly.png" alt="hour"/>" >> $INDX
#echo "<br><img src="daily.png" alt="day"/>" >> $INDX
echo "<br><img src="weekly.png" alt="week"/>" >> $INDX
echo "<br><img src="monthly.png" alt="month"/>" >> $INDX
echo "<br><img src="yearlyout.png" alt="year outside"/>" >> $INDX
echo "<br><img src="yearlykitchen.png" alt="year kitchen"/>" >> $INDX

echo "<br><hr><pre>" >> $INDX
tail -20 $T48FILE >> $INDX
echo "</pre>" >> $INDX
echo "</body></html> " >> $INDX
rm $T48FILE

cp $INDX /var/www/index.html
#rm $INDX

