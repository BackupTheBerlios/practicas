PROJECTNAME=@PROJECT_NAME@

all : ps pdf

ps : dvi
	dvips -o ${PROJECTNAME}.ps ${PROJECTNAME}.dvi

dvi :
	latex ${PROJECTNAME}.tex

clean :
	rm -f ${PROJECTNAME}.log  ${PROJECTNAME}.dvi ${PROJECTNAME}.ps ${PROJECTNAME}.pdf ${PROJECTNAME}.aux ${PROJECTNAME}.tar.gz

dist : clean all
	tar --exclude CVS --exclude *.aux --exclude *.log -zcvf  ${PROJECTNAME}.tar.gz *

pdf : dvi
	dvipdfm -p a4 $(PROJECTNAME).dvi

preview : ps
	gv ${PROJECTNAME}.ps
