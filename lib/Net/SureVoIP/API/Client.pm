package Net::SureVoIP::API::Client;

use Moose;
use MooseX::NonMoose;
extends 'HTTP::Tiny';

sub FOREIGNBUILDARGS {
  my $class = shift;

  my %args = ref $_[0] ? %{ $_[0] } : @_;

  $args{default_headers} = {
    'Content-Type' => 'application/json' ,
    %{ $args{default_headers} // {} } ,
  };

  return %args;
}

__PACKAGE__->meta->make_immutable;
1;
