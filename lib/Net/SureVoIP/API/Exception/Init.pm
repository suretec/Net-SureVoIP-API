package Net::SureVoIP::API::Exception::Init;
# ABSTRACT: Exceptions arising during initialization of API objects
use Moose;
extends 'Net::SureVoIP::API::Exception';

__PACKAGE__->meta->make_immutable;
1;
