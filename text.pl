#!/usr/bin/perl -w
use Curses::UI;
my $cui = new Curses::UI;
my $win = $cui->add('window_id', 'Window');

my $textentry = $win->add(
  'mytextentry', 'TextEntry'
);

my $text = $textentry->get();
print $text;
$textentry->focus();
$cui->status("Saying hello to the world...");
$cui->dialog('Hello, world!');
$cui->status("Saying hello to the world...");
my $textviewer = $win->add( 
          'mytextviewer', 'TextViewer',
	      -text => "Hello, world!\n"
	                     . "Goodbye, world!"
			         );

				     $textviewer->focus();
				     $cui->mainloop();
