#!/usr/bin/perl
use File::Glob;
use InstanceJob;
use InstancesJob;
use Tableau_de_bord;
#use Net::OpenSSH;
use CmdSsh;
use CmdLocal;
use CmdSshExpect;
#my $host = $host;
#my $user = $user;
#my $pass = $mdp;
#my $ssh = Net::OpenSSH->new($host,(user => $user,password => $pass));
#my @ls = $ssh->capture("ls");
my $mon_env = "$HOME/mesProjets/Projet_BlTop/PIDFILES";
my $ssh = CmdLocal->new;
#my $ssh = CmdSshExpect->new($host,$user,$pass);
my $pwd = $ssh->execR("pwd");
print "$pwd\n";
$pwd = $ssh->execR("pwd");
print "$pwd\n";
#$ssh->login($user, $pass);
my $tbl = Tableau_de_bord->new($ssh,$mon_env);
my %cr = %{$tbl->vues_jobs};
#print keys %cr;
foreach my $job (keys %cr) {
  print "-- $job\n";
  foreach my $dJob (keys %{$cr{$job}{vue_pids}}) {
    my $info = $cr{$job}{vue_pids}->{$dJob};
    print "$info->{etat}\n";

  }
}
$ssh->close;
