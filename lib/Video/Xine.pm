package Video::Xine;

use 5.008005;
use strict;
use warnings;

use Exporter;
use Carp;

our $VERSION = '0.01';
our @ISA = qw(Exporter);
our @EXPORT = qw(
  XINE_STATUS_STOP
  XINE_STATUS_PLAY

  XINE_EVENT_UI_PLAYBACK_FINISHED
  XINE_EVENT_UI_CHANNELS_CHANGED
  XINE_EVENT_UI_SET_TITLE
  XINE_EVENT_UI_MESSAGE
  XINE_EVENT_FRAME_FORMAT_CHANGE
  XINE_EVENT_AUDIO_LEVEL
  XINE_EVENT_QUIT
  XINE_EVENT_PROGRESS
  XINE_EVENT_MRL_REFERENCE
  XINE_EVENT_UI_NUM_BUTTONS
  XINE_EVENT_SPU_BUTTON
  XINE_EVENT_DROPPED_FRAMES
);

require XSLoader;
XSLoader::load('Video::Xine', $VERSION);

# Preloaded methods go here.

use constant XINE_STATUS_STOP => 1;
use constant XINE_STATUS_PLAY => 2;

use constant XINE_EVENT_UI_PLAYBACK_FINISHED => 1;
use constant XINE_EVENT_UI_CHANNELS_CHANGED => 2;
use constant XINE_EVENT_UI_SET_TITLE => 3;
use constant XINE_EVENT_UI_MESSAGE => 4;
use constant XINE_EVENT_FRAME_FORMAT_CHANGE => 5;
use constant XINE_EVENT_AUDIO_LEVEL => 6;
use constant XINE_EVENT_QUIT => 7;
use constant XINE_EVENT_PROGRESS => 8;
use constant XINE_EVENT_MRL_REFERENCE => 9;
use constant XINE_EVENT_UI_NUM_BUTTONS => 10;
use constant XINE_EVENT_SPU_BUTTON => 11;
use constant XINE_EVENT_DROPPED_FRAMES => 12;

sub new {
  my $type = shift;
  my (%in) = @_;
  my $self = {};

  $self->{'xine'} = xine_new()
    or return;

  if ($in{'config_file'}) {
    -e $in{'config_file'}
      or croak "Config file '$in{'config_file'}' not found; stopped";
    -r $in{'config_file'}
      or croak "Config file '$in{'config_file'}' not readable; stopped";
    xine_config_load($self->{'xine'}, $in{'config_file'});
  }

  xine_init($self->{'xine'});

  bless $self, $type;
}

sub set_param {
  my $self = shift;
  my ($param, $value) = @_;

  xine_engine_set_param($self->{'xine'}, $param, $value);
  
}



sub DESTROY {
  my $self = shift;
  xine_exit($self->{'xine'});
}

sub stream_new {
  my $self = shift;
  my ($audio_port, $video_port) = @_;

  defined $audio_port
    or $audio_port = Video::Xine::Driver::Audio->new($self);

  defined $video_port
    or $video_port = Video::Xine::Driver::Video->new($self);

  return Video::Xine::Stream->new($self->{'xine'}, $audio_port, $video_port);
}

package Video::Xine::Stream;

sub new {
  my $type = shift;
  my ($xine, $audio_port, $video_port) = @_;

  my $self = {};
  $self->{'xine'} = $xine;
  $self->{'audio_port'} = $audio_port;
  $self->{'video_port'} = $video_port;
  $self->{'stream'} = xine_stream_new($xine,
				      $audio_port->{driver},
				      $video_port->{driver});

  bless $self, $type;

  return $self;


}

sub open {
  my $self = shift;
  my ($mrl) = @_;

  xine_open($self->{'stream'}, $mrl)
    or return;

}

sub play {
  my $self = shift;
  my ($start_pos, $start_time) = @_;

  defined $start_pos
    or $start_pos = 0;

  defined $start_time
    or $start_time = 0;

  xine_play($self->{'stream'}, $start_pos, $start_time)
    or return;
}

##
## Stops the stream.
##
sub stop {
  my $self = shift;

  xine_stop($self->{'stream'});
}

##
## Close the stream. Stream is available for reuse.
##
sub close {
  my $self = shift;

  xine_close($self->{'stream'});
}

sub get_pos_length {
  my $self = shift;
  my ($pos_stream, $pos_time, $length_time) = (0,0,0);

  xine_get_pos_length($self->{'stream'}, $pos_stream, $pos_time, $length_time)
    or return;

  return ($pos_stream, $pos_time, $length_time);


}

sub get_status {
  my $self = shift;
  return xine_get_status($self->{'stream'});
}

sub DESTROY {
  my $self = shift;
  xine_dispose($self->{'stream'});
}

package Video::Xine::Driver::Audio;

sub new {
  my $type = shift;
  my ($xine) = @_;
  my $self = {};
  $self->{'xine'} = $xine;
  $self->{'driver'} = xine_open_audio_driver($xine->{'xine'})
    or return;
  bless $self, $type;
}

sub DESTROY {
  my $self = shift;
  xine_close_audio_driver($self->{'xine'}{'xine'}, $self->{'driver'});
}

package Video::Xine::Driver::Video;

use Carp;

sub new {
  my $type = shift;
  my ($xine, $id, $visual, $data) = @_;

  UNIVERSAL::isa($xine, 'Video::Xine')
      or croak "First argument must be of type Video::Xine (was $xine)";

  my $self = {};
  $self->{'xine'} = $xine;
  if (scalar @_ > 1) {
    $self->{'driver'} = xine_open_video_driver($self->{'xine'}{'xine'},
					       "auto",
					       $visual,
					       $data
					      )
      or return;
  }
  else {
    # Open a null driver
    $self->{'driver'} = xine_open_video_driver($self->{'xine'}{'xine'})
      or return;
  }
  bless $self, $type;
}

sub DESTROY {
  my $self = shift;
  xine_close_video_driver($self->{'xine'}{'xine'}, $self->{'driver'});
}

package Video::Xine::Event;

sub get_type {
  xine_event_get_type($_[0]);
}

sub DESTROY {
  xine_event_free($_[0]);
}

package Video::Xine::Event::Queue;

sub new {
  my $type = shift;
  my ($stream) = @_;

  my $self = {};
  $self->{'stream'} = $stream;
  $self->{'queue'} = xine_event_new_queue($stream->{'stream'});
  bless $self, $type;
}

sub get_event {
  my $self = shift;
  my $event = xine_event_get($self->{'queue'})
    or return;
  bless $event, 'Video::Xine::Event';
}

1;
__END__

=head1 NAME

Video::Xine - Perl interface to libxine

=head1 SYNOPSIS

  use Video::Xine;

  # Create and initialize the Xine driver
  my $xine = $xine->new(
    config_file => "$ENV{'HOME'}/.xine/config",
    video_driver => Video::Xine->VIDEO_DRIVER_NULL()
  );

  # Play a particular AVI until it's over
  my $stream = $xine->stream_new();
  $stream->open('file://my/movie/file.avi')
    or die "Couldn't open stream: ", $stream->get_error();

  # Get the current position (0 .. 65535), position in time, and length
  # of stream in milliseconds
  my ($pos, $pos_time, $length_time) = $stream->get_pos_length();


  $stream->play()
     or die "Couldn't play stream: ", $xine->get_error();

  while ( $xine->get_status() == XINE_STATUS_PLAY ) {
    sleep(1);
  }


=head1 DESCRIPTION

A perl interface to Xine, the Linux movie player. More properly, an
interface to libxine, the development library.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Stephen Nelson, E<lt>steven@localdomainE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 by Stephen Nelson

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.5 or,
at your option, any later version of Perl 5 you may have available.


=cut
