#! perl

use Test::More;
use Test::Routine;
use Test::Routine::Util;
use namespace::autoclean;

with 'Fixture::Client';

test "billing_contact endpoint" => sub {
  my $self = shift;

 TODO: {
    local $TODO = 'Port billing_contact to role-based client';

    #my $billing_contact = $self->client->billing_contact;

    ok(1);
  }
};

run_me;
done_testing;
