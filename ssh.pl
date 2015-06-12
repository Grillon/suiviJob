#!/usr/bin/perl
#definir la variable host ou la demander à l'utilisateur
use Net::SSH::Perl;
my $ssh = Net::SSH::Perl->new($host);
$ssh->login($login,$mdp);
my $cmd = "pwd";
#my $cmd = '';
my($stdout, $stderr, $exit) = $ssh->cmd($cmd);
$cmd = "cd /data/flf/sgadep/PROJETS/Librairie/G1R1C0/PIDFILES";
$cmd = $cmd.';echo [A-Za-z]*';
my($stdout, $stderr, $exit) = $ssh->cmd($cmd);
print "$stdout\n";
