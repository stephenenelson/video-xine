package Video::Xine::Util;

use Exporter 'import';
our @EXPORT_OK = qw/make_x11_visual make_x11_fs_visual/;

use Video::Xine;

sub make_x11_fs_visual {
	my ($display, $window) = @_;
	
	return Video::Xine::Util::make_x11_visual(
		$display,
        $display->getDefaultScreen(),
        $window, $display->getWidth(), $display->getHeight(),
        $display->getPixelAspect()	
	);
}

1;

__END__

=head1 NAME

Video::Xine::Util -- Utility methods for Xine

=head1 SYNOPSIS

  use Video::Xine::Util qw/make_x11_visual make_x11_fs_visual/;

  my $visual = make_x11_visual
                (
                  $x_display,
                  $screen,
                  $window_id,
                  $width,
                  $height,
                  $aspect
                );

  # Get a visual from X11::FullScreen
  my $display = X11::FullScreen::Display->new(':0.0');
  
  my $fs_visual = make_x11_fs_visual($display, $display->createWindow());


=head1 DESCRIPTION

The Util package provides helper subroutines for gluing Video::Xine to windowing systems.

=head1 SUBROUTINES

=head3 make_x11_visual()

 make_x11_visual($x_display, $screen, $window_id, $width, $height, $aspect)

Returns a C struct suitable for passing to the
Video::Xine::Driver::Video constructor with a XINE_VISUAL_TYPE_X11.



=cut

