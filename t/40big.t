use strict;
use Test::More tests => 3;
use WWW::Gazetteer::HeavensAbove;

my @cities;
my $g = WWW::Gazetteer::HeavensAbove->new;

diag( "Be patient... this test suite is very long (49 web requests)");

# star at the end (24 web requests)
@cities = $g->fetch( MX => 'Agua *', $cb);
ok( @cities == 444, "444 cities named 'Agua *' in Mexico");

# star in the middle (16 web requests)
@cities = $g->fetch( CO => 'A*A', $cb);
ok( @cities == 424, "424 cities named 'A*A' in Colombia");

# star at the beginning (9 web requests)
@cities = $g->fetch( UY => '*s', $cb);
ok( @cities == 231, "231 cities named '*s' in Uruguay");
