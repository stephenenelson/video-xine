
use strict;
use warnings;

use FindBin '$Bin';

use Test::More tests => 2;

use Video::Xine;

my $xine = Video::Xine->new();
$xine->set_param(XINE_ENGINE_PARAM_VERBOSITY, 2);
my $audio_port = Video::Xine::Driver::Audio->new($xine, 'none');

### Copied from Event.t
my ($driver, $display_str, $display, $window);

if (defined($ENV{'VIDEO_XINE_SHOW'}) && $ENV{'VIDEO_XINE_SHOW'}) {
    eval { require X11::FullScreen; };
    
    if ($@) {
	skip("Couldn't load X11::FullScreen: $@", 1);
    }
    
    my $display_str = defined $ENV{'DISPLAY'} ? $ENV{'DISPLAY'} : ':0.0';
    
    
    $display = X11::FullScreen::Display->new($display_str)
      or skip("X11::FullScreen::Display does not initialize", 1);
    
    $window = $display->createWindow();
    $display->sync();
    my $x11_visual = 
      Video::Xine::Util::make_x11_visual($display,
					 $display->getDefaultScreen(),
					 $window,
					 $display->getWidth(),
					 $display->getHeight(),
					 $display->getPixelAspect()
					);
    $driver = Video::Xine::Driver::Video->new($xine,"auto", 1, $x11_visual, $display)
      or skip("Unable to load video driver", 1);
}
else {
    $driver = Video::Xine::Driver::Video->new($xine, 'none')
      or skip("Unable to load 'none' video driver", 1);
}

my $stream = $xine->stream_new($audio_port, $driver);

my $osd = Video::Xine::OSD->new
  (
   stream => $stream,
   x => 0,
   y => 0,
   width => 500,
   height => 100
  );

ok(1);

$stream->open("$Bin/time_015.avi")
  or die "Couldn't open '$Bin/time_015.avi'";

$stream->play();
$osd->set_font('serif', 66);
$osd->draw_text(x => 5, y => 10, text => "Hello there!", color_base => 0);
sleep(1);
$osd->show(0);
sleep(2);
$osd->hide(0);
sleep(2);

ok(1);

$osd->clear();
$osd->draw_text(x => 0, y => 0, text => q{How's it going?}, color_base => 0);
$osd->show();
sleep(2);

