package Fixture::Client;

use Test::Routine;
use Test::More;

use Net::SureVoIP::API;

has client => (
  is         => 'ro' ,
  lazy_build => 1 ,
);

sub _build_client {

  ### TODO set this up so that it will mock up a client unless environment
  ### variables for user/pass are properly set.

  BAIL_OUT( "Need to set user/pass env vars!" )
    unless defined $ENV{SUREVOIP_USER} and defined $ENV{SUREVOIP_PASS};

  Net::SureVoIP::API->new({
    debug => $ENV{SUREVOIP_API_DEBUG} // 0 ,
    basic_auth => {
      username => $ENV{SUREVOIP_USER} ,
      password => $ENV{SUREVOIP_PASS} ,
    },
  });
}

test "constructor works" => sub {
  my $self = shift;

  isa_ok( $self->client , 'Net::SureVoIP::API' );
}
