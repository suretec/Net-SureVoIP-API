package Role::REST::Client;
# ABSTRACT: Moose role implementing a basic config-based REST client
use MooseX::Role::Parameterized;
use 5.010;

### FIXME POD

parameter commands => (
  isa      => 'HashRef' ,
  required => 1 ,
);

role {
  my $p = shift;

  requires
    'base_url',
    'default_headers',
    'default_response_handler',
  ;

  use HTTP::Tiny;
  use String::Errf qw/ errf /;

=attr debug

### FIXME POD

=cut

  has debug => (
    is      => 'ro' ,
    isa     => 'Bool' ,
    default => 0 ,
  );

#attr _ua

  has _ua => (
    is         => 'ro' ,
    isa        => 'HTTP::Tiny' ,
    init_arg   => '_inject_ua' ,
    lazy_build => 1 ,
    handles    => [ qw/ get put post delete options / ] ,
  );

  ### FIXME need to provide a way to augment the default headers? or just
  ### document that it's totally consumer's responsibility to make sure headers
  ### are sufficient for request?
  method _build__ua => sub {
    return HTTP::Tiny->new( default_headers => shift->default_headers )
  };

  my %commands = %{ $p->commands };

  foreach my $command ( keys %commands ) {
    my $alias;
    $alias = delete $commands{$command}{alias}
      if exists $commands{$command}{alias};

    my $command_opts = {
      # defaults
      path     => $command ,
      method   => 'GET' ,
      # and then anything passed in overrides the defaults
      %{ $commands{$command} }
    };

    if ( defined $command_opts->{args} ) {
      ### FIXME deal with making field keys in the path required even if they're not listed.
      ### FIXME and implement this in general
      die "args not supported yet";
    }

    method $command => sub {
        my( $self , $args ) = @_;

        $args //= {};

        # TODO check args versus default & required here

        my $path = errf $command_opts->{path} , $args;
        my $url  = join '/' , $self->base_url , $path;

        my $method = lc $command_opts->{method};

        say STDERR "Doing '$method $url' now..."
          if $self->debug;

        my $response = $self->$method( $url );

        # TODO log response to disk
        #   if $self->debug

        ### FIXME need to make sure that $response_handler class is loaded --
        ### Class::Load or the like.

        my $response_handler = $command_opts->{response} // $self->default_response_handler;

        return $response_handler->new( $response );
      };
  };
};

1;
