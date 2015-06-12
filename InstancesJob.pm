package InstancesJob;

sub new {
my ($class,$nom_job,$ssh,$env) = @_;
$env = "$HOME/$PROJETS/PIDFILES" unless defined $env;
my $args = {
  _envJob => "$env/$nom_job",
  _listePids => \@pids,
  _nomJob => $nom_job,
  _listeServeurs => \@serveurs,
  _ssh => $ssh,
};
bless $args,$class;
}

sub env_job {
  my $self = shift;
  $self->{_envJob};
}



sub vue_d_ensemble_pids {
  #cumul des compteur executions
  my ($self) = @_;
  my $ssh = $self->{_ssh};
  my $nom_job = $self->{_nomJob};
  my $mon_env = $self->env_job;
  my @pids = $self->pids_en_cours;
  if (@pids == 0) {
    return "aucun serveurs en cours de traitement";

  }
  my %recap;
  foreach my $num_pid (@pids) {
    my $pid = InstanceJob->new($nom_job,$num_pid,$ssh,$mon_env);
    $recap{$num_pid} = $pid->vue_d_ensemble;
}
return \%recap;
}

sub pids_en_cours {
  #liste des rep pid
  my $self = shift;
  my $ssh = $self->{_ssh};
  my $env_job = $self->env_job;
  my $cmd = "pwd";
  my ($env, $stderr, $exit) = $ssh->execR($cmd);
  chomp $env;
  my $go_env = "cd $env_job";
  #$ssh->cmd($cmd);
  #chdir $env_job;
#  my @pids = glob qq("[0-9]*");
  $cmd = $go_env.';echo [0-9]*';
  my $retpids;
  ($retpids, $stderr, $exit) = $ssh->execR($cmd);
  map { chomp } $retpids;
my @pids = split(/\s+/,$retpids);

  #@pids = split(/\s+/,@pids);
  $cmd = "cd $env";
  #chdir $env;
  return @pids;

}

sub serveurs_en_cours {
#liste des serveurs dans la racine
	my $self = shift;
  my $ssh = $self->{_ssh};
	my $env_job = $self->env_job;
	my $env = "pwd";
	chomp $env;
	my $go_env = "cd $env_job";
	#chdir $env_job;
#my @serveurs = glob qq("[A-Za-z]*");
	my $cmd = $go_env.';echo [A-Za-z]*';
	my (@serveurs, $stderr, $exit) = $ssh->execR($cmd);
	map { chomp } @serveurs;
	map { s/\[A\-Za\-z]\*/AUCUN/ } @serveurs;
	#chdir $env;
	return @serveurs;
  

}

sub etat_serveur {
  #verif si serveur donne est en cours
  my ($self,$nom_serveur) = @_;
  my @serveurs = $self->serveurs_en_cours;
  my $serveur = grep { /$nom_serveur/ } @serveurs ;
  if ($serveur) {
return "en cours de traitement";
  }
  else {
return "pas en cours de traitement";
  }
}
1;
