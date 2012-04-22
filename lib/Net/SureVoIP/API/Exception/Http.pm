package Net::SureVoIP::API::Exception::Http;
# ABSTRACT: Exceptions arising during HTTP transactions
use Moose;
extends 'Net::SureVoIP::API::Exception';

__PACKAGE__->meta->make_immutable;
1;
