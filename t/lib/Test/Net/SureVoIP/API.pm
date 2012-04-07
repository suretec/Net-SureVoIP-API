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

sub customer_number :Tests() {
  my $test = shift;

  my $number = $test->{api}->customer_number;

  ok( $number , 'got a response' );
}

sub ip_address :Tests(1) {
  my $test = shift;

  my $resp = $test->{api}->ip_address;

  like( $resp->{content} , qr/"ip-address":"[0-9.]+"/ , 'looks like an IP');
}

sub service_status :Tests() {
  my $test = shift;

  my $resp = $test->{api}->service_status;

  like( $resp->{content} , qr/"entries":/ , 'has entries' );
}

1;
