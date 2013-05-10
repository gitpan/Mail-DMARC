package Mail::DMARC::Base;
{
  $Mail::DMARC::Base::VERSION = '0.20130510';
}
use strict;
use warnings;

use Carp;
use Config::Tiny;

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

1;
# ABSTRACT: utility functions


=pod

=head1 NAME

Mail::DMARC::Base - utility functions

=head1 VERSION

version 0.20130510

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


