use strict;
use warnings;

use Module::Build;

### Based on Build.PL for Image::Imlib2

# We need to find xine-config
my $CONFIG = "xine-config";

my $version = `$CONFIG --version`;
if (!$version) {
  warn 'You must install the xine libraries (including development files) before you can install Video::Xine. You can obtain libxine from
http://www.xinehq.de/

Otherwise, if you have installed xine-lib and development libraries, modify the $CONFIG variable inside Build.PL to point to the xine-config program, or otherwise ensure that it is in your path.';
  exit(0);
}

my $libs = `$CONFIG --libs`;
my $cflags = `$CONFIG --cflags`;

my $build = Module::Build->new(
			       extra_compiler_flags => $cflags,
			       extra_linker_flags => $libs,
			       license => 'perl',
			       module_name => 'Video::Xine',
			       requires => {
					    'Module::Build' => '0.28',
					    'Test::More' => '0.01',
					    'ExtUtils::CBuilder' => '0.21'
					   },
			      );

$build->create_build_script();
