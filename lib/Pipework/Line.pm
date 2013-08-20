package Pipework::Line;

use Mojo::Base -base;
use Mojo::Loader;
use Pipework::Stage::Callback;
use Scalar::Util qw( blessed );

has stages => sub { [] };
has loader => sub { Mojo::Loader->new };

# message class a pipeline can operate with
has "type";
has "namespace" => "Pipework";

sub new
{
	my $class = shift;
	my $type = @_ > 0 # when a type was given
	         ? shift  # ... use it
	         : $class =~ m!::([^:]+)\z! # otherwise take the last
	           ? $1                     # part of the class
	           : ""
	;
	my $self = $class->SUPER::new( @_ );
	my $namespace = $self->namespace;
	my $message = $type =~ m!\A[+](.*)!
		    ? $1
		    : "${namespace}::Message::$type"
	;
	my $loader = $self->loader;

	if ( ref( my $e = $loader->load( $message ) ) ) {
		warn( "FAIL: e=$e, \@=$@" );
		return undef;
	}

	$self->type( $message );

	return $self;
}

sub register
{
	my $self = shift;
	my $stage = shift;
	my $stages = $self->stages;
	my $type = $self->type;
	my $object;

	# pipeline or stage object
	if ( blessed( $stage ) &&
	    ( $stage->isa( 'Pipework::Stage' ) ||
	      $stage->isa( 'Pipework::Line' ) ) ) {
		$object = $stage;
	}
	# code reference
	elsif ( ref( $stage ) eq 'CODE' ) {
		$object = Pipework::Stage::Callback->new( $stage );
	}
	# class names
	else {
		my $loader = $self->loader;
		my $class = $stage =~ m!\A[+](.*)!
		          ? $1
		          : "Pipework::Stage::$stage"
		;

		my $e = $loader->load( $class );

		if ( ref( $e ) || $@ ) {
			warn( "FAIL: e=$e, \@=$@" );
		}

		$object = $class->new( @_ );
	}

	push( @$stages, $object );

	return $self;
}

sub process
{
	my $self = shift;
	my $message = shift;
	my $stages = $self->stages;

	for my $stage ( @$stages ) {
		$stage->process( $message );
	}

	return $message;
}

sub message
{
	my $self = shift;
	my $type = $self->type;
	my $message = $type->new( @_ );

	return $message;
}

1;

__END__

=head1 NAME

Pipework::Line - Pipeline base class with top-level functionality

=head1 SYNOPSIS

  my $pipeline = Pipework::Line->new;
  $pipeline->register( sub { ... } );
  $pipeline->process( { ... } );

=cut

