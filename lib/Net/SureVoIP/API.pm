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

# load this down here because some required methods are satisfied by
# attribute accessors and we have to generate them first...
with 'Role::REST::Client' => {
  commands => {
    ### FIXME need to fill in the rest of this
    #   create_customer => {
    #     method => 'POST' ,
    #   },
    echo => {
      path   => 'support/echo',
      method => 'POST' ,
    },
    #    list_calls => {},
    list_invoices => {
      path => 'customers/%{key}s/billing/invoices' ,
    },
    #    get_invoice => {
    #      path  => 'customers/%{key}s/billing/invoices/%{id}s' ,
    #      alias => 'invoice_details'
    #    },
    #    show_billing_contact => {
    #      path => 'customers/%{key}s/billing/contact' ,
    #    } ,
    #    update_billing_contact => {
    #      path => 'customers/%{key}s/billing/contact' ,
    #    } ,
    #    list_numbers => {} ,
    #    get_number => {
    #      alias => 'number_details' ,
    #    },
    #    update_number => {} ,
    #    list_faxes => {} ,
    #    get_fax => {
    #      alias => 'fax_details' ,
    #    },
    #    list_sms => {} ,
    #    get_sms => {
    #      alias => 'sms_details' ,
    #    },
    customer => {
      path     => 'customers/%{key}s' ,
      response => 'Net::SureVoIP::API::Response::Customer' ,
    },
    ip_address => {
      path => 'support/ip-address' ,
    },
    service_status => {
      path => 'support/service-status' ,
    },
    #    sip => {} ,
    #    numbers => {} ,
    #    area_codes => {} ,
    #    create_call => {} ,
    #    end_call => {} ,
    #    modify_call => {} ,
    #    list_customer_stats => {} ,
    #    get_customer_stats => {} ,
    #    send_sms => {} ,
    #    send_fax => {} ,
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

    $args{default_headers}{Authorization} = 'Basic ' . encode_base64("$user:$pass");
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
