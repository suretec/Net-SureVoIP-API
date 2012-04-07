package Net::SureVoIP::API::Response;
use Moose;

use JSON;

sub BUILDARGS {
  my $class = shift;

  return @_ if ( @_ > 1 );

  return $_[0] if ref $_[0];

  return decode_json $_[0];
}

__PACKAGE__->meta->make_immutable;
1;
