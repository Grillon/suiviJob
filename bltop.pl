sub new {
my $class = shift;
my $args = {
_listeJobs => \%jobs,
};
bless $args,$class;
}

sub jobs {
  #permet l'acces a %jobs
  my $self = shift;
  $self->{_listeJobs} = shift if defined @_;
  $self->{_listeJobs};

}

sub stats_job {
  #affiche toutes les infos concernant un job donnee

}

sub stats_jobs {
  #affiche les infos de tous les jobs

}

sub liste_jobs {
  #defini la liste des jobs existants

  my $self = shift;
  my $env_jobs = $self->env_jobs;
  my $env = `pwd`;
  chomp $env;
  chdir $env_jobs;
  my @lst_jobs = glob qq("[0-9]*");
  my %jobs = $self->jobs;
@jobs{@lst_jobs} = @lst_jobs;
  $self->jobs(\%jobs);
}
