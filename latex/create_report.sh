#! /bin/bash

file_name="report"
#file_name="diff2"

bash figure_tex.sh

rm *.aux *.bbl *.blg *.dvi *.log

pdflatex ${file_name}
bibtex ${file_name}
pdflatex ${file_name}
pdflatex ${file_name}


texcount -inc  ${file_name}.tex

# clean temporary files

rm *.aux *.bbl *.blg *.dvi *.log
