#! perl

use Test::Most             qw/ !blessed /;
use Test::Routine;
use Test::Routine::Util;
use namespace::autoclean;

with 'Fixture::Client';

test "service_status endpoint" => sub {
  my $self = shift;

  my $resp = $self->client->service_status;

  isa_ok( $resp , 'Net::SureVoIP::API::Response::ServiceStatus' );

  my $entries = $resp->entries;

  foreach ( @$entries ) {
    isa_ok( $_ , 'Net::SureVoIP::API::Response::ServiceStatus::Entry' );
  }

  ok( $resp->feed_title , 'has feed title' );
  ok( $resp->headers    , 'has headers' );
};

run_me;
done_testing;
