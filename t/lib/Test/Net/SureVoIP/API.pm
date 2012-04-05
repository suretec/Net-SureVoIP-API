package Test::Net::SureVoIP::API;
use parent 'Test::BASE';
use strict;
use warnings;

use Net::SureVoIP::API;

use Test::Most;

sub fixtures :Tests(startup => 2) {
  my $test = shift;

  throws_ok { Net::SureVoIP::API->new(); } 'Net::SureVoIP::API::Exception::Init' , 'need creds';

  ### TODO set this up so that it will mock up a client unless environment
  ### variables for user/pass are properly set.

  $test->{api} = Net::SureVoIP::API->new({
    basic_auth => {
      username => $ENV{SUREVOIP_USER} ,
      password => $ENV{SUREVOIP_PASS} ,
    },
  });
  isa_ok $test->{api} , 'Net::SureVoIP::API';
}

1;
