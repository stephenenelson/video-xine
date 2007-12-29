use 5.008003;
use ExtUtils::MakeMaker;
use File::Spec;

my ($xine_include, $xine_lib, @lib_dirs);
if ( my $xc = find_xine_config() ) {
    $xine_lib = qx/$xc --libs/;
    while ( $xine_lib =~ m/\b-L(\w+)/g ) {
      push(@lib_dirs, $1);
    }
    $xine_include = qx/$xc --cflags/;
}
else {
    warn "Unable to find 'xine_config'. Please make sure that you have installed the development packages for xine-lib and that 'xine_config' is in your PATH.\n";
    exit(0);
}

use lib qw(inc);
use Devel::CheckLib;

check_lib_or_exit(
    lib => [qw(xine)],
    libdirs => \@lib_dirs
);

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
