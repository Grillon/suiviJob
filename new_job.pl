#!/usr/bin/perl -w
#use strict;
use File::Glob;
use InstanceJob;
use InstancesJob;
use Tableau_de_bord;
use Curses;
initscr();
cbreak();
noecho();
clear();
refresh();
endwin();

while (1) {
  clear();
  refresh();
my $tbl = Tableau_de_bord->new;
$tbl->stats_jobs;
sleep 3;
#sleep 1;
#system(clear);
}
