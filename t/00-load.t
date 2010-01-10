#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'MojoX::Session::Store::Rose' ) || print "Bail out!
";
}

diag( "Testing MojoX::Session::Store::Rose $MojoX::Session::Store::Rose::VERSION, Perl $], $^X" );
