package Mail::DMARC::Report::Send::HTTP;
{
  $Mail::DMARC::Report::Send::HTTP::VERSION = '0.20130515';
}
use strict;
use warnings;

use Carp;
#use Data::Dumper;

use parent 'Mail::DMARC::Base';


1;
# ABSTRACT: send DMARC reports via HTTP


=pod

=head1 NAME

Mail::DMARC::Report::Send::HTTP - send DMARC reports via HTTP

=head1 VERSION

version 0.20130515

=head1 12.2.2. HTTP

Where an "http" or "https" method is requested in a Domain Owner's
URI list, the Mail Receiver MAY encode the data using the
"application/gzip" media type ([GZIP]) or MAY send the Appendix C
data uncompressed or unencoded.

The header portion of the POST or PUT request SHOULD contain a
Subject field as described in Section 12.2.1.

HTTP permits the use of Content-Transfer-Encoding to upload gzip
content using the POST or PUT instruction after translating the
content to 7-bit ASCII.

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
sub {}

