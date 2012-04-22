package Net::SureVoIP::API::Response::Customer;
# ABSTRACT: Response for the 'show_customer' API endpoint
use Moose;
extends 'Net::SureVoIP::API::Response';

has firstname       => ( is => 'ro' , isa => 'Str' );
has lastname        => ( is => 'ro' , isa => 'Str' );
has company_name    => ( is => 'ro' , isa => 'Str' );
has address         => ( is => 'ro' , isa => 'Str' );
has city            => ( is => 'ro' , isa => 'Str' );
has state           => ( is => 'ro' , isa => 'Str' );
has postcode        => ( is => 'ro' , isa => 'Str' );
has country         => ( is => 'ro' , isa => 'Str' );
has email           => ( is => 'ro' , isa => 'Str' );
has phone           => ( is => 'ro' , isa => 'Str' );
has fax             => ( is => 'ro' , isa => 'Str' );
has company_website => ( is => 'ro' , isa => 'Str' );
has username        => ( is => 'ro' , isa => 'Str' );
has balance         => ( is => 'ro' , isa => 'Num' );
has creditlimit     => ( is => 'ro' , isa => 'Num' );

__PACKAGE__->meta->make_immutable;
1;
