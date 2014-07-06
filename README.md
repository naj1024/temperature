# README #

Scripts to read DS18B20 temperature probes on a raspberry pi.

### What is this repository for? ###

* Hacked together code that does the job in bash scripting

### How do I get set up? ###

* Create directories 
```
     /opt/temperature/bin
     /opt/temperature/log
     /opt/temperature/plots
```
* Copy the code to /opt/temperature/bin
* Have Apache2 installed
* Have gnuplot installed
* Have DS18B20 sensors wired in
* RRD datbases in /opt/temperature/log
* Add crontabs for root 

```
#!script
     */1 * * * * /opt/temperature/bin/readTemps.sh
     */5 * * * * /opt/temperature/bin/createPage.sh
     0 * * * * /opt/temperature/bin/rrdGraphs.sh

     #*/1 * * * * /opt/temperature/bin/logTemps.sh
```

### Scripts ###
```
createPage.sh script to create a web page, also create gnuplot graphs
readTemps.sh  probe reading script
rrdCreate2.sh script to create rrd databases
rrdCreate.sh  script to create rrd databases
rrdGraphs.sh  script to generate rrd graphs
temps48.p     gnuplot script
temps.p       gnuplot script

logTemps.sh   new script to read individual probes to separate files
```

### Blog ###
Some more information available [here](http://usbspyder.blogspot.co.uk/)