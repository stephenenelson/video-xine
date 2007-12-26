use lib qw(inc);
use Devel::CheckLib;
use File::Spec;

check_lib_or_exit(
    lib => [qw(xine)]
);


use 5.008003;
use ExtUtils::MakeMaker;

my ($xine_include, $xine_lib);
if ( my $xc = find_xine_config ) {
    $xine_lib = qx/$xc --libs/;
    $xine_include = qx/$xc --cflags/;
}
else {
    warn "Unable to find 'xine_config'. Please make sure that you have installed the development packages for xine-lib and that 'xine_config' is in your PATH.\n";
    exit(0);
}

WriteMakefile(
    NAME              => 'Video::Xine',
    VERSION_FROM      => 'lib/Video/Xine.pm', # finds $VERSION
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Video/Xine.pm', # retrieve abstract from module
       AUTHOR         => 'Stephen Nelson <stephenenelson@mac.com>') : ()),
    LIBS              => [$xine_lib],
    DEFINE            => '',
    INC               => '-I. ' . $xine_include,
	# Un-comment this if you add C files to link with later:
    # OBJECT            => '$(O_FILES)', # link all the C files too
);

sub find_xine_config {
    for my $path_dir ( File::Spec->path() ) {
	my $bin = File::Spec->catfile($path_dir, 'xine-config');
	-x $bin and return $bin;
    }
    return;
}
