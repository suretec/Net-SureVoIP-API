package Net::SureVoIP::API;
# ABSTRACT: Perl library for SureVoIP REST API
use Moose;

use JSON;
use MIME::Base64;
use Net::SureVoIP::API::Exception::Http;
use Net::SureVoIP::API::Exception::Init;
use Net::SureVoIP::API::Response::Customer;

=attr base_url

### FIXME POD

=cut

has base_url => (
  is         => 'ro' ,
  isa        => 'Str' ,
  lazy_build => 1 ,
);

sub _build_base_url {
  my $self = shift;

  my $base_base = 'https://api.surevoip.co.uk';

  return $self->partner_name ? "$base_base/partners/" . $self->partner_name : $base_base;
}

=attr debug

### FIXME POD

=cut

has debug => (
  is      => 'ro' ,
  isa     => 'Bool' ,
  default => 0 ,
);

=attr default_headers

### FIXME POD

=cut

has default_headers => (
  is  => 'ro',
  isa => 'HashRef' ,
);

=attr default_response_handler

### FIXME POD

=cut

has default_response_handler => (
  is      => 'ro' ,
  isa     => 'Str' ,
  default => 'Net::SureVoIP::API::Response' ,
);

=attr partner_name

### FIXME POD

=cut

has partner_name => (
  is        => 'ro' ,
  isa       => 'Str' ,
  predicate => 'has_partner_name' ,
);

with 'Role::REST::Client' => {
  ### FIXME need to fill in the rest of this
  commands => {
    # FIXME RT#54644
    create_customer => {
      path   => 'customers',
      method => 'POST' ,
    },

    # FIXME need to finish tests -- dependent on mocks
    customer => {
      path     => 'customers/%{account}s' ,
      response => 'Net::SureVoIP::API::Response::Customer' ,
    },

    # FIXME waiting on production deployment - test should start passing then
    echo => {
      path   => 'support/echo',
      method => 'POST' ,
    },

    # FIXME need to finalize response object
    ip_address => {
      path => 'support/ip-address' ,
    },

    # FIXME RT#54647
    list_calls => {
      path   => 'customers/%{account}s/calls' ,
      method => 'GET',
    },

    # FIXME RT#54646
    list_invoices => {
      path => 'customers/%{account}s/billing/invoices' ,
    },

    # FIXME RT#54645
    list_numbers => {
      path => 'customers/%{account}s/numbers' ,
    } ,

    service_status => {
      path     => 'support/service-status' ,
      response => 'Net::SureVoIP::API::Response::ServiceStatus' ,
    },

    # FIXME finish test, response
    show_billing_contact => {
      path => 'customers/%{key}s/billing/contact' ,
    } ,

    # FIXME everything below has not been implemented yet
    # area_codes => {} ,
    # create_call => {} ,
    # end_call => {} ,
    # get_customer_stats => {} ,
    # get_fax => {
    #   alias => 'fax_details' ,
    # },
    # get_invoice => {
    #   path  => 'customers/%{key}s/billing/invoices/%{id}s' ,
    #   alias => 'invoice_details'
    # },
    # get_number => {
    #   alias => 'number_details' ,
    # },
    # get_sms => {
    #   alias => 'sms_details' ,
    # },
    # list_customer_stats => {} ,
    # list_faxes => {} ,
    # list_sms => {} ,
    # modify_call => {} ,
    # numbers => {} ,
    # send_fax => {} ,
    # send_sms => {} ,
    # sip => {} ,
    # update_billing_contact => {
    #   path => 'customers/%{key}s/billing/contact' ,
    # } ,
    # update_number => {} ,
  },
};

sub BUILDARGS {
  my $class = shift;

  my %args = ref $_[0] ? %{ $_[0] } : @_;

  ### FIXME
  if ( $args{basic_auth} ) {
    my $user = $args{basic_auth}{username} //
      Net::SureVoIP::API::Exception::Init->throw( 'basic_auth needs username' );

    my $pass = $args{basic_auth}{password} //
      Net::SureVoIP::API::Exception::Init->throw( 'basic_auth needs password' );

    my $auth = encode_base64("$user:$pass");
    chomp $auth;

    $args{default_headers}{Authorization} = "Basic $auth";
  }
  ### TODO OAuth....
  # elsif ( $args{oauth} ) { ... }
  else {
    Net::SureVoIP::API::Exception::Init->throw( 'Must supply authentication credentials.' );
  }

  $args{default_headers}{'Content-Type'} = 'application/json';

  return \%args;
}

1;
