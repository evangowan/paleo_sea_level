#! /bin/bash

file_name="report2"

cat << END_CAT > temp/figure_parameters.sh
six_models="temp/compare_models.txt"
END_CAT

bash figure_tex.sh

rm *.aux *.bbl *.blg *.dvi *.log

# xelatex defaults to PDF version 1.5, so you have to manually set it to 1.7 to be compatible with psconvert PDF files
xelatex --output-driver="xdvipdfmx -v -V 7" ${file_name}
bibtex ${file_name}
xelatex --output-driver="xdvipdfmx -v -V 7" ${file_name}
xelatex --output-driver="xdvipdfmx -v -V 7" ${file_name}


texcount -inc  ${file_name}.tex

# clean temporary files

rm *.aux *.bbl *.blg *.dvi *.log
