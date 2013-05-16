package Mail::DMARC::Report::View::HTTP;
{
  $Mail::DMARC::Report::View::HTTP::VERSION = '0.20130515';
}
use strict;
use warnings;

use parent 'Mail::DMARC::Report';

sub new {
    my $class = shift;
    return bless {}, $class;
};

1;
# ABSTRACT: view locally stored DMARC reports


=pod

=head1 NAME

Mail::DMARC::Report::View::HTTP - view locally stored DMARC reports

=head1 VERSION

version 0.20130515

=head1 SYNOPSIS

A HTTP interface for the local DMARC report store.

=head1 DESCRIPTION

This is likely to be implemented almost entirely in JavaScript, loading jQuery, jQueriUI, the DataTables plugin, and retrieving the requisite files via CDNs.

=head1 AUTHORS

=over 4

=item *

Matt Simerson <msimerson@cpan.org>

=item *

Davide Migliavacca <shari@cpan.org>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by The Network People, Inc..

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

