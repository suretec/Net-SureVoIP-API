package Net::SureVoIP::API;
# ABSTRACT: Perl library for SureVoIP REST API
use Moose;

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

sub ip_address {}

=method service_status

=cut

sub service_status {}

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
