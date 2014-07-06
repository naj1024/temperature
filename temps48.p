set output "/opt/temperature/plots/temps48.png"
set terminal png
set xdata time
set timefmt "%Y-%m-%d %H:%M:%S"
#set grid ytics lt 0

set mytics 
set style line 12 lc rgb '#ddccdd' lt 1 lw 1.5 
set style line 13 lc rgb '#ddccdd' lt 0 lw 0.5 
set grid ytics mytics back ls 12, ls 13

set xlabel "hour (UTC)"
set ylabel "degrees Celsius"

set format x "%H"
plot [][0:60] "/opt/temperature/log/temps48.txt" using 1:4 title "outlet" with lines, "/opt/temperature/log/temps48.txt" using 1:5 title "inlet" with lines 


