#!/bin/bash



J_options="-JR10/15c"
R_options="-Rg"

plot="data_map.ps"

circle_size=0.10
circle_pen=" -W0.3p,black "


gmt pscoast ${R_options} ${J_options} -Bx60 -By30  -P -Wfaint,black -Dc -A500 -G210 -K --FONT_TITLE=16p > ${plot}

gmt psxy test_sl.txt -R -J -P ${circle_pen} -Sc${circle_size} -Ggreen -O -K >> ${plot}


gmt psxy << END_CAT -Y-3 -X-3.2  -P -K -O -R0/1/0/1 -JX10/10  ${circle_pen} -Sc${circle_size} -Ggreen >> ${plot}
0.3 0.31
END_CAT

gmt pstext << END_CAT   -JX -R -P  -O -F+f8p+jBL >> ${plot}
0.33 0.3 Data location
END_CAT

gmt psconvert  ${plot}  -Tf -A
gmt psconvert  ${plot}  -Tg -A

rm ${plot}
