use strict;
use warnings;

use FindBin '$Bin';
use Test::More tests => 1;

use Video::Xine;
use Video::Xine::Driver::Video ':constants';
if ($@) { skip_all(); }

my $xine = Video::Xine->new(config_file => "$Bin/test_config");


SKIP: {
  eval { require X11::FullScreen; };

  skip("X11::FullScreen module required for X11 tests", 1) if $@;

  if (! $ENV{'VIDEO_XINE_SHOW'}) {
    skip("Skipping X11 tests. Set VIDEO_XINE_SHOW to enable.", 1);
  }

  my $display_str = defined $ENV{'DISPLAY'} ? $ENV{'DISPLAY'} : ':0.0';

  my $display = X11::FullScreen::Display->new($display_str)
    or skip("X11::FullScreen::Display does not initialize", 1);

  my $window = $display->createWindow();
  $display->sync();
  my $x11_visual = Video::Xine::Util::make_x11_visual($display,
						      $display->getDefaultScreen(),
						      $window,
						      $display->getWidth(),
						      $display->getHeight(),
						      $display->getPixelAspect()
						     );
  my $driver = Video::Xine::Driver::Video->new($xine,"auto", XINE_VISUAL_TYPE_X11, $x11_visual)
    or skip("Couldn't load video driver", 1);
  my $audio_driver = Video::Xine::Driver::Audio->new($xine, 'none')
    or skip "Unable to load audio driver", 1;
  my $stream = $xine->stream_new($audio_driver, $driver);
  
  $stream->open("$Bin/time_015.avi")
    or die "Couldn't open '$Bin/time_015.avi'";
  $stream->play( 0 , 10000);
  sleep(5);

  ok(1);
}
