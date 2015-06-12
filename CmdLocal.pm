package CmdLocal;

sub new {
  my ($class) = @_;
bless {},$class;
}

sub exec {
  my ($self,$cmd) = @_;
  my $ret = system($cmd);
  return 1 if ($ret == 0);
  return undef if ($ret != 0);
}

sub execR {
  my ($self,$cmd) = @_;
  `$cmd`;
}
sub close {
  return 0;
}
1;
