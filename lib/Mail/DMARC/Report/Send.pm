package Mail::DMARC::Report::Send;
{
  $Mail::DMARC::Report::Send::VERSION = '0.20130510';
}
use strict;
use warnings;

use Carp;

use parent 'Mail::DMARC::Base';

1;
# ABSTRACT: send a DMARC report object


=pod

=head1 NAME

Mail::DMARC::Report::Send - send a DMARC report object

=head1 VERSION

version 0.20130510

=head1 DESCRIPTION

Send DMARC reports, via SMTP or HTTP.

=head2 Report Sender

A report sender needs to:

  1. store reports
  2. bundle aggregated reports
  3. format report in XML
  4. gzip the XML
  5. deliver report to Author Domain

=head1 12.2.1 Email

L<Mail::DMARC::Report::Send::SMTP>

=head1 12.2.2. HTTP

L<Mail::DMARC::Report::Send::HTTP>

=head1 12.2.3. Other Methods

Other registered URI schemes may be explicitly supported in later versions.

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

