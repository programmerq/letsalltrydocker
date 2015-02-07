default: README.pdf README.html

README.pdf: README.tex
	pdflatex README.tex || pdflatex README.tex

README.tex: README.md default.latex beforebody.txt afterbody.txt inheader.txt Makefile
	#cat README.md | pandoc --template=default.latex -f markdown -t latex -B beforebody.txt -A afterbody.txt -H inheader.txt -V geometry:margin=0.25in -o README.tex
	#cat README.md | pandoc --template=default.latex -f markdown -t latex -B beforebody.txt -A afterbody.txt -H inheader.txt -V geometry:margin=0.5in -o README.tex
	cat README.md | pandoc --template=default.latex -f markdown -t latex -B beforebody.txt -A afterbody.txt -H inheader.txt -V geometry:left=0.25in,top=0.25in,right=0.25in,bottom=0.75in -o README.tex
	#cat README.md | pandoc --template=default.latex -f markdown -t latex -B beforebody.txt -A afterbody.txt -H inheader.txt -o README.tex

README.html: README.md buttondown.css
	cat README.md | pandoc -f markdown -t html -c buttondown.css -o README.html
