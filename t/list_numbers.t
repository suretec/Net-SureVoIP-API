#! perl
use lib 't/lib';

use namespace::autoclean;

use Test::More;
use Test::Routine;
use Test::Routine::Util;

with 'Fixture::Client';

test 'list_numbers endpoint' => sub {
  my $self = shift;

 TODO: {
    my $resp = $self->client->list_numbers({
      # account => 'FIXME need to pass account number',
    });

    isa_ok(
      $resp , 'Net::SureVoIP::API::Response' , 'expected response'
    );
  }
};

run_me;
done_testing;
