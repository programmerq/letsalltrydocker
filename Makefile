default: README.pdf

README.pdf: README.tex
	pdflatex README.tex || pdflatex README.tex

README.tex: README.md beforebody.txt afterbody.txt inheader.txt
	cat README.md | pandoc -f markdown -t latex -B beforebody.txt -A afterbody.txt -H inheader.txt -V geometry:margin=0.25in -o README.tex
