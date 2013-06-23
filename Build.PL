use strict;
use warnings;

use Module::Build;
use Config;
use ExtUtils::PkgConfig;

### Based on Build.PL for Image::Imlib2
if (! $Config{'usethreads'}) {
    warn "Unable to install. The Xine module requires multithread support.\n";
    exit(0);
}

# We need to find xine-config
my %xine_config = ExtUtils::PkgConfig->find('libxine');

my $build = Module::Build->new(
			       extra_compiler_flags => $xine_config{'cflags'},
			       extra_linker_flags => $xine_config{'libs'},
			       license => 'perl',
			       module_name => 'Video::Xine',
			       requires => {
					    'Module::Build' => '0',
					    'Test::More' => '0.01',
					    'ExtUtils::CBuilder' => '0',
					    'DateTime' => '0',
					    'ExtUtils::PkgConfig' => '0'
					   },
			       recommends => {
					      'X11::FullScreen' => '0',
					      'perl' => '5.8.5',
					      'DateTime::Format::Duration' => 0
					     },
			      );

$build->create_build_script();

