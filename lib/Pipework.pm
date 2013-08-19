package Pipework;

use strict;
use warnings;

1;

__END__

=head1 NAME

Pipework - Pipeline Processing Framework

=head1 SYNOPSIS

  use Pipework::Line::MyDoc;
  use Pipework::Message::GetBody;
  
  my $line = Pipework::Line::MyDoc->new;
  
  # same as Pipework::Stage::FetchURL->new( ... )
  $line->register( 'FetchURL' );
  $line->register( 'GetDocumentBody' );
  $line->register( sub { my $msg = shift; warn( "body:\n" . $msg->body ) } );
  
  # same as Pipework::Message::GetBody->new( ... )
  my $message = $line->message( GetBody => {
    url => 'http://localhost/',
  } );
  my $result = $line->process( $message );

=head1 DESCRIPTION

This is a message oriented pipeline processing framework to
enable separation of concerns, organization of individual functionality
and improve code-reuse though aspect orientation.

It simply allows to define and organize pipelines that process
messages in multiple steps and return a result.

=head1 HISTORY

Originally the basic idea is inspired by UNIX concepts.
There was a lot of thinking how to represent a similar model in programming
without losing important benefits that UNIX provides.
When Steve Bate wrote a blog post about L<Messaging as a Programming Model|http://eventuallyconsistent.net/2013/08/12/messaging-as-a-programming-model-part-1/>
things came together, started to make sense and code began to materialize this
implementation.

=head1 SEE ALSO

L<http://eventuallyconsistent.net/2013/08/12/messaging-as-a-programming-model-part-1/>,
L<http://eventuallyconsistent.net/2013/08/14/messaging-as-a-programming-model-part-2/>,
L<http://eventuallyconsistent.net/2013/08/19/messaging-as-a-programming-model-revisited/>

=cut

