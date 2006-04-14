use strict;

use FindBin '$Bin';
use Test::More tests => 1;

use Video::Xine;



my $xine = Video::Xine->new(config_file => "$ENV{HOME}/.xine/config");


SKIP: {
  eval { require X11::FullScreen; };

  skip("X11::FullScreen module required for X11 tests", 1) if $@;

  my $display = X11::FullScreen::Display->new();
  my $window = $display->createWindow();
  $display->sync();
  my $x11_visual = Video::Xine::Util::make_x11_visual($display,
						      $display->getDefaultScreen(),
						      $window,
						      $display->getWidth(),
						      $display->getHeight(),
						      $display->getPixelAspect()
						     );
  my $driver = Video::Xine::Driver::Video->new($xine,"auto",1,$x11_visual);
  my $stream = $xine->stream_new(undef, $driver);
  
  $stream->open("$Bin/time_015.avi")
    or die "Couldn't open '$Bin/time_015.avi'";
  $stream->play( 0 , 10000);
  sleep(5);

  ok(1);
}
