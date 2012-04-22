#! perl
use lib 't/lib';

use namespace::autoclean;

use Test::More;
use Test::Routine;
use Test::Routine::Util;

with 'Fixture::Client';

test 'create_customer endpoint' => sub {
  my $self = shift;

 TODO: {
    local $TODO = 'Need to pass key to customer method.';
    # FIXME need to figure out a way to test this without actually generating
    # a bunch of customers remotely.

    my $customer = $self->client->create_customer({
      account => 'foo' ,
      # content => 'FIXME need content arg'
    });

    isa_ok( $customer , 'Net::SureVoIP::API::Response::Customer' );
    is( $customer->status , 200 , 'success' );
  }
};

run_me;
done_testing;
