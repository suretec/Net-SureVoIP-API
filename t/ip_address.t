#! perl

use Test::More;
use Test::Routine;
use Test::Routine::Util;
use namespace::autoclean;

with 'Fixture::Client';

test "ip_address endpoint" => sub {
  my $self = shift;

  my $response = $self->client->ip_address;

  like( $response->{content} , qr/"ip-address":"[0-9.]+"/ , 'looks like an IP');
};

run_me;
done_testing;
