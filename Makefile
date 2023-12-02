# Automatise la compilation des fichiers .tex

compiler := pdflatex
nb_weeks = $(shell ls -d Sem_* | sed 's/Sem_//g')
files_weeks = $(foreach nb, ${nb_weeks}, Sem_${nb}/Kholle_S${nb})
pdf_ouput = $(foreach f, ${files_weeks}, ${f}.pdf)
sources_tex = $(foreach f, ${files_weeks}, ${f}.tex)
final_output := Khôlles_Mathématiques.tex

all : ${final_output}

${final_output} : ${pdf_ouput}
	@cat begin_kholles.tex > Khôlles_Mathématiques.tex
	@for f in ${sources_tex}; do \
		sed -e '/\\documentclass/,/\\maketitle/d' -e '/\\end{document}/,//d' $$f >> ${final_output}; \
		echo $$f done; \
	done
	@cat end_kholles.tex >> ${final_output}
	pdflatex -synctex=1 -interaction=nonstopmode ${final_output} > /dev/null

%.pdf : %.tex
	cd $$(dirname $@) && ls && pdflatex -synctex=1 -interaction=nonstopmode $$(basename $<) > /dev/null && cd ..

.PHONY : clean

clean :
	rm -f *.log *.aux *.out *.synctex.gz *.toc *.gnuplot
