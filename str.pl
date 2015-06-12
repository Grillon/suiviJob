#!/usr/bin/perl -w

use Curses::Widgets::Label;
 
$lbl = Curses::Widgets::Label->new({
      COLUMNS      => 10,
        LINES       => 1,
	  VALUE       => 'Name:',
	    FOREGROUND  => undef,
	      BACKGROUND  => 'black',
	        X           => 1,
		  Y           => 1,
		    ALIGNMENT   => 'R',
		      });
		     
		    $tf->draw($mwh);
