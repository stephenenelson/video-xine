package Video::Xine::Utility;

# Utility functions for Xine. Really just here for documentation.

require XSLoader;
XSLoader::load('Video::Xine');

1;

__END__

=head1 NAME

Video::Xine::Utility -- Utility methods for Xine

=head1 SYNOPSIS

  use Video::Xine::Utility;

  my $visual = Video::Xine::Utility::make_x11_visual
                (
                  $x_display,
                  $screen,
                  $window_id,
                  $width,
                  $height,
                  $aspect
                );


=head1 DESCRIPTION

The Utility package actually provides only one subroutine,
make_x11_visual().

=head1 SUBROUTINES

=head3 make_x11_visual()

 make_x11_visual($x_display, $screen, $window_id, $width, $height, $aspect)

Returns a C struct suitable for passing to the
Video::Xine::Driver::Video constructor with a XINE_VISUAL_TYPE_X11.



=cut

