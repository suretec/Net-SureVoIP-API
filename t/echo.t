#! perl
use lib 't/lib';

use namespace::autoclean;

use Test::More;
use Test::Routine;
use Test::Routine::Util;

use JSON;

with 'Fixture::Client';

test 'echo endpoint' => sub {
  my $self = shift;

  my $content = { foo => 'bar' };

  my $resp = $self->client->echo({ content => $content });

  isa_ok( $resp , 'Net::SureVoIP::API::Response' );

  is( $resp->success , 1    , 'request worked' );
  is( $resp->status  , 200  , 'status=200'     );

  my $response = from_json $resp->content;
  is_deeply( $response , { echoed => $content });
};

run_me;
done_testing;
