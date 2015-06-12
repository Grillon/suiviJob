package InstanceJob;

my $date_debut = sub {
 
};

sub new {
my ($class,$mon_job,$mon_pid,$ssh,$env) = @_;

$env = "$HOME/$PROJETS/PIDFILES/$mon_job" unless defined $env;
my $args = {
  _ssh => $ssh,
_nom_job => $mon_job,
_mon_pid => $mon_pid,
_env_job => "$env",
_env_pid => "$env/$mon_pid",
_fc_executions => "$env/$mon_pid/execution",
_fc_fork => "$env/$mon_pid/compteur_fork",
_nbr_fork => nbr_fork,
_nbr_taches_restantes => nbr_taches_restantes,
_etat => etat,
_date_debut => $date_debut->($mon_pid),
_date_fin => date_fin,
_duree => duree

};

bless $args,$class;
}

BEGIN {
  no strict 'refs';
  for my $accessor (qw( nom_job mon_pid env_job env_pid fc_executions fc_fork nbr_fork nbr_taches_restantes etat date_debut date_fin duree )) {
    *{ $accessor } = sub {
      my $self = shift;
      return $self->{"_".$accessor};
    };
  }
}
#sub vue_d_ensemble {
#my $self = shift;
#my $etat = $self->etat;
#my $pid = $self->{_monPid};
#my $job = $self->{_nomJob};
#my $debut = $self->date_debut;
#my $debut_lisible = localtime($debut);
#my $fin = $self->date_fin;
#my $nbr_fork = $self->nbr_fork;
#my $nbr_executions = $self->nbr_taches_restantes;
#my $duree = $self->duree($debut,$fin);
#printf '%6s|%24s|%12s|%20s|%5s|%10s',$pid,$debut_lisible,$nbr_fork,$etat,$duree,$nbr_executions;
#print "\n";
#}

sub vue_d_ensemble {
  my $self = shift;
  my $etat = $self->etat;
  my $pid = $self->{_mon_pid};
  my $job = $self->{_nom_job};
  my $debut = $self->date_debut;
  my $debut_lisible = localtime($debut);
  my $fin = $self->date_fin;
  my $nbr_fork = $self->nbr_fork;
  my $nbr_executions = $self->nbr_taches_restantes;
  my $duree = $self->duree($debut,$fin);
  my $ve = {
pid => $pid,
debut => $debut_lisible,
nbr_fork => $nbr_fork,
etat => $etat,
duree => $duree,
nbr_executions => $nbr_executions,
  };
}


sub nbr_fork {
my ($self) = @_;
my $ssh = $self->{_ssh};
my $fichier_fork=$self->fc_fork();

#my $reussite = $ssh->exec("test -e $fichier_fork");
my $reussite = $self->existe( $fichier_fork);
if ($reussite) {
my $cmd = "cat $fichier_fork";
my ($sortie,$err,$status) = $ssh->execR($cmd);
#my ($sortie,$err,$status) = $ssh->($cmd);
chomp $sortie;
return $sortie;
}
return undef;
}

sub existe {
  my ($self,$fichier) = @_;
  my $ssh = $self->{_ssh};
  my $reussite = $ssh->exec("test -e $fichier");
  if ($reussite) {
    return 1;
  }
  else {
    return 0;
  }

}

sub nbr_taches_restantes {
my ($self) = @_;
my $ssh = $self->{_ssh};
my $fichier_executions=$self->fc_executions;
my $nbr_executions;
my $reussite = $self->existe($fichier_executions);
if ($reussite) {
my $cmd = "cat $fichier_executions";
my ($nbr_executions, $stderr, $exit) = $ssh->execR($cmd);
chomp $nbr_executions;
return $nbr_executions;
}
return undef;

}

sub etat {
my ($self) = @_;
my $ssh = $self->{_ssh};
my $env_job=$self->env_job;
my $fichier_executions=$self->fc_executions;
my $fichier_fork=$self->fc_fork;

my $reussite = $self->existe( $env_job);
unless ($reussite) {
	return "err : env inexistant";
}
$reussite = $self->existe( $fichier_fork);
unless ($reussite) {
	return "err : incoherence dans l'env , fichier $fichier_fork inexistant";
}
$reussite = $self->existe( $fichier_executions);
if ($reussite) {
	return "en cours d'execution";
}
else {
	my $nbr_fork=$self->nbr_fork;
	if ($nbr_fork != 30) {
		return "err : incoherence dans l'env , nbr_fork = $nbr_fork au lieu de 30";
	}
	else {
		return "termine";
	}

}

}

sub date_debut {
my ($self) = @_;
my $env_pid = $self->env_pid;
my $date_debut = (stat($env_pid))[8];
#$date_debut = localtime($date_debut);
}

sub date_fin {
my ($self) = @_;
my $env_job=$self->env_job;
my $fichier_executions=$self->fc_executions;
my $fichier_fork=$self->fc_fork;
my $date_fin;

my $etat = $self->etat();

if ( $etat =~ /termine/ ) {
$date_fin = (stat($fichier_fork))[9];
return $date_fin;
}
elsif ( $etat =~ /err/ ) {
return "inconnu";
}
else {
$date_fin = (stat($fichier_fork))[9];
#$date_fin = localtime($date_fin);
return $date_fin;
}
}

sub duree {
  my ($self,$debut,$fin) = @_;
  $debut = $self->date_debut unless $debut;
  $fin = $self->date_fin unless $fin;
  my $duree = $fin - $debut;
  if ($duree > 3600 ) {
    $duree = int ($duree / 60 / 60);
    $duree = "$duree H";
  }
  elsif ($duree > 60) {
    $duree = int($duree / 60);
    $duree = "$duree mn";
  }
  elsif ($duree < 60 ) {
    $duree = int ($duree);
    $duree = "$duree s";
  }
  else {
    $duree = "inconnu";

  }

}



1;
