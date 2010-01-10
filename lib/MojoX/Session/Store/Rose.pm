package MojoX::Session::Store::Rose;

use warnings;
use strict;

use base 'MojoX::Session::Store';

use MIME::Base64;
use Storable qw/nfreeze thaw/;

__PACKAGE__->attr('class');
__PACKAGE__->attr(sid_column => 'sid');
__PACKAGE__->attr(expires_column => 'expires');
__PACKAGE__->attr(data_column => 'data');

=head1 NAME

MojoX::Session::Store::Rose - Rose::DB::Object Store for MojoX::Session

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.02';

=head1 SYNOPSIS

    CREATE TABLE session (
        sid          VARCHAR(40) PRIMARY KEY,
        data         TEXT,
        expires      INTEGER UNSIGNED NOT NULL,
        UNIQUE(sid)
    );

	my $session = MojoX::Session->new( 
		store => MojoX::Session::Store::Rose->new( class => 'My::DB::Session' ), 
		... 
	);

=head1 DESCRIPTION

L<MojoX::Session::Store::Rose> is a store for L<MojoX::Session> that stores a
session in a database using Rose::DB::Object.

=head1 ATTRIBUTES

L<MojoX::Session::Store::DBIC> implements the following attributes.

=head2 class

    my $class = $store->class;
    $class    = $store->class(class);

Get and set Rose::RB::Object class.

=head2 sid_column

Session id column name. Default is 'sid'.

=head2 expires_column

Expires column name. Default is 'expires'.

=head2 data_column

Data column name. Default is 'data'.


=head1 METHODS

L<MojoX::Session::Store::Rose> inherits all methods from L<MojoX::Session::Store>.

=head2 create

Insert session to database.

=cut

sub create {
    my ($self, $sid, $expires, $data) = @_;

    $data = encode_base64(nfreeze($data)) if $data;

    my $sid_column     = $self->sid_column;
    my $expires_column = $self->expires_column;
    my $data_column    = $self->data_column;

    my $rose_class = $self->class;
	die "Rose::DB::Obeject class not defined." 
		unless $rose_class;
	eval "require $rose_class";
		
	my $rose = $rose_class->new(
		$sid_column => $sid, 
		$expires_column => $expires, 
		$data_column => $data
	);
	$rose->save;
}

=head2 update

Update session in database.

=cut

sub update {
    my ($self, $sid, $expires, $data) = @_;

    $data = encode_base64(nfreeze($data)) if $data;

    my $sid_column     = $self->sid_column;
    my $expires_column = $self->expires_column;
    my $data_column    = $self->data_column;

    my $rose_class = $self->class;
	die "Rose::DB::Obeject class not defined." 
		unless $rose_class;
	eval "require $rose_class";
		
	my $rose = $rose_class->new($sid_column => $sid);
	$rose->load;
	$rose->$expires_column( $expires );
	$rose->$data_column( $data );
	$rose->save;
}

=head2 load

Load session from database.

=cut

sub load {
    my ($self, $sid) = @_;

    my $sid_column     = $self->sid_column;
    my $expires_column = $self->expires_column;
    my $data_column    = $self->data_column;

    my $rose_class = $self->class;		
	die "Rose::DB::Obeject class not defined." 
		unless $rose_class;		
	eval "require $rose_class";
	
	my $rose = $rose_class->new($sid_column => $sid);
	return unless $rose->load;
		
	my $expires = $rose->$expires_column;
	my $data    = $rose->$data_column;
	
	$data = thaw(decode_base64($data)) if $data;

    return ($expires, $data);	
}

=head2 delete

Delete session from database.

=cut

sub delete {
    my ($self, $sid) = @_;

    my $resultset  = $self->resultset;
    my $sid_column = $self->sid_column;

    my $rose_class = $self->class;
	die "Rose::DB::Obeject class not defined." 
		unless $rose_class;		
	eval "require $rose_class";
		
	my $rose = $rose_class->new($sid_column => $sid);
	return unless $rose->load;
	
	$rose->delete;
}

=head1 AUTHOR

Sascha Kiefer, C<< <perl at intertivity.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-mojox-session-store-rose at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=MojoX-Session-Store-Rose>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc MojoX::Session::Store::Rose

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=MojoX-Session-Store-Rose>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/MojoX-Session-Store-Rose>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/MojoX-Session-Store-Rose>

=item * Search CPAN

L<http://search.cpan.org/dist/MojoX-Session-Store-Rose/>

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2010 Sascha Kiefer.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of MojoX::Session::Store::Rose
