package Net::SureVoIP::API;
# ABSTRACT: Perl library for SureVoIP REST API
use Moose;

use JSON;
use MIME::Base64;
use Net::SureVoIP::API::Client;
use Net::SureVoIP::API::Exception::Http;
use Net::SureVoIP::API::Exception::Init;

sub BUILDARGS {
  my $class = shift;

  my %args = ref $_[0] ? %{ $_[0] } : @_;

  if ( $args{basic_auth} ) {
    my $user = $args{basic_auth}{username}
      // Net::SureVoIP::API::Exception::Init->throw( ident => 'basic_auth needs username' );

    my $pass = $args{basic_auth}{password}
      // Net::SureVoIP::API::Exception::Init->throw( ident => 'basic_auth needs password' );

    $args{default_headers}{Authorization} = 'Basic ' . encode_base64("$user:$pass");
  }
  ### TODO OAuth....
  # elsif ( $args{oauth} ) { ... }
  else {
    Net::SureVoIP::API::Exception::Init->throw(
      ident => 'Must supply authentication credentials.'
    );
  }

  return \%args;
}

=attr default_headers

=cut

has base_url => (
  is      => 'ro' ,
  isa     => 'Str' ,
  default => 'https://api.surevoip.co.uk/' ,
);

has customer_number => (
  is         => 'ro' ,
  isa        => 'Str' ,
  lazy_build => 1 ,
);

sub _build_customer_number {
  my $self = shift;

  my $url  = $self->base_url . 'customers/';
  my $resp = $self->get( $url );

  if ( $resp->{status} == '302' ) {
    my $obj = decode_json( $resp->{content} );

    my $location = $obj->{location}
      or Net::SureVoIP::API::Exception::Http->throw({
        ident => "Location not found in response content:\n" . $resp->{content}
      });

    my( $number ) = $location =~ m|^$url(.*)$|
      or Net::SureVoIP::API::Exception::Parse->throw({
        ident => "Unable to parse customer number from $location" ,
      });

    return $number;
  }
  else { Net::SureVoIP::API::Exception::Http->throw( $resp ) }
}

has default_headers => (
  is  => 'ro',
  isa => 'HashRef' ,
);

has _user_agent => (
  is         => 'ro' ,
  isa        => 'Net::SureVoIP::API::Client' ,
  init_arg   => '_inject_user_agent' ,
  lazy_build => 1 ,
  handles    => [ qw/ get head post put delete options / ],
);

sub _build__user_agent {
  return Net::SureVoIP::API::Client->new( default_headers => shift->default_headers );
}

=method create_customer

=cut

sub create_customer {}

=method list_calls

=cut

sub list_calls {}

=method list_invoices

=cut

sub list_invoices {}

=method invoice_details

=cut

sub invoice_details {}

=method billing_contact

=cut

sub billing_contact {} # optional arg == update

=method list_numbers

=cut

sub list_numbers {}

=method number_details

=cut

sub number_details {}  # optional arg == update

=method list_faxes

=cut

sub list_faxes {}

=method fax_details

=cut

sub fax_details {}

=method list_sms

=cut

sub list_sms {}

=method sms_details

=cut

sub sms_details {}

=method ip_address

=cut

sub ip_address {
  my $client = Net::SureVoIP::API::Client->new;

  my $response = $client->get('https://api.surevoip.co.uk/support/ip-address');
  if ( $response->{success} ) {
    return $response;
  }
  else {
    Net::SureVoIP::API::Exception::Http->throw( $response );
  }
}

=method service_status

=cut

sub service_status {
  my $client = Net::SureVoIP::API::Client->new;

  my $response = $client->get('https://api.surevoip.co.uk/support/service-status');
  if ( $response->{success} ) {
    return $response;
  }
  else {
    Net::SureVoIP::API::Exception::Http->throw( $response );
  }
}

=method sip

=cut

sub sip {}

=method numbers

=cut

sub numbers {}      # TODO this section needs a bit of thought

=method area_codes

=cut

sub area_codes {}   # TODO this section needs a bit of thought

=method create_call

=cut

sub create_call {}

=method call_details

=cut

sub call_details {} # optional arg == update

=method end_call

=cut

sub end_call {}

=method list_customer_stats

=cut

sub list_customer_stats {}

=method get_customer_stats

=cut

sub get_customer_stats {}

=method send_sms

=cut

sub send_sms {}

=method =send_fax

=cut

sub send_fax {}

__PACKAGE__->meta->make_immutable;
1;
