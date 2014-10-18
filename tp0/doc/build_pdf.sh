#!/bin/sh
latex informe.tex
latex informe.tex
dvipdf informe.dvi
rm informe.dvi informe.aux informe.log
# scp -P443 informe.pdf facutk@home.facu.tk:taptrack/static/
