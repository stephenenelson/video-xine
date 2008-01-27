use strict;
use warnings;

use FindBin '$Bin';
use Test::More tests => 7;

use Video::Xine;
use Video::Xine::Stream qw/:status_constants :info_constants/;
use Video::Xine::Driver::Audio;
use Video::Xine::Driver::Video;

my $xine = Video::Xine->new()
  or die "Couldn't open Xine";

my $ao = Video::Xine::Driver::Audio->new($xine, 'none')
  or die "Couldn't open audio driver";

# Get our stream
my $stream = $xine->stream_new($ao);

$stream->open("$Bin/time_015.avi");

my $duration = $stream->get_duration();

is($duration->seconds(), 14);
is($duration->nanoseconds(), 981000);

is($stream->get_info(XINE_STREAM_INFO_BITRATE), 0);
is($stream->get_info(XINE_STREAM_INFO_FRAME_DURATION), 3003);
is($stream->get_info(XINE_STREAM_INFO_VIDEO_WIDTH), 704);
is($stream->get_info(XINE_STREAM_INFO_VIDEO_HEIGHT), 480);

$stream->close();

$stream->open("$Bin/test.ogg");

is($stream->get_meta_info(0), "Test of Perl Xine" );

$stream->close();
