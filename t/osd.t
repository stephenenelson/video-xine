
use strict;
use warnings;

use FindBin '$Bin';

use Test::More tests => 8;

use Video::Xine;
use Video::Xine::OSD qw/:cap_constants/;

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

my $caps = $osd->get_capabilities();
( $caps & XINE_OSD_CAP_FREETYPE2 ) and diag("Has freetype2");
( $caps & XINE_OSD_CAP_FREETYPE2 ) and diag("Can do unscaled OSD");

ok(1);

$stream->open("$Bin/time_015.avi")
  or die "Couldn't open '$Bin/time_015.avi'";

$stream->play();


# Skip rest of tests if we can't set the font
SKIP: {
    $osd->set_font('serif', 66)
      or skip(5, "Unable to set font");
    ok(1, "Set font");
    $osd->draw_text(x => 5, y => 10, text => "Hello there!", color_base => 0);
    ok(1, "draw text");
    sleep(1);
    $osd->show(0);
    ok(1, "show");
    sleep(2);
    $osd->hide(0);
    ok(1, "hide");
    sleep(2);

    $osd->clear();
    ok(1, "clear");
    $osd->draw_text(x => 0, y => 0, text => q{How's it going?}, color_base => 0);
    ok(1, "draw_text 2");
    $osd->show();
    sleep(2);
}
