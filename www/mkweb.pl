#!/usr/bin/perl
#
# Crea una web basándose en plantillas
#
# Álvaro Sánchez-Mariscal <mariscal@di.uc3m.es>
#
# $Id: mkweb.pl,v 1.1 2003/03/25 11:21:45 mariscal Exp $
#

use strict;

# Constantes para las plantillas
my $TEMPLATES_DIR="templates";
my $TEMPLATE_HEADER="$TEMPLATES_DIR/header.html";
my $TEMPLATE_MEDIUM="$TEMPLATES_DIR/medium.html";
my $TEMPLATE_FOOTER="$TEMPLATES_DIR/footer.html";

# Otras constantes
my $WWW="/home/groups/practicas/htdocs";
my $SECTIONS_DIR="sections";
my $MAIN_FILE="main.html";
my $MENU_FILE="menu.html";
my $TITLE_FILE="title";
my $OUTPUT="output";

&test();
&clean();
&mk_dir($OUTPUT);
&process();
&create_index();
&include();


sub process () {
	my ($dir, $element,$title);
	opendir(SECTIONS, $SECTIONS_DIR) || die "No puedo abrir el directorio $SECTIONS_DIR: $!\n";
	while($element = readdir(SECTIONS)) {
		$dir="$SECTIONS_DIR/$element";
		if ("$element" ne "." && "$element" ne "..") {
			print "-> Sección: $element\n";
			print "-------------------------\n";
			&mk_dir("$OUTPUT/$element");
			$title=`cat $dir/$TITLE_FILE`;
			open FILE, ">>$OUTPUT/$element/index.html" or die "No puedo abrir $OUTPUT/$element/index.html\n";

			open HEADER, "$TEMPLATE_HEADER" or die "No puedo abrir $TEMPLATE_HEADER: $!\n";
			print "Cargando cabecera...\n";
			while (<HEADER>) {
				$_=~s/-TITLE-/$title/;
				$_=~s/(style\.css)/\.\.\/$1/;
				$_=~s/(practica-.*)/\.\.\/$1/;
				$_=~s/"(index.html)"/"\.\.\/$1"/;
				$_=~s/(img\/)/\.\.\/$1/;
				print FILE $_;
			}
			close HEADER;
			
			if (-f "$dir/$MENU_FILE") {
				open MENU, "$dir/$MENU_FILE" or die "No puedo abrir $dir/$MENU_FILE: $!\n";
				print "Cargando menu...\n";
				while (<MENU>) {
					print FILE $_;
				}
				close MENU;
			}

            open MEDIUM, "$TEMPLATE_MEDIUM" or die "No puedo abrir $TEMPLATE_MEDIUM: $!\n";
            print "Cargando el resto del menú...\n";
            while (<MEDIUM>) {
				$_=~s/img\//\.\.\/img\//;
                print FILE $_;
            }
            close MEDIUM;

            open MAIN, "$dir/$MAIN_FILE" or die "No puedo abrir $dir/$MAIN_FILE: $!\n";
            print "Cargando el contenido principal de la página...\n";
            while (<MAIN>) {
                print FILE $_;
            }
            close MAIN;

            open FOOTER, "$TEMPLATE_FOOTER" or die "No puedo abrir $TEMPLATE_FOOTER: $!\n";
            print "Cargando pie...\n";
            while (<FOOTER>) {
				$_=~s/img\//\.\.\/img\//;
                print FILE $_;
            }
            close FOOTER;
                                                                                                                             

			
		}
	}
	closedir(SECTIONS);
}

sub create_index() {
	my $title;
	print "-> Sección: fichero principal\n";
    print "-------------------------\n";
    $title=`cat $TITLE_FILE`;
    open FILE, ">>$OUTPUT/index.html" or die "No puedo abrir $OUTPUT/index.html\n";
                                                                                                                            
    open HEADER, "$TEMPLATE_HEADER" or die "No puedo abrir $TEMPLATE_HEADER: $!\n";
    print "Cargando cabecera...\n";
    while (<HEADER>) {
		$_=~s/-TITLE-/$title/;
        print FILE $_;
    }
    close HEADER;
                                                                                                                             
    open MEDIUM, "$TEMPLATE_MEDIUM" or die "No puedo abrir $TEMPLATE_MEDIUM: $!\n";
    print "Cargando el resto del menú...\n";
    while (<MEDIUM>) {
        print FILE $_;
    }
    close MEDIUM;
                                                                                                                             
    open MAIN, "$MAIN_FILE" or die "No puedo abrir $MAIN_FILE: $!\n";
    print "Cargando el contenido principal de la página...\n";
    while (<MAIN>) {
        print FILE $_;
    }
    close MAIN;
                                                                                                                             
    open FOOTER, "$TEMPLATE_FOOTER" or die "No puedo abrir $TEMPLATE_FOOTER: $!\n";
    print "Cargando pie...\n";
    while (<FOOTER>) {
        print FILE $_;
    }
    close FOOTER;

}


sub clean() {
	`rm -rf $OUTPUT`;
	print "Borrando directorio $OUTPUT\n";
}

sub test() {
	die "No existe el directorio de plantillas ($TEMPLATES_DIR)" if (! -d $TEMPLATES_DIR);
}

sub mk_dir() {
	my ($dir)=@_;
	if (! -e "$dir") {
		mkdir("$dir") or die "No puedo crear el directorio $dir: $!\n";
		print "Creando directorio $dir...\n";
	}
}

sub include() {
	&mk_dir("$OUTPUT/img");
	`cp -R img/* $OUTPUT/img`;
	`cp style.css $OUTPUT`;
	print "Copiando imágenes y CSS...\n";
}
