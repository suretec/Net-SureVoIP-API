package Net::SureVoIP::API::Response::ServiceStatus;
# ABSTRACT: Response from the support/service_status API endpoint
use Moose;
extends 'Net::SureVoIP::API::Response';

has entries => (
  is => 'ro' , isa => 'ArrayRef' , lazy_build => 1 ,
);

sub _build_entries {
  my( $self ) = @_;

  my @entries;

  foreach my $entry ( @{ $self->decoded_content->{entries} }) {
    push @entries , Net::SureVoIP::API::Response::ServiceStatus::Entry->new($entry);
  }

  return \@entries;
}

has feed_title => ( is => 'ro' , isa => 'Str' , lazy_build => 1 );

sub _build_feed_title { return shift->decoded_content->{feed_title} }

__PACKAGE__->meta->make_immutable;

package # be wery quiet we're hunting dahuts
  Net::SureVoIP::API::Response::ServiceStatus::Entry;

use Moose;

has issued => ( is => 'ro' , isa => 'Str' , required => 1 );
has status => ( is => 'ro' , isa => 'Str' , required => 1 );
has title  => ( is => 'ro' , isa => 'Str' , required => 1 );
has url    => ( is => 'ro' , isa => 'Str' , required => 1 );

__PACKAGE__->meta->make_immutable;
1;
