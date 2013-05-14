package Mail::DMARC::Base;
{
  $Mail::DMARC::Base::VERSION = '0.20130514';
}
use strict;
use warnings;

use Carp;
use Config::Tiny;
use Socket 2;

sub new {
    my ($class, @args) = @_;
    croak "invalid args" if scalar @args % 2 != 0;
    return bless {
        config_file => 'mail-dmarc.ini',
        @args,    # this may override config_file
    }, $class;
};

sub config {
    my ($self, $file, @too_many) = @_;
    croak "invalid args" if scalar @too_many;
    return $self->{config} if ref $self->{config} && ! $file;
    return $self->{config} = $self->get_config($file);
};  
    
sub get_config {
    my $self = shift;
    my $file = shift || $self->{config_file} or croak;
    my @dirs = qw[ /usr/local/etc /opt/local/etc /etc ./ ];
    foreach my $d ( @dirs ) {
        next if ! -d $d;
        next if ! -e "$d/$file";
        croak "unreadable file: $d/$file" if ! -r "$d/$file";
        my $Config = Config::Tiny->new;
        return Config::Tiny->read( "$d/$file" );
    };
    croak "unable to find config file $file\n";
}

sub inet_ntop {
    my ($self, $ip_bin) = @_;
    $ip_bin or croak "missing IP in request";

    if ( length $ip_bin == 16 ) {
        return Socket::inet_ntop( AF_INET6, $ip_bin );
    };

    return Socket::inet_ntop( AF_INET, $ip_bin );
};

sub inet_pton {
    my ($self, $ip_txt) = @_;
    $ip_txt or croak "missing IP in request";

    if ( $ip_txt =~ /:/ ) {
        return Socket::inet_pton( AF_INET6, $ip_txt ) or croak "invalid IPv6: $ip_txt";
    };

    return Socket::inet_pton( AF_INET, $ip_txt ) or croak "invalid IPv4: $ip_txt";
};

1;
# ABSTRACT: utility functions


=pod

=head1 NAME

Mail::DMARC::Base - utility functions

=head1 VERSION

version 0.20130514

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

