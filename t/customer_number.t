#! perl

use Test::More;
use Test::Routine;
use Test::Routine::Util;
use namespace::autoclean;

with 'Fixture::Client';

test 'customer_number endpoint' => sub {
  my $self = shift;

 TODO: {
    local $TODO = 'Port customer_number to role-based client';

    # my $number = $self->client->customer_number;

    ok(1);
  }
};

run_me;
done_testing;
