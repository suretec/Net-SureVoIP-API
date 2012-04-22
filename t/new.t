#! perl
use lib 't/lib';

use namespace::autoclean;

use Test::Most             qw/ !blessed /;
use Test::Routine;
use Test::Routine::Util;

use Net::SureVoIP::API;

test "new without args fails" => sub {
  throws_ok { Net::SureVoIP::API->new(); }
    'Net::SureVoIP::API::Exception::Init' , 'need creds';
};

run_me;
done_testing;
