default: handout.pdf handout.html instructions.html

handout.pdf: handout.tex
	pdflatex handout.tex || pdflatex handout.tex

handout.tex: handout.md default.latex beforebody.txt afterbody.txt inheader.txt Makefile
	#cat handout.md | pandoc --template=default.latex -f markdown -t latex -B beforebody.txt -A afterbody.txt -H inheader.txt -V geometry:margin=0.25in -o handout.tex
	#cat handout.md | pandoc --template=default.latex -f markdown -t latex -B beforebody.txt -A afterbody.txt -H inheader.txt -V geometry:margin=0.5in -o handout.tex
	cat handout.md | pandoc --template=default.latex -f markdown -t latex -B beforebody.txt -A afterbody.txt -H inheader.txt -V geometry:left=0.25in,top=0.25in,right=0.25in,bottom=0.75in -o handout.tex
	#cat handout.md | pandoc --template=default.latex -f markdown -t latex -B beforebody.txt -A afterbody.txt -H inheader.txt -o handout.tex

handout.html: handout.md buttondown.css
	cat handout.md | pandoc -f markdown -t html -c buttondown.css -o handout.html

instructions.html: instructions.md buttondown.css
	cat instructions.md | pandoc -f markdown -t html -c buttondown.css -o instructions.html
