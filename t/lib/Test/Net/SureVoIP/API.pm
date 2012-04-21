package Test::Net::SureVoIP::API;
use parent 'Test::BASE';
use strict;
use warnings;

use JSON;
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

  ### TODO have distinct clients for 'customer' access and 'partner' access.
}

sub billing_contact :Tests() {
  my $test = shift;

 TODO: {
    local $TODO = 'Port billing_contact to role-based client';

    #my $billing_contact = $test->{api}->billing_contact;

    ok(1);
  }
}

sub customer :Tests() {
  my $test = shift;

 TODO: {
    local $TODO = 'Need to pass key to customer method. Also need to make lack of required option fatal.';

    my $customer = $test->{api}->customer;

    isa_ok( $customer , 'Net::SureVoIP::API::Response::Customer' );
    is( $customer->status , 200 , 'success' );
  }
}

sub customer_number :Tests() {
  my $test = shift;

 TODO: {
    local $TODO = 'Port customer_number to role-based client';

    # my $number = $test->{api}->customer_number;

    #ok( $number , 'got a response' );

    ok(1);
  }
}

sub echo :Tests() {
  my $test = shift;

  my $content = to_json({ foo => 'bar' });

  my $resp = $test->{api}->echo( $content );

  isa_ok( $resp , 'Net::SureVoIP::API::Response' );

  is( $resp->success , 1 , 'request worked' );

}

sub ip_address :Tests(1) {
  my $test = shift;

  my $resp = $test->{api}->ip_address;

  like( $resp->{content} , qr/"ip-address":"[0-9.]+"/ , 'looks like an IP');
}

sub list_invoices :Tests() {
  my $test = shift;

 TODO: {
    local $TODO = 'Finish list_invoices tests';
    ok(1);
  }
}

sub service_status :Tests() {
  my $test = shift;

  my $resp = $test->{api}->service_status;

  like( $resp->{content} , qr/"entries":/ , 'has entries' );
}

1;
