package Net::SureVoIP::API::Exception;
use Moose;
with 'Throwable::X';

use overload
  fallback => 1 ,
  '""'     => 'to_string';

sub BUILDARGS {
  my $class = shift;

  my %args;

  if ( @_ == 1 ) {
    my $error = shift;

    my $ident;

    if ( ref $error ) {
      if ( $error->{content} ) { $ident = $error->{content} }
      else { $ident = 'Unable to parse returned error' }
    }
    else { $ident = $error }

    %args = ( ident => $ident );
  }
  else { %args = ref $_[0] ? %{ $_[0] } : @_; }

  return \%args;
}

sub to_string {
  my $self = shift;

  my $stringified = $self->message;
  $stringified .= sprintf "\nSTACK TRACE:\n%s\n" , $self->stack_trace->as_string
    if $self->can('stack_trace');

  return $stringified;
}

__PACKAGE__->meta->make_immutable;
1;
