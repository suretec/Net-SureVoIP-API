#! perl

use Test::More;
use Test::Routine;
use Test::Routine::Util;
use namespace::autoclean;

with 'Fixture::Client';

test 'customer endpoint' => sub {
  my $self = shift;

 TODO: {
    local $TODO = 'Need to pass key to customer method. Also need to make lack of required option fatal.';

    my $customer = $self->client->customer({ key => 'foo' });

    isa_ok( $customer , 'Net::SureVoIP::API::Response::Customer' );
    is( $customer->status , 200 , 'success' );
  }
};

run_me;
done_testing;
