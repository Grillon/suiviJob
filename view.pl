#!/usr/bin/perl -w
    use Curses::UI;
    my $cui = new Curses::UI;
    my $win = $cui->add('window_id', 'Window');

    # The hard way.
    # -------------
    #my $dialog = $win->add(
    #'mydialog', 'Dialog::Basic',
    #-message   => 'Hello, world!'
    #);
    #$dialog->focus;
    #$win->delete('mydialog');

    # The easy way (see Curses::UI documentation).
    # --------------------------------------------
    my $buttonvalue = $cui->dialog(-message => 'Hello, world!');

    # or even
    $cui->dialog('Hello, world!');
