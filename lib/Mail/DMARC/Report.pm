package Mail::DMARC::Report;
{
  $Mail::DMARC::Report::VERSION = '0.20130506';
}
use strict;
use warnings;


1;
# ABSTRACT: A DMARC report object


=pod

=head1 NAME

Mail::DMARC::Report - A DMARC report object

=head1 VERSION

version 0.20130506

=head1 SYNOPSIS

REPORT URIs

=head1 EMAIL REPORTS

   The aggregate data MUST be an XML file subjected to GZIP compression.
   The aggregate data MUST be present using the media type "application/
   gzip", and the filenames SHOULD be constructed using the following
   ABNF:

     filename = receiver "!" policy-domain "!" begin-timestamp "!"
                end-timestamp [ "!" unique-id ] "." extension

     unique-id = token
              ; "token" is imported from [MIME]

     receiver = domain
              ; imported from [MAIL]

     policy-domain = domain

     begin-timestamp = 1*DIGIT
                     ; seconds since 00:00:00 UTC January 1, 1970
                     ; indicating start of the time range contained
                     ; in the report

     end-timestamp = 1*DIGIT
                   ; seconds since 00:00:00 UTC January 1, 1970
                   ; indicating end of the time range contained
                   ; in the report

     extension = "xml" / "gzip"

   For the GZIP file itself, the extension MUST be "gz"; for the XML
   report, the extension MUST be "xml".

=head2 SUBJECT FIELD

The RFC5322.Subject field for individual report submissions SHOULD
conform to the following ABNF:

     dmarc-subject = %x52.65.70.6f.72.74 1*FWS    ; "Report"
                     %x44.6f.6d.61.69.6e.3a 1*FWS ; "Domain:"
                     domain-name 1*FWS            ; from RFC6376
                     %x53.75.62.6d.69.74.74.65.72.3a ; "Submitter:"
                     1*FWS domain-name 1*FWS
                     %x52.65.70.6f.72.74.2d.49.44.3a ; "Report-ID:"
                     msg-id                       ; from RFC5322

The first domain-name indicates the DNS domain name about which the
report was generated.  The second domain-name indicates the DNS
domain name representing the Mail Receiver generating the report.
The purpose of the Report-ID: portion of the field is to enable the
Domain Owner to identify and ignore duplicate reports that might be
sent by a Mail Receiver.

This transport mechanism potentially encounters a problem when
feedback data size exceeds maximum allowable attachment sizes for
either the generator or the consumer.  See Section 12.2.4 for further
discussion.

=head1 HTTP

12.2.2.  HTTP

Where an "http" or "https" method is requested in a Domain Owner's
URI list, the Mail Receiver MAY encode the data using the
"application/gzip" media type ([GZIP]) or MAY send the Appendix C
data uncompressed or unencoded.

The header portion of the POST or PUT request SHOULD contain a
Subject field as described in Section 12.2.1.

HTTP permits the use of Content-Transfer-Encoding to upload gzip
content using the POST or PUT instruction after translating the
content to 7-bit ASCII.

=head1 AGGREGATE REPORTS

The report SHOULD include the following data:

   o  Enough information for the report consumer to re-calculate DMARC
      disposition based on the published policy, message dispositon, and
      SPF, DKIM, and identifier alignment results. {R12}

   o  Data for each sender subdomain separately from mail from the
      sender's organizational domain, even if no subdomain policy is
      applied. {R13}

   o  Sending and receiving domains {R17}

   o  The policy requested by the Domain Owner and the policy actually
      applied (if different) {R18}

   o  The number of successful authentications {R19}

   o  The counts of messages based on all messages received even if
      their delivery is ultimately blocked by other filtering agents {R20}

Aggregate reports are most useful when they all cover a common time
period.  By contrast, correlation of these reports from multiple
generators when they cover incongruous time periods is difficult or
impossible.  Report generators SHOULD, wherever possible, adhere to
hour boundaries for the reporting period they are using.  For
example, starting a per-day report at 00:00; starting per-hour
reports at 00:00, 01:00, 02:00; et cetera.  Report Generators using a
24-hour report period are strongly encouraged to begin that period at
00:00 UTC, regardless of local timezone or time of report production,
in order to facilitate correlation.

=head2 Verify External Destinations

  1.  Extract the host portion of the authority component of the URI.
       Call this the "destination host".

   2.  Prepend the string "_report._dmarc".

   3.  Prepend the domain name from which the policy was retrieved.

   4.  Query the DNS for a TXT record at the constructed name.  If the
       result of this request is a temporary DNS error of some kind
       (e.g., a timeout), the Mail Receiver MAY elect to temporarily
       fail the delivery so the verification test can be repeated later.

   5.  If the result includes no TXT resource records or multiple TXT
       resource records, a positive determination of the external
       reporting relationship cannot be made; stop.

   6.  Parse the result, if any, as a series of "tag=value" pairs, i.e.,
       the same overall format as the policy record.  In particular, the
       "v=DMARC1" tag is mandatory and MUST appear first in the list.
       If at least that tag is present and the record overall is
       syntactically valid per Section 6.3, then the external reporting
       arrangement was authorized by the destination ADMD.

   7.  If a "rua" or "ruf" tag is thus discovered, replace the
       corresponding value extracted from the domain's DMARC policy
       record with the one found in this record.  This permits the
       report receiver to override the report destination.  However, to
       prevent loops or indirect abuse, the overriding URI MUST use the
       same destination host from the first step.

=head1 ERROR REPORTS

12.2.4.  Error Reports

When a Mail Receiver is unable to complete delivery of a report via
any of the URIs listed by the Domain Owner, the Mail Receiver SHOULD
generate an error message.  An attempt MUST be made to send this
report to all listed "mailto" URIs and MAY also be sent to any or all
other listed URIs.

The error report MUST be formatted per [MIME].  A text/plain part
MUST be included that contains field-value pairs such as those found
in Section 2 of [DSN].  The fields required, which may appear in any
order, are:

Report-Date:  A [MAIL]-formatted date expression indicating when the
    transport failure occurred.

Report-Domain:  The domain-name about which the failed report was
    generated.

Report-ID:  The Report-ID: that the report tried to use.

Report-Size:  The size, in bytes, of the report that was unable to be
    sent.  This MUST represent the number of bytes that the Mail
    Receiver attempted to send.  Where more than one transport system
    was attempted, the sizes may be different; in such cases, separate
    error reports MUST be generated so that this value matches the
    actual attempt that was made.  For example, a "mailto" error
    report would be sent to the "mailto" URIs with one size, while the
    "https" reports might be POSTed to those URIs with a different
    size, as they have different transport and encoding requirements.

Submitter:  The domain-name representing the Mail Receiver that
    generated, but was unable to submit, the report.

Submitting-URI:  The URI(s) to which the Mail Receiver tried, but
    failed, to submit the report.

An additional text/plain part MAY be included that gives a human-
readable explanation of the above, and MAY also include a URI that
can be used to seek assistance.

[NOTE: A more rigorous syntax specification, including ABNF and
possible registration of a new media type, will be added here when
more operational experience is acquired.]

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



1;
