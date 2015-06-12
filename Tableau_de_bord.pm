package Tableau_de_bord;

sub new {
my ($class,$ssh,$env) = @_;
$env = "$HOME/$PROJETS/PIDFILES" unless $env;
my $args = {
  _envJobs => $env,
  _listeJobs => \%jobs,
  _ssh => $ssh,
};
bless $args,$class;
}

sub env_jobs {
  my $self = shift;
  $self->{_envJobs};
}

sub jobs {
  #permet l'acces a %jobs
  my $self = shift;
  $self->{_listeJobs} = shift if @_;
  $self->{_listeJobs};

}

sub stats_job {
  #affiche toutes les infos concernant un job donnee
  my ($self,$nom_job) = @_;
  my $job = InstancesJob->new($nom_job);
  $job->vue_d_ensemble_pids;
  print "-------------------------------\n";
  print "serveur(s) traite(s) par le job $nom_job\n";
  print "-------------------------------\n";
  print join (" ",$job->serveurs_en_cours);
  print "\n";
  #my $serveur_en_cours = $job->serveur_en_cours;

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
  #$recap{serveurs} = join (" ",$job->serveurs_en_cours);
#  $self->{$nom_job} = \%recap;
#}
#  return $self->{$nom_job};
return \%recap;
}

sub env_job {
  my $self = shift;
  $self->{_envJobs};

}


sub stats_jobs {
  #affiche les infos de tous les jobs
  my $self = shift;
  my $ssh = $self->{_ssh};
  $self->liste_jobs;
  my %jobs = %{$self->jobs};
foreach $job (keys %jobs) {
  print "-------------- $job --------------\n";
  printf '%6s|%24s|%8s|%20s|%5s|%10s',pid,debut_lisible,fork_restant,etat,duree,nbr_executions;
  print "\n";
  $self->stats_job($job);

}
}

sub vues_jobs {
  #affiche les infos de tous les jobs
  my $self = shift;
  $self->liste_jobs;
my $ssh = $self->{_ssh};
#my $cmd = "cd /data/flf/sgadep/PROJETS/Librairie/G1R1C0;ls";
#my ($sortie,$err,$status) = $ssh->cmd($cmd);
#print $sortie;
  my %jobs = %{$self->jobs};
  my %recaps;
foreach $job (keys %jobs) {
  $recaps{$job} = $self->vue_pids($job);
}
return \%recaps;
}
sub liste_jobs {
  #defini la liste des jobs existants

  my $self = shift;
  my $env_jobs = $self->env_jobs;
my $ssh = $self->{_ssh};
#my $cmd = "cd /data/flf/sgadep/PROJETS/Librairie/G1R1C0;ls";
#my ($sortie,$err,$status) = $ssh->cmd($cmd);
#print $sortie;
  my $cmd = "pwd";
  chomp $env;
  my $go_env = "cd $env_jobs";
  #$ssh->($cmd);
  #chdir $env_jobs;
  #my @lst_jobs = glob qq("[A-Za-z]*");
  $cmd = $go_env.';echo [A-Za-z]*';
my ($sortie,$err,$status) = $ssh->execR($cmd);
#  (my $retjobs,$err,$status) = $ssh->($cmd);
  map { chomp } $sortie;
my @lst_jobs = split(/\s+/,$sortie);
map { chomp } @lst_jobs;
  my %jobs = %{$self->jobs };
@jobs{@lst_jobs} = @lst_jobs;
  $self->jobs(\%jobs);
}
1;
