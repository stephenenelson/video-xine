package Video::Xine;

use 5.008003;
use strict;
use warnings;

use Exporter;
use Carp;

our $VERSION = '0.04';
our @ISA = qw(Exporter);
our @EXPORT = qw(
  XINE_STATUS_IDLE
  XINE_STATUS_STOP
  XINE_STATUS_PLAY

  XINE_PARAM_SPEED                
  XINE_PARAM_AV_OFFSET            
  XINE_PARAM_AUDIO_CHANNEL_LOGICAL
  XINE_PARAM_SPU_CHANNEL          
  XINE_PARAM_VIDEO_CHANNEL        
  XINE_PARAM_AUDIO_VOLUME         
  XINE_PARAM_AUDIO_MUTE           
  XINE_PARAM_AUDIO_COMPR_LEVEL    
  XINE_PARAM_AUDIO_AMP_LEVEL      
  XINE_PARAM_AUDIO_REPORT_LEVEL   
  XINE_PARAM_VERBOSITY            
  XINE_PARAM_SPU_OFFSET           
  XINE_PARAM_IGNORE_VIDEO         
  XINE_PARAM_IGNORE_AUDIO         
  XINE_PARAM_IGNORE_SPU           
  XINE_PARAM_BROADCASTER_PORT     
  XINE_PARAM_METRONOM_PREBUFFER   
  XINE_PARAM_EQ_30HZ              
  XINE_PARAM_EQ_60HZ              
  XINE_PARAM_EQ_125HZ             
  XINE_PARAM_EQ_250HZ             
  XINE_PARAM_EQ_500HZ             
  XINE_PARAM_EQ_1000HZ            
  XINE_PARAM_EQ_2000HZ            
  XINE_PARAM_EQ_4000HZ            
  XINE_PARAM_EQ_8000HZ            
  XINE_PARAM_EQ_16000HZ           
  XINE_PARAM_AUDIO_CLOSE_DEVICE   
  XINE_PARAM_AUDIO_AMP_MUTE       
  XINE_PARAM_FINE_SPEED           

  XINE_SPEED_PAUSE 
  XINE_SPEED_SLOW_4
  XINE_SPEED_SLOW_2
  XINE_SPEED_NORMAL
  XINE_SPEED_FAST_2
  XINE_SPEED_FAST_4

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
  
  XINE_ERROR_NONE
  XINE_ERROR_NO_INPUT_PLUGIN
  XINE_ERROR_NO_DEMUX_PLUGIN
  XINE_ERROR_DEMUX_FAILED
  XINE_ERROR_MALFORMED_MRL
  XINE_ERROR_INPUT_FAILED

  XINE_GUI_SEND_DRAWABLE_CHANGED
  XINE_GUI_SEND_EXPOSE_EVENT
  XINE_GUI_SEND_VIDEOWIN_VISIBLE
  
  XINE_ENGINE_PARAM_VERBOSITY
  
  XINE_VERBOSITY_NONE
  XINE_VERBOSITY_LOG
  XINE_VERBOSITY_DEBUG  
);

require XSLoader;
XSLoader::load('Video::Xine', $VERSION);

# Preloaded methods go here.

use constant {
  XINE_STATUS_IDLE                  =>  0,
  XINE_STATUS_STOP                  =>  1,
  XINE_STATUS_PLAY                  =>  2,

  XINE_PARAM_SPEED                  =>  1,
  XINE_PARAM_AV_OFFSET              =>  2,
  XINE_PARAM_AUDIO_CHANNEL_LOGICAL  =>  3,
  XINE_PARAM_SPU_CHANNEL            =>  4,
  XINE_PARAM_VIDEO_CHANNEL          =>  5,
  XINE_PARAM_AUDIO_VOLUME           =>  6,
  XINE_PARAM_AUDIO_MUTE             =>  7,
  XINE_PARAM_AUDIO_COMPR_LEVEL      =>  8,
  XINE_PARAM_AUDIO_AMP_LEVEL        =>  9,
  XINE_PARAM_AUDIO_REPORT_LEVEL     => 10,
  XINE_PARAM_VERBOSITY              => 11,
  XINE_PARAM_SPU_OFFSET             => 12,
  XINE_PARAM_IGNORE_VIDEO           => 13,
  XINE_PARAM_IGNORE_AUDIO           => 14,
  XINE_PARAM_IGNORE_SPU             => 15,
  XINE_PARAM_BROADCASTER_PORT       => 16,
  XINE_PARAM_METRONOM_PREBUFFER     => 17,
  XINE_PARAM_EQ_30HZ                => 18,
  XINE_PARAM_EQ_60HZ                => 19,
  XINE_PARAM_EQ_125HZ               => 20,
  XINE_PARAM_EQ_250HZ               => 21,
  XINE_PARAM_EQ_500HZ               => 22,
  XINE_PARAM_EQ_1000HZ              => 23,
  XINE_PARAM_EQ_2000HZ              => 24,
  XINE_PARAM_EQ_4000HZ              => 25,
  XINE_PARAM_EQ_8000HZ              => 26,
  XINE_PARAM_EQ_16000HZ             => 27,
  XINE_PARAM_AUDIO_CLOSE_DEVICE     => 28,
  XINE_PARAM_AUDIO_AMP_MUTE         => 29,
  XINE_PARAM_FINE_SPEED             => 30,

  XINE_SPEED_PAUSE                  =>  0,
  XINE_SPEED_SLOW_4                 =>  1,
  XINE_SPEED_SLOW_2                 =>  2,
  XINE_SPEED_NORMAL                 =>  4,
  XINE_SPEED_FAST_2                 =>  8,
  XINE_SPEED_FAST_4                 => 16,

  XINE_EVENT_UI_PLAYBACK_FINISHED   =>  1,
  XINE_EVENT_UI_CHANNELS_CHANGED    =>  2,
  XINE_EVENT_UI_SET_TITLE           =>  3,
  XINE_EVENT_UI_MESSAGE             =>  4,
  XINE_EVENT_FRAME_FORMAT_CHANGE    =>  5,
  XINE_EVENT_AUDIO_LEVEL            =>  6,
  XINE_EVENT_QUIT                   =>  7,
  XINE_EVENT_PROGRESS               =>  8,
  XINE_EVENT_MRL_REFERENCE          =>  9,
  XINE_EVENT_UI_NUM_BUTTONS         => 10,
  XINE_EVENT_SPU_BUTTON             => 11,
  XINE_EVENT_DROPPED_FRAMES         => 12,
  
  XINE_ERROR_NONE                   =>  0,
  XINE_ERROR_NO_INPUT_PLUGIN        =>  1,
  XINE_ERROR_NO_DEMUX_PLUGIN        =>  2,
  XINE_ERROR_DEMUX_FAILED           =>  3,
  XINE_ERROR_MALFORMED_MRL          =>  4,
  XINE_ERROR_INPUT_FAILED           =>  5,


  XINE_GUI_SEND_DRAWABLE_CHANGED    =>  2,
  XINE_GUI_SEND_EXPOSE_EVENT        =>  3,
  XINE_GUI_SEND_VIDEOWIN_VISIBLE    =>  5,
  
  XINE_ENGINE_PARAM_VERBOSITY       =>  1,
  
  XINE_VERBOSITY_NONE               => 0,
  XINE_VERBOSITY_LOG                => 1,
  XINE_VERBOSITY_DEBUG              => 2
  
};

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

sub get_video_port {
  $_[0]->{'video_port'};
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

sub get_error {
	my $self = shift;
	return xine_get_error($self->{'stream'});
}

sub set_param {
  my $self = shift;
  my ($param, $value) = @_;
  return xine_set_param($self->{'stream'}, $param, $value);
}

sub get_param {
  my $self = shift;
  my ($param) = @_;
  return xine_get_param($self->{'stream'}, $param);
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

  $id ||= "auto";

  UNIVERSAL::isa($xine, 'Video::Xine')
      or croak "First argument must be of type Video::Xine (was $xine)";

  my $self = {};
  $self->{'xine'} = $xine;
  if (scalar @_ > 1) {
    $self->{'driver'} = xine_open_video_driver($self->{'xine'}{'xine'},
					       $id,
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

sub send_gui_data {
  my $self = shift;
  my ($type, $data) = @_;

  xine_port_send_gui_data($self->{'driver'}, $type, $data);
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

  # Create and initialize the Xine object
  my $xine = Video::Xine->new(
    config_file => "$ENV{'HOME'}/.xine/config",
  );

  # Load a video driver
  my $video_driver = Video::Xine::Driver::Video->new($xine,"auto",1,$x11_visual);

  # Create a new stream (put your video driver under $DRIVER)
  my $stream = $xine->stream_new(undef,$DRIVER);

  # Open a file on the stream
  $stream->open('file://my/movie/file.avi')
    or die "Couldn't open stream: ", $stream->get_error();

  # Get the current position (0 .. 65535), position in time, and length
  # of stream in milliseconds
  my ($pos, $pos_time, $length_time) = $stream->get_pos_length();

  # Start the stream playing
  $stream->play()
     or die "Couldn't play stream: ", $xine->get_error();

  # Play the stream to the end
  while ( $xine->get_status() == XINE_STATUS_PLAY ) {
    sleep(1);
  }


=head1 DESCRIPTION

A perl interface to Xine, the Linux movie player. More properly, an
interface to libxine, the development library. Requires installation of
libxine.

Xine by itself does not provide a user interface, and neither does
this interface. Instead, you must set up the window using your own
windowing code, and pass the window information to Xine.


=head2 EXPORT

=head3 STATUS CONSTANTS

The Status constants are the results for a get_status() call. See
xine.h for details.

=over 4

=item *

XINE_STATUS_STOP

Indicates that the stream is stopped.

=item *

XINE_STATUS_PLAY

Indicates that the stream is playing.




=head1 SEE ALSO

L<xine(1)>

=head1 AUTHOR

Stephen Nelson, E<lt>stephen@cpan.orgE<gt>

=head1 SPECIAL THANKS TO

Joern Reder for patches and GTK integration.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005, 2006 by Stephen Nelson

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.6 or,
at your option, any later version of Perl 5 you may have available.


=cut
