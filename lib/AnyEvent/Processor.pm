package AnyEvent::Processor;
#ABSTRACT: Base class to define an event-driven (AnyEvent) task that could periodically be interrupted by a watcher
$AnyEvent::Processor::VERSION = '0.004';
use Moose;

use 5.010;
use AnyEvent;
use AnyEvent::Processor::Watcher;

with 'AnyEvent::Processor::WatchableTask';


has verbose => ( is => 'rw', isa => 'Int' );

has watcher => ( 
    is => 'rw', 
    isa => 'AnyEvent::Processor::Watcher',
);

has count => ( is => 'rw', isa => 'Int', default => 0 );

has blocking => ( is => 'rw', isa => 'Bool', default => 0 );


sub run {
    my $self = shift;
    if ( $self->blocking) {
        $self->run_blocking();
    }
    else {
        $self->run_task();
    }
}


sub run_blocking {
    my $self = shift;
    while ( $self->process() ) {
        ;
    }
}


sub run_task {
    my $self = shift;

    $self->start_process();

    if ( $self->verbose ) {
        $self->watcher( AnyEvent::Processor::Watcher->new(
            delay => 1, action => $self ) ) unless $self->watcher;
        $self->watcher->start();
    }

    my $end_run = AnyEvent->condvar;
    my $idle = AnyEvent->idle(
        cb => sub {
            unless ( $self->process() ) {
                $self->end_process();
                $self->watcher->stop() if $self->watcher;
                $end_run->send;
            }
        }
    );
    $end_run->recv;
}


sub start_process { }


sub start_message {
    print "Start process...\n";
}


sub process {
    my $self = shift;
    $self->count( $self->count + 1 );
    return 1;
}


sub process_message {
    my $self = shift;
    print sprintf("  %#6d", $self->count), "\n";    
}


sub end_process { return 0; }


sub end_message {
    my $self = shift; 
    print "Number of items processed: ", $self->count, "\n";
}


no Moose;
__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

AnyEvent::Processor - Base class to define an event-driven (AnyEvent) task that could periodically be interrupted by a watcher

=head1 VERSION

version 0.004

=head1 ATTRIBUTES

=head2 verbose

Verbose mode. In this mode an AnyEvent::Processor::Watcher is automatically
created, with a 1s timeout, and action directly sent to this class. You can
create your own watcher subclassing AnyEvent::Processor::Watcher.

=head2 watcher

An AnyEvent::Processor::Watcher.

=head2 count

Number of items which have been processed.

=head2 blocking

Is it a blocking task (not a task). False by default.

=head1 METHODS

=head2 run

Run the process.

=head2 start_process

Something to do at begining of the process.

=head2 start_message

Something to say about the process. Called by default watcher when verbose mode enabled.

=head2 process

Process something and increment L<count>.

=head2 process_message

Say something about the process. Called by default watcher (verbose mode) each
1s. Each time process is called, count in incremented.

=head2 end_process

Do something at the end of the process.

=head2 end_message

Say something at the end of the process. Called by default watcher.

=head1 AUTHOR

Frédéric Demians <f.demians@tamil.fr>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2014 by Fréderic Demians.

This is free software, licensed under:

  The GNU General Public License, Version 3, June 2007

=cut
