use strict;
use Test::More tests => 7;
use WWW::Gazetteer::HeavensAbove;

my $g = WWW::Gazetteer::HeavensAbove->new;
my @cities;

# simple query
@cities = $g->query( 'UK', 'London' );

ok( @cities == 1, 'Number of cities named London in UK' );
my $london = {
    'latitude'   => '51.517',
    'regionname' => 'County',
    'region'     => 'Greater London',
    'alias'      => '',
    'elevation'  => '18 m',
    'longitude'  => '-0.105',
    'name'       => 'London'
};

is_deeply( $cities[0], $london, "London, UK" );

# case doesn't matter
@cities = $g->query( 'uk', 'London' );
ok( @cities == 1, 'Number of cities named london in uk' );
is_deeply( $cities[0], $london, "london, uk" );

# complicated queries
@cities = $g->query( 'AF', 'Mazar*i*f' );
my @tests = (
    {
        'latitude'   => '36.700',
        'regionname' => 'Region',
        'region'     => 'Balkh',
        'alias'      => '',
        'elevation'  => '363 m',
        'longitude'  => '67.100',
        'name'       => 'Mazar-e Sharif'
    },
    {
        'latitude'   => '36.700',
        'regionname' => 'Region',
        'region'     => 'Balkh',
        'alias'      => 'Mazar-e Sharif',
        'elevation'  => '363 m',
        'longitude'  => '67.100',
        'name'       => 'Mazar-i-Sharif'
    },
    {
        'latitude'   => '36.700',
        'regionname' => 'Region',
        'region'     => 'Balkh',
        'alias'      => 'Mazar-e Sharif',
        'elevation'  => '363 m',
        'longitude'  => '67.100',
        'name'       => 'Mazare Srif'
    }
);

is_deeply( $cities[$_], $tests[$_], $tests[$_]{name} ) for 0 .. 2;

