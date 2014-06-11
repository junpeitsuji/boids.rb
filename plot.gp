set datafile separator ","
plot "log.csv" u 3:4, "log.csv" u 9:10, "log.csv" u 15:16
pause -1
