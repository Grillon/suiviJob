package CmdSshExpect;
use Net::SSH::Expect;

sub new {
  my ($class,$host,$user,$passwd) = @_;

$host = "localhost"  unless defined $host;
$user = "thierry" unless defined $user;
$passwd = ' ' unless defined $passwd;
my $ssh = Net::SSH::Expect->new (
      host => $host,
          password=> $passwd,
	      user => $user,
		);
my $login_output = $ssh->login();
#if ($login_output !~ /WARNING/) {
#die "Login has failed. Login output was $login_output";
#}
#$ssh->run_ssh() or die "SSH process couldn't start: $!";
#($ssh->read_all(2) =~ />\s*\z/) or die "where's the remote prompt?";
    $ssh->collect_exit_code(1);
my $args = {
_ssh => $ssh,
};

bless $args,$class;
}

sub exec {
  my ($self,$cmd) = @_;
  my $ssh = $self->{_ssh};
  $ssh->system($cmd);
  if ($ssh->last_exit_code() == 0) {
    return 1;
  } else {
    return 0;
  }
}

sub execR {
  my ($self,$cmd) = @_;
  my $ssh = $self->{_ssh};
  $ssh->exec($cmd);
}

sub close {
  my $ssh = $self->{_ssh};
  $ssh->close();
}
1;
