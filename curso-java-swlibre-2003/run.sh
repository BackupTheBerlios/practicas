#!/bin/sh

if [ "`tty | grep tty`" ]
then
	export DISPLAY=:2
	advi -g 1100x1000 -A -fullwidth curso-java-swlibre.dvi
else
	echo Debes estar en una terminal tty
fi
