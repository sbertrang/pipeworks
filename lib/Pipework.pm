package Pipework;

use strict;
use warnings;

1;

__END__

=head1 NAME

Pipework - Pipeline Processing Framework

=head1 SYNOPSIS

  use Pipework::Service::MyDoc;
  my $service = Pipework::Service::MyDoc->new;
  my $message = $service->message( GetBody => {
    url => 'http://localhost/',
  } );
  my $result = $service->invoke( $message );

=head1 DESCRIPTION

This is a message oriented pipeline processing framework to
enable separation of concerns, organization of individual functionality
and improve code-reuse though aspect orientation.

It simply allows to define and organize pipelines that process
messages in multiple steps and return a result.

=cut

