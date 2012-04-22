#! perl

use Test::More;
use Test::Routine;
use Test::Routine::Util;
use namespace::autoclean;

with 'Fixture::Client';

test 'list_invoices endpoint' => sub {
  my $self = shift;

 TODO: {
    local $TODO = 'Finish list_invoices tests';
    ok(1);
  }
};

run_me;
done_testing;
