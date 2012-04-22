#! perl
use lib 't/lib';

use namespace::autoclean;

use Test::More;
use Test::Routine;
use Test::Routine::Util;

with 'Fixture::Client';

test 'customer endpoint' => sub {
  my $self = shift;

 TODO: {
    local $TODO = 'Need to pass account number to customer method.';

    my $customer = $self->client->customer({
      # account => 'FIXME need account number' ,
    });

    isa_ok( $customer , 'Net::SureVoIP::API::Response::Customer' );
    is( $customer->status , 200 , 'success' );
  }
};

run_me;
done_testing;
