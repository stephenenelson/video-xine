use 5.008003;
use ExtUtils::MakeMaker;
use File::Spec;

my ($xine_include, $xine_lib);
if ( my $xc = find_xine_config() ) {
    $xine_lib = qx/$xc --libs/;
    $xine_lib =~ s/-[^Ll]\w+\b//g; # Eliminate nonlibrary arguments
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
    LIBS => $xine_lib
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
