package Mail::DMARC::Report::View::CLI;
{
  $Mail::DMARC::Report::View::CLI::VERSION = '0.20130515';
}
use strict;
use warnings;

use Carp;
use Data::Dumper;

require Mail::DMARC::Report::Store;

sub new {
    my $class = shift;
    return bless {}, $class;
};

sub list {
    my $self = shift;
    my $reports = $self->store->retrieve;
    foreach my $report ( @$reports ) {
        printf "%3s  %30s  %15s %15s\n", @$report{ qw/ id domain begin end / };
        foreach my $row ( @{$report->{rows}} ) {
            printf "\t%15s  %6s  %6s \n", @$row{ qw/ disposition dkim spf / };
        };
    };
    return $reports;
};

sub detail {
    my $self = shift;
    my $id = shift or croak "need an ID!";
    return $id;
};


sub store {
    my $self = shift;
    return $self->{store} if ref $self->{store};
    return $self->{store} = Mail::DMARC::Report::Store->new();
};

1;
# ABSTRACT: view locally stored DMARC reports


=pod

=head1 NAME

Mail::DMARC::Report::View::CLI - view locally stored DMARC reports

=head1 VERSION

version 0.20130515

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
