use lib qw(inc);

use strict;
use warnings;

use PkgConfBuild;

my $build = PkgConfBuild->new(
    license              => 'perl',
    module_name          => 'Video::Xine',
    configure_requires   => {
        'ExtUtils::PkgConfig' => '0',
        'Module::Build'       => '0',
        'Devel::CheckLib'     => '0'
    },
    build_requires => {
        'ExtUtils::CBuilder' => '0',
    },
    test_requires => {
        'Test::More' => '0.01',
        'Test::Kwalitee' => 0,
        'Test::Pod::Coverage' => 0
    },
    requires => {
        'DateTime'        => '0',
        'DateTime::Format::Duration' => 0,
        'X11::FullScreen' => '0.992',
        'perl'            => '5.8.3'
    },
    meta_merge => {
    	resources => {
    		repository => 'https://github.com/stephenenelson/video-xine'
    	}
    }
);

$build->create_build_script();

