use strict;
use Test::More tests => 8;
use WWW::Gazetteer::HeavensAbove;

my $g = WWW::Gazetteer::HeavensAbove->new;
my @cities;

# simple query
@cities = $g->fetch( 'London', 'GB' );

ok( @cities == 1, 'Number of cities named London in GB' );
is_deeply(
    $cities[0],
    {
        latitude   => '51.517',
        regionname => 'county',
        region     => 'Greater London',
        alias      => '',
        elevation  => '18',
        longitude  => '-0.105',
        name       => 'London'
    },
    "London, GB"
);

# non-existant code
eval { $g->fetch( 'foo', 'ZZ' ); };
like( $@, qr/No HA code for ZZ ISO code/, 'Invalid code' );

# more cities
@cities = $g->fetch( 'Paris', 'FR' );

ok( @cities == 2, 'Number of cities named Paris' );

is_deeply(
    $cities[0],
    {
        latitude   => '45.633',
        regionname => 'region',
        region     => 'Rhône-Alpes',
        alias      => 'Les Paris',
        elevation  => '508',
        longitude  => '5.733',
        name       => 'Paris'
    },
    'Les Paris'
);

is_deeply(
    $cities[1],
    {
        latitude   => '48.867',
        regionname => 'region',
        region     => 'Île-de-France',
        alias      => '',
        elevation  => '34',
        longitude  => '2.333',
        name       => 'Paris'
    },
    'Paris'
);

# the US are special
@cities = $g->fetch( 'New york', 'US' );
ok( @cities == 7, 'New York, US' );

is_deeply(
    $cities[0],
    {
        latitude   => '39.685',
        regionname => 'state',
        region     => 'Missouri',
        county     => 'Caldwell',
        alias      => '',
        elevation  => '244',
        longitude  => '-93.927',
        name       => 'New York'
    },
    'New York, Missouri'
);

