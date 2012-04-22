#! perl

use Test::More;
use Test::Routine;
use Test::Routine::Util;
use namespace::autoclean;

use JSON;

with 'Fixture::Client';

test 'echo endpoint' => sub {
  my $self = shift;

  my $content = to_json({ foo => 'bar' });

  my $resp = $self->client->echo( $content );

  isa_ok( $resp , 'Net::SureVoIP::API::Response' );

  is( $resp->success , 1 , 'request worked' );
};

run_me;
done_testing;
