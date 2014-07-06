createPage.sh script to create a web page, also create gnuplot graphs
readTemps.sh  original probe reading script
rrdCreate2.sh script to create rrd databases
rrdCreate.sh  script to create rrd databases
rrdGraphs.sh  script to generate rrd graphs
temps48.p     gnuplot script
temps.p       gnuplot script

logTemps.sh   new script to read individualt probes to separate files

pi@pi1 $ sudo crontab -l
*/1 * * * * /opt/temperature/bin/readTemps.sh
*/5 * * * * /opt/temperature/bin/createPage.sh
0 * * * * /opt/temperature/bin/rrdGraphs.sh

*/1 * * * * /opt/temperature/bin/logTemps.sh

