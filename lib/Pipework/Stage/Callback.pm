package Pipework::Stage::Callback;

use Mojo::Base qw( Pipework::Stage );

sub new
{
	my ( $class, $code ) = @_;
	my $self = bless( $code, $class );

	return $self;
}

sub process
{
	my $self = shift;

	return $self->( @_ );
}

1;

__END__

=head1 NAME

Pipework::Stage::Callback - light wrapper to put closures in stages

=head1 SYNOPSIS

  my $stage = Pipework::Stage::Callback->new( sub { ... } );
  
  $stage->process( ... );

=head1 DESCRIPTION

This simple stage class just takes a code reference and blesses into its
namespace in order to provide a process() method for compatibility with the
pipeline calling convention.

=cut

