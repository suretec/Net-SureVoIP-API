package Net::SureVoIP::API::Response;
use Moose;

use JSON;

has content  => ( is => 'ro' , isa => 'Str'     , required => 1 );
has headers  => ( is => 'ro' , isa => 'HashRef' , required => 1 );
has protocol => ( is => 'ro' , isa => 'Str'     , required => 1 );
has reason   => ( is => 'ro' , isa => 'Str'     , required => 1 );
has status   => ( is => 'ro' , isa => 'Str'     , required => 1 );
has success  => ( is => 'ro' , isa => 'Bool'    , required => 1 );

has decoded_content => (
  is         => 'ro' ,
  isa        => 'HashRef' ,
  lazy_build => 1 ,
);
# FIXME this needs to deal with situation where content isn't actually JSON...
sub _build_decoded_content { return decode_json shift->content }

__PACKAGE__->meta->make_immutable;
1;
