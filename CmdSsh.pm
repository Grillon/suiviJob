package CmdSsh;
use Net::OpenSSH;

sub new {
  my ($class,$host,$user,$passwd) = @_;

$host = "localhost"  unless defined $host;
$user = "thierry" unless defined $user;
$pass = ' ' unless defined $passwd;
my $ssh = Net::OpenSSH->new($host,(user => $user,password => $pass));

my $args = {
_ssh => $ssh,
};

bless $args,$class;
}

sub exec {
  my ($self,$cmd) = @_;
  my $ssh = $self->{_ssh};
  $ssh->system($cmd);

}

sub execR {
  my ($self,$cmd) = @_;
  my $ssh = $self->{_ssh};
  $ssh->capture($cmd);
}

sub close {
  return 0;
}
1;
