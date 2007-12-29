use strict;
use warnings;

use 5.008003;
use ExtUtils::MakeMaker;
use File::Spec;

my ($xine_include, $xine_lib);
if ( my $xc = find_xine_config() ) {
    my $xine_lib_str = qx/$xc --libs/;
    my @lib_dirs;
    while ( $xine_lib_str =~ m/(-[Ll]\S+)/g ) {
      push(@lib_dirs, $1);
    }
    $xine_lib = join(' ', @lib_dirs);
    
    $xine_include = qx/$xc --cflags/;
}
else {
    warn "Unable to find 'xine_config'. Please make sure that you have installed the development packages for xine-lib and that 'xine_config' is in your PATH.\n";
    exit(0);
}

# Hard to imagine xine-config installed and functioning and libxine
# not, but we'll leave this check in to make doubly sure.

use lib qw(inc);
use Devel::CheckLib;

check_lib_or_exit(LIBS => $xine_lib . " -lxine");

WriteMakefile(
	      NAME              => 'Video::Xine',
	      VERSION_FROM      => 'lib/Video/Xine.pm',
	      PREREQ_PM         => {},
	      ABSTRACT_FROM     => 'lib/Video/Xine.pm',
	      AUTHOR            => 'Stephen Nelson <stephenenelson@mac.com>',
	      LIBS              => [$xine_lib],
	      DEFINE            => '',
	      INC               => '-I. ' . $xine_include,
	     );

sub find_xine_config {
    for my $path_dir ( File::Spec->path() ) {
	my $bin = File::Spec->catfile($path_dir, 'xine-config');
	-x $bin and return $bin;
    }
    return;
}
