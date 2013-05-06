package Mail::DMARC::Result;
{
  $Mail::DMARC::Result::VERSION = '0.20130506';
}
use strict;
use warnings;

use Carp;

use parent 'Mail::DMARC';
use Mail::DMARC::Result::Evaluated;

sub published {
    my ($self, $policy) = @_;

    if ( ! $policy ) {
        if ( ! defined $self->{published} ) {
            croak "no policy discovered. Did you validate(), or at least fetch_dmarc_record() first? Or inspected evaluated results to detect a 'No Results Found' type error?";
        };
        return $self->{published};
    };

    $policy->{domain} or croak "tag the policy object with a domain indicating where the DMARC record was found!";
    return $self->{published} = $policy;
};

sub evaluated {
    my $self = shift;
    return $self->{evaluated} if ref $self->{evaluated};
    return $self->{evaluated} = Mail::DMARC::Result::Evaluated->new();
};

1;
# ABSTRACT: DMARC processing results


=pod

=head1 NAME

Mail::DMARC::Result - DMARC processing results

=head1 VERSION

version 0.20130506

=head1 METHDS

=head2 published

Published is a L<Mail::DMARC::Policy> object with one extra attribute: domain. The domain attribute is the DNS domain name where the DMARC record was found.

=head2 evaluated

The B<evaluated> method is L<Mail::DMARC::Result::Evaluated> object. See the man page for that method for details.

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

