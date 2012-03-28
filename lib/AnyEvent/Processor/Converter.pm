package AnyEvent::Processor::Converter;
{
  $AnyEvent::Processor::Converter::VERSION = '0.003';
}
# ABSTRACT: Role for any converter class

use Moose::Role;


requires 'convert';

1;


__END__
=pod

=encoding UTF-8

=head1 NAME

AnyEvent::Processor::Converter - Role for any converter class

=head1 VERSION

version 0.003

=head1 METHODS

=head2 convert

=head1 AUTHOR

Frédéric Demians <f.demians@tamil.fr>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by Fréderic Demians.

This is free software, licensed under:

  The GNU General Public License, Version 3, June 2007

=cut

