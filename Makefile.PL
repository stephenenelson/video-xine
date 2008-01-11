##
## Currently I'm seeing many error reports from CPAN smoke testers
## who don't have Module::Build installed. This Makefile.PL is an attempt
## to avoid those smoke tests while still giving Makefile.PL compatibility
## where possible.
##


use strict;
use warnings;
use Config;

if (! eval("use Module::Build::Compat; 1;") ) {
    warn "*** Cannot install without Module::Build. Exiting ...\n";
    exit(0);
}
Module::Build::Compat->import('run_build_pl');

### Based on Build.PL for Image::Imlib2
if (! $Config{'usethreads'}) {
    warn "Unable to install. The Xine module requires multithread support.\n";
    exit(0);
}

# We need to find xine-config
my $CONFIG = "xine-config";

my $version = `$CONFIG --version`;
if (!$version) {
  warn 'You must install the xine libraries (including development files) before you can install Video::Xine. You can obtain libxine from
http://www.xinehq.de/

Otherwise, if you have installed xine-lib and development libraries, modify the $CONFIG variable inside Build.PL to point to the xine-config program, or otherwise ensure that it is in your path.';
  exit(0);
}

Module::Build::Compat->run_build_pl(args => \@ARGV);
Module::Build::Compat->write_makefile(build_class => 'Module::Build');

