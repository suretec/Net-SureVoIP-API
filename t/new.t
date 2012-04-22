#! perl

use Test::Most             qw/ !blessed /;
use Test::Routine;
use Test::Routine::Util;
use namespace::autoclean;

use Net::SureVoIP::API;

test "new without args fails" => sub {
  throws_ok { Net::SureVoIP::API->new(); }
    'Net::SureVoIP::API::Exception::Init' , 'need creds';
};

run_me;
done_testing;
