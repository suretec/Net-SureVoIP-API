#! perl
use lib 't/lib';

use namespace::autoclean;

use Test::More;
use Test::Routine;
use Test::Routine::Util;

with 'Fixture::Client';

test "billing_contact endpoint" => sub {
  my $self = shift;

 TODO: {
    local $TODO = 'Write show_billing_contact test';

    ok(1);
  }
};

run_me;
done_testing;
