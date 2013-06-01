package Mail::DMARC::Report::Send;
our $VERSION = '1.20130601'; # VERSION
use strict;
use warnings;

use Carp;
use Encode;
use IO::Compress::Gzip;
use IO::Compress::Zip;

use lib 'lib';
use parent 'Mail::DMARC::Base';
use Mail::DMARC::Report::Send::SMTP;
use Mail::DMARC::Report::Send::HTTP;
use Mail::DMARC::Report::URI;

sub send_rua {
    my ( $self, $agg_ref, $xml_ref ) = @_;

    my $shrunk = $self->compress_report($xml_ref);
    my $bytes  = length Encode::encode_utf8($shrunk);

    my $uri_ref = $self->uri->parse( $$agg_ref->{policy_published}{rua} );
    my $sent    = 0;
    foreach my $u_ref (@$uri_ref) {
        my $method = $u_ref->{uri};
        my $max    = $u_ref->{max_bytes};

        if ( $max && $bytes > $max ) {
            carp "skipping $method: report size ($bytes) larger than $max\n";
            next;
        }

        if ( 'mailto:' eq substr( $method, 0, 7 ) ) {
            $self->send_via_smtp( $method, $agg_ref, $shrunk ) and $sent++;
        }
        if ( 'http:' eq substr( $method, 0, 5 ) ) {
            $self->http->post( $method, $agg_ref, $shrunk ) and $sent++;
        }
    }
    return $sent;
}

sub human_summary {
    my ( $self, $agg_ref ) = @_;

    my $rows    = scalar @{ $$agg_ref->{record} };
    my $OrgName = $self->config->{organization}{org_name};
    my $pass    = grep { $_->{dkim} eq 'pass' || $_->{spf} eq 'pass' }
        @{ $$agg_ref->{record} };
    my $fail = grep { $_->{dkim} ne 'pass' && $_->{spf} ne 'pass' }
        @{ $$agg_ref->{record} };
    my $ver = $Mail::DMARC::VERSION || '';    # undef in author environ
    my $from = $$agg_ref->{policy_published}{domain} or croak;

    return <<"EO_REPORT"

This is a DMARC aggregate report for $from

$rows rows.
$pass passed.
$fail failed.

Submitted by $OrgName
Generated with Mail::DMARC $ver

EO_REPORT
        ;
}

sub compress_report {
    my ( $self, $xml_ref ) = @_;
    croak "xml is not a reference!" if 'SCALAR' ne ref $xml_ref;
    my $shrunk;
    my $zipper = {
        gz  => \&IO::Compress::Gzip::gzip,    # 2013 draft
        zip => \&IO::Compress::Zip::zip,      # legacy format
    };
# WARNING: changes here MAY require updates in SMTP::_assemble_message
#   my $cf = ( time > 1372662000 ) ? 'gz' : 'zip';    # gz after 7/1/13
    my $cf = 'gz';
    $zipper->{$cf}->( $xml_ref, \$shrunk ) or croak "unable to compress: $!";
    return $shrunk;
}

sub send_via_smtp {
    my ( $self, $method, $agg_ref, $shrunk ) = @_;
    my ($to) = ( split /:/, $method )[-1];

    # TODO: check results, append error to report if failed
    return $self->smtp->email(
        to            => $to,
        subject       => $self->smtp->get_subject( $agg_ref ),
        body          => $self->human_summary($agg_ref),
        report        => $shrunk,
        policy_domain => $$agg_ref->{policy_published}{domain},
        begin         => $$agg_ref->{metadata}{date_range}{begin},
        end           => $$agg_ref->{metadata}{date_range}{end},
        report_id     => $$agg_ref->{metadata}{report_id},
    );
}

sub http {
    my $self = shift;
    return $self->{http} if ref $self->{http};
    return $self->{http} = Mail::DMARC::Report::Send::HTTP->new();
}

sub smtp {
    my $self = shift;
    return $self->{smtp} if ref $self->{smtp};
    return $self->{smtp} = Mail::DMARC::Report::Send::SMTP->new();
}

sub uri {
    my $self = shift;
    return $self->{uri} if ref $self->{uri};
    return $self->{uri} = Mail::DMARC::Report::URI->new();
}

1;

# ABSTRACT: send a DMARC report object

=pod

=head1 NAME

Mail::DMARC::Report::Send - send a DMARC report object

=head1 VERSION

version 1.20130601

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

=head1 CONTRIBUTOR

ColocateUSA.net <company@colocateusa.net>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by ColocateUSA.com.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

__END__
sub {}

