#! perl
use lib 't/lib';

use namespace::autoclean;

use Test::More;
use Test::Routine;
use Test::Routine::Util;

with 'Fixture::Client';

test 'customer endpoint' => sub {
  my $self = shift;

 SKIP: {
    skip 'no SUREVOIP_ACCOUNT in env' , 2 unless $ENV{SUREVOIP_ACCOUNT};

    my $customer = $self->client->customer({
      account => $ENV{SUREVOIP_ACCOUNT}
    });

    isa_ok( $customer , 'Net::SureVoIP::API::Response::Customer' );
    is( $customer->status , 200 , 'success' );
  }
};

run_me;
done_testing;
