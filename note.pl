#!/usr/bin/perl -w
use Curses::UI;
    my $cui = new Curses::UI;
    my $win = $cui->add(undef, 'Window');

    my $notebook = $win->add(undef, 'Notebook');
    my $page1 = $notebook->add_page('page 1');
    $page1->add(
        undef, 'Label',
        -x    => 15,
        -y    => 6,
        -text => "Page #1.",
    );
    my $page2 = $notebook->add_page('page 2');
    $page2->add(
        undef, 'Label',
        -x    => 15,
        -y    => 6,
        -text => "Page #2.",
    );
    my $page3 = $notebook->add_page('page 3', -on_activate => \&sub );
    $page3->add(
        undef, 'Label',
        -x    => 15,
        -y    => 6,
        -text => "Page #3.",
    );
    $notebook->focus;
    $cui->mainloop;
