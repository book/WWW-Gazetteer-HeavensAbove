use strict;
use warnings;
use t::Util;
use Test::More;
use WWW::Gazetteer::HeavensAbove;

plan skip_all => 'WWW::Gazetteer::HeavensAbove is now obsolete';

plan 'skip_all' => 'Internet connection required to run this test'
   if ! web_ok();

plan tests => 12;

my $g = WWW::Gazetteer::HeavensAbove->new( retry => 10 );
my @cities;

# simple query
@cities = $g->query( 'London', 'UK' );

ok( @cities == 1, 'Number of cities named London in UK' );
my $london = {
    'iso'        => 'GB',
    'latitude'   => '51.517',
    'regionname' => 'county',
    'region'     => 'Greater London',
    'elevation'  => '18',
    'longitude'  => '-0.105',
    'name'       => 'London'
};

is_deeply( $cities[0], $london, "London, UK" );

# case doesn't matter
@cities = $g->query( 'London', 'uk' );
ok( @cities == 1, 'Number of cities named london in uk' );
is_deeply( $cities[0], $london, "london, uk" );

# complicated queries
@cities = $g->query( 'Mazar*i*f', 'AF' );
my @tests = (
    {
        'iso'        => 'AF',
        'latitude'   => '36.700',
        'regionname' => 'region',
        'region'     => 'Balkh',
        'elevation'  => '363',
        'longitude'  => '67.100',
        'name'       => 'Mazar-e Sharif'
    },
    {
        'iso'        => 'AF',
        'latitude'   => '36.700',
        'regionname' => 'region',
        'region'     => 'Balkh',
        'elevation'  => '363',
        'longitude'  => '67.100',
        'name'       => 'Mazar-i-Sharif'
    },
    {
        'iso'        => 'AF',
        'latitude'   => '36.700',
        'regionname' => 'region',
        'region'     => 'Balkh',
        'elevation'  => '363',
        'longitude'  => '67.100',
        'name'       => 'Mazare Srif'
    }
);

is_deeply( $cities[$_], $tests[$_], $tests[$_]{name} ) for 0 .. 2;

# a HA country code that doesn't exist
eval { @cities = $g->find( 'Brest', 'ZZ' ); };
like( $@, qr/No HA code for ZZ ISO code/, 'Invalid code' );

# a HA country code that doesn't exist
eval { @cities = $g->query( 'Brest', 'RU' ); };
like( $@, qr/500 Internal Server Error/, 'Invalid code' );

# a country without regions
@cities = $g->query( 'Fitii', 'FP' );
ok( @cities == 1, "Fitii, French Polynesia" );
is_deeply(
    $cities[0],
    {
        iso        => 'PF',
        latitude   => -16.733,
        longitude  => -151.033,
        elevation  => 77,
        region     => '',
        regionname => '',
        name       => 'Fitii'
    },
    "French Polynesia has no region"
);

# query returns an arrayref in scalar context
my $cities = $g->query( 'Paris', 'FR' );
ok( $cities->[1]{longitude} == 2.333, "query() in scalar context" );

