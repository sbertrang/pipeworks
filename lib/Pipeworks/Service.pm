package Pipeworks::Service;

use Mojo::Base -base;
use Mojo::Loader;

# pipeline class to use
has "class" => "Pipeworks::Pipeline";

# pipeline name to message class mapping
has "messages" => sub { {} };

sub new
{
	my $self = shift->SUPER::new( @_ );
	my $class = $self->class;

	my $e = Mojo::Loader::load_class( $class );

	if ( ref( $e ) ) {
		warn( "FAIL: $e\n\n$@" );
		return undef;
	}

	my $messages = $self->messages;

	for my $name ( keys( %$messages ) ) {
		$self->{pipeline}{ $name } =
		    $class->new( $messages->{ $name }, name => $name );

		# make sure the message class mapping reflects the pipeline type
		$messages->{ $name } = $self->{pipeline}{ $name }{type};
	}

	return $self;
}

sub pipeline
{
	my $self = shift;
	my $name = shift;
	my $messages = $self->messages;

	unless ( exists( $messages->{ $name } ) ) {
		return undef;
	}

	return $self->{pipeline}{ $name };
}

# create a new message with the given type
sub message
{
	my $self = shift;
	my $name = shift;
	my $messages = $self->messages;

	unless ( exists( $messages->{ $name } ) ) {
		die( "No such message type: $name" );
	}

	my $class = $messages->{ $name };

	return $class->new( @_ );
}

1;

__END__

=head1 NAME

Pipeworks::Service - Base class for pipepline service interfaces

=head1 SYNOPSIS

  # lib/FooPipe/Service.pm
  package FooPipe::Service;
  
  use Mojo::Base qw( Pipeworks::Service );
  
  has class => "FooPipe::Pipeline";
  has messages => sub { {
      GetFoo => "+FooPipe::Message::GetFoo",
  } };
  
  sub new {
      my $self = shift->SUPER::new( @_ );
  
      $self->pipeline( "GetFoo" )
           ->register( "FetchURL" )
      ;
  
      return $self;
  }

  # script/foo-pipe
  use FooPipe::Service;
  
  my $service = FooPipe::Service->new();
  my $message = $service->message( "GetFoo" );
  
  $message->url( "http://..." );
  $service->invoke( $message );
  my $result = $message->res();

=head1 DESCRIPTION

This base class provides a common interface to bundle multiple pipelines
as callable units with a few convenience methods.

=head1 ATTRIBUTES

=head2 class

The pipeline class to use.

=head2 messages

Pipeline name to message class mapping to setup pipelines and create
messages.

=head1 METHODS

=head2 new()

Constructor returning a new service instance.

=head2 pipeline( $name )

Returns a pipeline instance corresponding to the message type from
the L<messages> mapping.

=head2 message( $name )

Returns a new message instance corresponding to the message type class
from the L<messages> mapping.

=head2 invoke( $message )

Message type dispatcher that needs to be implemented by a child class.

=cut
