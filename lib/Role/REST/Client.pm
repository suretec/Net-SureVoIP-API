package Role::REST::Client;
# ABSTRACT: Moose role implementing a basic config-based REST client
use MooseX::Role::Parameterized;
use 5.010;

use open              qw/ :encoding(UTF-8) :std /;
use strict;
use warnings;

use Class::Load       qw/ :all /;
use Data::Dumper;
use JSON;
use List::MoreUtils   qw/ uniq /;

=head1 SYNOPSIS

    package My::Thing::That::Does::REST;
    use Moose;

    has base_url => ( default => 'http://rest_is_awesome.com/api/v1/' );

    with 'Role::REST::Client' => {
      commands => {
        get_endpoint => {
          path => 'path/relative/to/base/url' ,
          # when not given, method defaults to 'GET'
        },
        get_endpoint_with_url_arg => {
          path => 'path/with/variable/%{arg}s/sub' ,
        },
        post_endpoint => {
          path   => 'path/relative/to/base/url' ,
          method => 'POST' , # this means 'content' is required arg
        },
      },
    };

    # and then in your code that needs to use the API...
    use My::Thing::That::Does::REST;

    my $thing = My::Thing::That::Does::REST->new();

    my $response = $thing->get_endpoint;

    # dies due to missing required argument...
    my $response2 = $thing->get_endpoint_with_url_arg;

    my $response2 = $thing->get_endpoint_with_url_arg({ arg => $arg });

    # dies due to missing required argument...
    my $response3 = $thing->post_endpoint;

    my $response3 = $thing->post_endpoint({ content => $hashref });

=head1 DESCRIPTION

This is a Moose role that implements a configuration-driven simple REST
client. The config maps URLs to method names that get installed in the
namespace of the consuming module. The config also defines which HTTP verb to
use for a given method, required arguments, default argument values, variable
substitution into the URL path, and response handlers that can be specified
for each method. The role uses L<HTTP::Tiny> to send requests, so GET, PUT,
POST, DELETE, and OPTIONS are all supported.

=HEAD1 OPTIONAL METHODS

Classes that consume this role may implement the following methods to alter
the behavior of this role. (The easiest way to do this is to have an attribute
for each of these in the consuming class, but it's also acceptable to provide
standard methods.)

=head2 base_url

If set, this should be a string. It will be prepended to the C<path> component
of each entry in the C<commands> hash (see below) when generating the URL to
be accessed.

=head2 debug

If set, this will enable various debugging behaviors. If you're really
interested, you should probably read the source.

=head2 default_headers

If set, this should be a hash reference. It will be passed to the
L<HTTP::Tiny> constructor as the value of the C<default_headers> key; see the
documentation of that module for more details.

If the API you are using requires, for example, setting a Content-Type header,
this is a good place to do that.

=head2 default_response_handler

If set, this should be the name of a class. When processing the response from a
method, the C<new> method of this class will be called, and passed the hashref
returned by L<HTTP::Tiny>. This can be overridden on a per-command basis in
the C<commands> hashref; see below.

=head1 CONFIGURATION

=head2 Entries in 'commands'

### TODO write this...

=head1 DEBUGGING AND DUMPING RESPONSES

### TODO write this...

=head1 SEE ALSO

=over

=item * L<REST::Client::Simple>

The design of this module -- particularly the structure of the hash passed
when consuming ther role -- was heavily influenced by L<REST::Client::Simple>

=back

=head1 ACKNOWLEDGMENTS

Development of this module was sponsored by SureVOIP as part of the
implementation of Net::SureVoIP::API.

=cut

parameter commands => (
  is       => 'ro' ,
  isa      => 'HashRef' ,
  required => 1 ,
);

role {
  my $p = shift;

  use HTTP::Tiny;
  use String::Errf qw/ errf /;

  has _ua => (
    is         => 'ro' ,
    isa        => 'HTTP::Tiny' ,
    init_arg   => '_inject_ua' ,
    lazy_build => 1 ,
    handles    => [ qw/ get put post delete options / ] ,
  );

  method _build__ua => sub {
    my $self = shift;
    my $default_headers = $self->can('default_headers') ? $self->default_headers : {};
    return HTTP::Tiny->new( default_headers => $default_headers )
  };

  my %commands = %{ $p->commands };

  foreach my $command ( keys %commands ) {
    die "Must have a 'path' in command!"
      unless $commands{$command}{path};

    my $alias;
    $alias = delete $commands{$command}{alias}
      if exists $commands{$command}{alias};

    my $command_opts = {
      # defaults
      path     => $command ,
      method   => 'GET' ,
      args     => { default => {} , required => [] } ,
      # and then anything passed in overrides the defaults
      %{ $commands{$command} }
    };

    method $command => sub {
      my( $self , $args ) = ( @_ , {} );

      $args->{content} = to_json $args->{content}
        if ref $args->{content};

      $args = { %{ $command_opts->{args}{default} } , %$args };

      my $method = lc $command_opts->{method};

      my( @path_subs ) = $command_opts->{path} =~ /\{([^}]+)\}/g;

      my @required_args = uniq (
        @{ $command_opts->{args}{required} } , @path_subs
      );

      push @required_args , 'content'
        if $method eq 'put' or $method eq 'post';

      foreach my $arg ( @required_args ) {
        die "Missing required arg '$arg'"
          unless exists $args->{$arg};
      }

      my $path = errf $command_opts->{path} , $args;
      my $url  = $self->can('base_url') ? join '/' , $self->base_url , $path : $path;

      say STDERR "Doing '$method $url' now..." if $self->can('debug') and $self->debug;

      my $response = $self->$method( $url , $args );

      if ( $self->can('debug') and $self->debug and defined $ENV{SUREVOIP_API_DUMP} ) {
        open( my $dump , '>>' , $ENV{ROLE_REST_CLIENT_DUMP} ) or die $!;
        print $dump Dumper $response;
        close( $dump );
      }

      my $default_response_handler = $self->can('default_response_handler') ?
        $self->default_response_handler : '';

      my $response_handler = $command_opts->{response}
        // $default_response_handler;

      if ( $response_handler ) {
        load_class( $response_handler );
        return $response_handler->new( $response );
      }
      else { return $response }
    }
  };
};

1;
