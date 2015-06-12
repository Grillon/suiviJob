#!/usr/bin/env perl
use strict;
use File::Glob;
use InstanceJob;
use InstancesJob;
use Tableau_de_bord;
use Curses::UI;
use CmdLocal;
use CmdSsh;
#use Net::OpenSSH;
#my $host = ;
#my $user = ;
#my $pass = ;
#my $ssh = Net::OpenSSH->new($host,(user => $user,password => $pass));
my $host = 'localhost';
my $user = ;
my $passwd = ;
my $mon_env = "$HOME/mesProjets/Projet_BlTop/PIDFILES";
my $ssh = CmdLocal->new;
#my $ssh = CmdSsh->new($host,$user,$passwd);
#use Net::SSH::Perl;
#my $host = ;
#my $ssh = Net::SSH::Perl->new($host);
##print "user : ";
#my $user = ;
##print "\npasswd : ";
#my $pass = ;
#$ssh->login($user, $pass);
#my($stdout, $stderr, $exit) = $ssh->cmd($cmd);
my %ensemble;
my %mes_onglets;
my $onglets;
my $tbl = Tableau_de_bord->new($ssh,$mon_env);
my $cui = new Curses::UI( -color_support => 1 );
my @menu = (
  { -label => 'File', 
    -submenu => [
      { -label => 'Exit      ^Q', -value => \&exit_dialog  }
    ]
  },
);
sub exit_dialog()
{
  my $return = $cui->dialog(
    -message   => "Do you really want to quit?",
    -title     => "Are you sure???", 
    -buttons   => ['yes', 'no'],

  );

  exit(0) if $return;
}

my $menu = $cui->add(
  'menu','Menubar', 
  -menu => \@menu,
  -fg  => "blue",
);


my $win = $cui->add(
  'win1', 'Window',
  -border => 1,
  -y    => 1,
  -bfg  => 'red',
);

#my $onglets = $win->add(undef,'Notebook');
#my $page1 = $onglets->add_page('page 1');
#$page1->add(
#undef, 'Label',
#-x    => 15,
#-y    => 6,
#-text => "Page #1.",
#);


#\&aug2;
#$win->focus();
$cui->set_binding(sub {$menu->focus()}, "\cX");
$cui->set_binding( \&exit_dialog , "\cQ");
#
$cui->set_timer($win,
\&aug2,5);
#my $x = 0;

$win->focus();
$cui->mainloop();

sub aug2 {

my %cr = %{$tbl->vues_jobs};
#my %cr = (
#job1 => 1,
#job2 => 2,
#);
#my $info;
foreach my $job (keys %cr) {
  creation_onglet($job);
  foreach my $dJob (keys %{$cr{$job}{vue_pids}}) {
    my $info = $cr{$job}{vue_pids}->{$dJob};
      creation_ligne_job($dJob,$job,$info);
#    creation_ligne_pid($dJob);
  }

}
#$ch_fork->text("$info");
}

sub creation_onglet {
  my $job = shift;
  unless ($mes_onglets{$job}) {
    $onglets = $win->add(undef,'Notebook') unless defined $onglets;
    $mes_onglets{$job} = $onglets->add_page("$job");
    #$mes_onglets{$job}->add(
    #undef, 'Label',
    #-x    => 3,
    #-y    => 6,
    #-width => 6,
    #-text => "pid",
    #);
  }
    $onglets->focus();
}
sub vue_pids {
  my ($self,$nom_job) = @_;
  my $ssh = $self->{_ssh};
  my $mon_env = $self->env_job;
unless ($self->{$nom_job}) {
  $self->{$nom_job} = InstancesJob->new($nom_job,$ssh,$mon_env);
}
my $job = $self->{$nom_job};
  my %recap;
  $recap{vue_pids} = $job->vue_d_ensemble_pids;
  $recap{nom_job} = $nom_job;
return \%recap;
}

sub creation_ligne_job {
  my $titre = shift;
  my $job = shift;
  my $info = shift @_ if @_;
  my $page = $mes_onglets{$job};
  my $y = 5;
  if (! $ensemble{$job}{titre}) {

    my $t_pid = $page->add(
      undef, 'Label',
      -x    => 3,
      -y    => $y,
      -width => 6,
      -text => "pid",
    );

    my $t_debut = $page->add(
      undef, 'Label',
      -x    => 10,
      -y    => $y,
      -width => 24,
      -text => "debut_lisible",
    );

    my $t_fork = $page->add(
      undef, 'Label',
      -x    => 35,
      -y    => $y,
      -width => 12,
      -text => 'fork_restant',
    );
    my $t_etat = $page->add(
      undef, 'Label',
      -x    => 49,
      -y    => $y,
      -width => 20,
      -text => 'etat',
    );
    
    my $t_duree = $page->add(
      undef, 'Label',
      -x    => 71,
      -y    => $y,
      -width => 5,
      -text => 'duree',
    );


    my $t_exec = $page->add(
      undef, 'Label',
      -x    => 78,
      -y    => $y,
      -width => 14,
      -text => 'nbr_executions',
    );

    %{$ensemble{$job}{titre}} = (
      pid => $t_pid,
      debut => $t_debut,
      fork => $t_fork,
      etat => $t_etat,
      duree => $t_duree,
      exec => $t_exec,
    );
  }
$y = keys %{$ensemble{$job}};
$y += 4;

  if ($ensemble{$job}{$titre}) {
    #foreach my $elem (@{$ensemble{$titre}}) {
    my %info_inst = %{$ensemble{$job}{$titre}};
    $info_inst{pid}->text("$info->{pid}");
    $info_inst{debut}->text("$info->{debut}");
    $info_inst{fork}->text("$info->{nbr_fork}");
    $info_inst{etat}->text("$info->{etat}");
    $info_inst{duree}->text("$info->{duree}");
    $info_inst{exec}->text("$info->{nbr_executions}");
    #  }

  }
  else {
    $y++;
    my $t_pid = $page->add(
      undef, 'Label',
      -x    => 3,
      -y => $y,
      -width => 6,
      -text => "pid",
    );

    my $t_debut = $page->add(
      undef, 'Label',
      -x    => 10,
      -y => $y,
      -width => 24,
      -text => "debut_lisible",
    );

    my $t_fork = $page->add(
      undef, 'Label',
      -x    => 35,
      -y => $y,
      -width => 12,
      -text => 'fork_restant',
    );
    my $t_etat = $page->add(
      undef, 'Label',
      -x    => 49,
      -y => $y,
      -width => 20,
      -text => 'etat',
    );
    
    my $t_duree = $page->add(
      undef, 'Label',
      -x    => 71,
      -y => $y,
      -width => 5,
      -text => 'duree',
    );


    my $t_exec = $page->add(
      undef, 'Label',
      -x    => 78,
      -y => $y,
      -width => 14,
      -text => 'nbr_executions',
    );
    %{$ensemble{$job}{$titre}} = (
      pid => $t_pid,
      debut => $t_debut,
      fork => $t_fork,
      etat => $t_etat,
      duree => $t_duree,
      exec => $t_exec,
    );
    #@{$ensemble{$titre}} = ($t_pid,$t_debut,$t_fork,$t_etat,$t_duree,$t_exec);
  }
    $win->draw();
}

while (1) {
my $tbl = Tableau_de_bord->new;
$tbl->stats_jobs;
sleep 1;
#system(clear);
}
#print $job->date_debut;
#print $job->etat;
#print $job->date_fin;
#print "\n";
#my $groupe = InstancesJob->new(C);
#print $groupe->pids_en_cours;
#print $groupe->serveurs_en_cours;
#print $groupe->serveurs_en_cours;
#print $groupe->etat_serveur("nom");
#print $groupe->etat_serveur("nom2");
#print "\n";
#my $tbl = Tableau_de_bord->new;
#$tbl->liste_jobs;
