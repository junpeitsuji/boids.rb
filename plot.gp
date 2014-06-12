set datafile separator ","
set xlabel "longitude"
set ylabel "latitude"
set key left top
plot "log.csv" u 3:4 t "#1", "log.csv" u 9:10 t "#2", "log.csv" u 15:16 t "#3"
pause -1
