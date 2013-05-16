package Mail::DMARC::Report::Store;
{
  $Mail::DMARC::Report::Store::VERSION = '0.20130515';
}
use strict;
use warnings;

use Carp;

use parent 'Mail::DMARC::Base';

sub save {
    my $self = shift;
    my $dmarc = shift or croak "need a DMARC object!";
    return $self->backend->save($dmarc);
};

sub delete_report {
    my $self = shift;
    return $self->backend->delete_report(@_);
};

sub retrieve {
    my $self = shift;
    return $self->backend->retrieve(@_);
};

sub backend {
    my $self = shift;
    my $backend = $self->config->{report_store}{backend};

    croak "no backend defined?!" if ! $backend;

    return $self->{$backend} if ref $self->{$backend};
    my $module = "Mail::DMARC::Report::Store::$backend";
    eval "use $module";  ## no critic (Eval)
    if ( $@ ) {
        croak "Unable to load backend $backend: $@\n";
    };

    return $self->{$backend} = $module->new;
};

1;
# ABSTRACT: persistent storage broker for DMARC reports


=pod

=head1 NAME

Mail::DMARC::Report::Store - persistent storage broker for DMARC reports

=head1 VERSION

version 0.20130515

=head1 DESCRIPTION

I struggled with choosing between a perl AnyDBM storage backend versus a SQL backend. I deployed with SQL because with a single SQL implementation, the user can choose from the wide availability of DBD drivers, including SQLite, MySQL, DBD (same as AnyDBM) and many others.

Others might like an alternative. This layer of indirection allows someone to write a new Mail::DMARC::Report::Store::MyGreatDB module, update their config file, and not alter the innards of Mail::DMARC.

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
