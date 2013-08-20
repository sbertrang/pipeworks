package Pipework::Stage;

use Mojo::Base -base;
use Carp qw( confess );
use Scalar::Util qw( blessed );

sub get
{
	my ( $self, $attribute, $message ) = @_;
	my $gets = $self->gets;

	unless ( ref( $message ) ) {
		confess( "Message is not an object: $message" );
	}

	# make sure the attribute was defined
	unless ( exists( $gets->{ $attribute } ) ) {
		confess( "$self does not get attribute: $attribute" );
	}

	# make sure the message has a matching attribute
	unless ( $message->can( $attribute ) ) {
		confess( "$message has no attribute: $attribute" );
	}

	# fetch value and class
	my $value = $message->$attribute();
	my $class = $gets->{ $attribute };
	my $classes = ref( $class ) ? $class : [ $class ];

	for my $class ( @$classes ) {
		return $value if ref( $value ) eq $class;
		return $value if ( blessed( $value ) || '' ) eq $class;
	}

	confess( "$message has invalid attribute: $attribute: $value ($class)" );
}

sub set
{
	my ( $self, $attribute, $message, $value ) = @_;
	my $sets = $self->sets;

	# make sure the attribute was defined
	unless ( exists( $sets->{ $attribute } ) ) {
		confess( "$self does not set attribute: $attribute" );
	}

	# make sure the message has a matching attribute
	unless ( $message->can( $attribute ) ) {
		confess( "$message has no attribute: $attribute" );
	}

	my $class = $sets->{ $attribute };

	unless ( ref( $value ) ) {
		confess( "$message attribute value needs to be reference: $value ($class)" );
	}

	unless ( ref( $value ) eq $class || blessed( $value ) eq $class ) {
		confess( "$message has invalid attribute: $attribute: $value ($class)" );
	}

	return $message->$attribute( $value );
}

sub process
{
	my ( $self, $message ) = @_;

	die( "Method not implemented: process() in " . ref( $self ) );
}

1;

