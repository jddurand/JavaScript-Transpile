use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::Exception;
use namespace::sweep;
use Moose;
with 'Throwable';
with 'MooseX::Role::Logger';

has type    => (is => 'ro', default => 'GenericError');
has message => (is => 'ro', default => '');

sub BUILD {
  my $self = shift;

  warn $self->message . "\n";
  $self->logger->error(join(', ', $self->type, $self->message));
}

1;
