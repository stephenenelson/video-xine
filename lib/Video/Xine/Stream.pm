package Video::Xine::Stream;

use Video::Xine;

use base 'Exporter';

our @EXPORT_OK = qw/
  XINE_STATUS_IDLE
  XINE_STATUS_STOP
  XINE_STATUS_PLAY
  XINE_STATUS_QUIT

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

  /;

our %EXPORT_TAGS = (
    status_constants => [
        qw/
          XINE_STATUS_IDLE
          XINE_STATUS_STOP
          XINE_STATUS_PLAY
          XINE_STATUS_QUIT
          /
    ],
    param_constants => [
        qw/
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
          /
    ],
    speed_constants => [
        qw/
          XINE_SPEED_PAUSE
          XINE_SPEED_SLOW_4
          XINE_SPEED_SLOW_2
          XINE_SPEED_NORMAL
          XINE_SPEED_FAST_2
          XINE_SPEED_FAST_4
          /
    ]
);

use constant {
    XINE_STATUS_IDLE => 0,
    XINE_STATUS_STOP => 1,
    XINE_STATUS_PLAY => 2,
    XINE_STATUS_QUIT => 3,
};

use constant {
    XINE_PARAM_SPEED                 => 1,
    XINE_PARAM_AV_OFFSET             => 2,
    XINE_PARAM_AUDIO_CHANNEL_LOGICAL => 3,
    XINE_PARAM_SPU_CHANNEL           => 4,
    XINE_PARAM_VIDEO_CHANNEL         => 5,
    XINE_PARAM_AUDIO_VOLUME          => 6,
    XINE_PARAM_AUDIO_MUTE            => 7,
    XINE_PARAM_AUDIO_COMPR_LEVEL     => 8,
    XINE_PARAM_AUDIO_AMP_LEVEL       => 9,
    XINE_PARAM_AUDIO_REPORT_LEVEL    => 10,
    XINE_PARAM_VERBOSITY             => 11,
    XINE_PARAM_SPU_OFFSET            => 12,
    XINE_PARAM_IGNORE_VIDEO          => 13,
    XINE_PARAM_IGNORE_AUDIO          => 14,
    XINE_PARAM_IGNORE_SPU            => 15,
    XINE_PARAM_BROADCASTER_PORT      => 16,
    XINE_PARAM_METRONOM_PREBUFFER    => 17,
    XINE_PARAM_EQ_30HZ               => 18,
    XINE_PARAM_EQ_60HZ               => 19,
    XINE_PARAM_EQ_125HZ              => 20,
    XINE_PARAM_EQ_250HZ              => 21,
    XINE_PARAM_EQ_500HZ              => 22,
    XINE_PARAM_EQ_1000HZ             => 23,
    XINE_PARAM_EQ_2000HZ             => 24,
    XINE_PARAM_EQ_4000HZ             => 25,
    XINE_PARAM_EQ_8000HZ             => 26,
    XINE_PARAM_EQ_16000HZ            => 27,
    XINE_PARAM_AUDIO_CLOSE_DEVICE    => 28,
    XINE_PARAM_AUDIO_AMP_MUTE        => 29,
    XINE_PARAM_FINE_SPEED            => 30
};

use constant {
    XINE_SPEED_PAUSE  => 0,
    XINE_SPEED_SLOW_4 => 1,
    XINE_SPEED_SLOW_2 => 2,
    XINE_SPEED_NORMAL => 4,
    XINE_SPEED_FAST_2 => 8,
    XINE_SPEED_FAST_4 => 16,
};

require XSLoader;
XSLoader::load('Video::Xine');

sub new {
    my $type = shift;
    my ( $xine, $audio_port, $video_port ) = @_;

    my $self = {};
    $self->{'xine'}       = $xine;
    $self->{'audio_port'} = $audio_port;
    $self->{'video_port'} = $video_port;
    $self->{'stream'} =
      xine_stream_new( $xine, $audio_port->{'driver'},
        $video_port->{'driver'} );

    bless $self, $type;

    return $self;

}

sub get_video_port {
    $_[0]->{'video_port'};
}

sub get_audio_port {
    my $self = shift;
    return $self->{'audio_port'};
}

sub open {
    my $self = shift;
    my ($mrl) = @_;

    xine_open( $self->{'stream'}, $mrl )
      or return;

}

sub play {
    my $self = shift;
    my ( $start_pos, $start_time ) = @_;

    defined $start_pos
      or $start_pos = 0;

    defined $start_time
      or $start_time = 0;

    xine_play( $self->{'stream'}, $start_pos, $start_time )
      or return;
}

##
## Stops the stream.
##
sub stop {
    my $self = shift;

    xine_stop( $self->{'stream'} );
}

##
## Close the stream. Stream is available for reuse.
##
sub close {
    my $self = shift;

    xine_close( $self->{'stream'} );
}

sub get_pos_length {
    my $self = shift;
    my ( $pos_stream, $pos_time, $length_time ) = ( 0, 0, 0 );

    xine_get_pos_length( $self->{'stream'}, $pos_stream, $pos_time,
        $length_time )
      or return;

    return ( $pos_stream, $pos_time, $length_time );
}

sub get_status {
    my $self = shift;
    return xine_get_status( $self->{'stream'} );
}

sub get_error {
    my $self = shift;
    return xine_get_error( $self->{'stream'} );
}

sub set_param {
    my $self = shift;
    my ( $param, $value ) = @_;
    return xine_set_param( $self->{'stream'}, $param, $value );
}

sub get_param {
    my $self = shift;
    my ($param) = @_;
    return xine_get_param( $self->{'stream'}, $param );
}

sub osd_new {
    my $self = shift;
    my (%in) = @_;

    return Video::Xine::OSD->new( $self, %in );
}

sub DESTROY {
    my $self = shift;
    xine_dispose( $self->{'stream'} );
}

1;

__END__

=head1 NAME

Video::Xine::Stream - Audio-video stream for Xine

=head1 METHODS

These are methods which can be used on the Video::Xine::Stream class
and object.

=head3 new()

  new($xine, $audio_port, $video_port)

Creates a new Stream object. The C<$audio_port> and C<$video_port> options
are optional and default to automatically-selected drivers.

=head3 get_video_port()

 Returns the video port, also known as the video driver.

=head3 open()

 $stream->open($mrl)

Opens the stream to an MRL, which is a URL-like construction used by
Xine to locate media files. See the xine documentation for details.

=head3 play()

 $stream->play($start_pos, $start_time)

Starts playing the stream at a specific position or specific time. Both C<$start_pos> and C<$start_time> are optional and default to 0.

=head3 stop()

 $stream->stop()

Stops the stream.

=head3 close()

 $stream->close()

Close the stream. You can re-use the same stream again and again.

=head3 get_pos_length()

  ($pos_pct, $pos_time, $length_time) = $s->get_pos_length();

Gets position / length information. C<$pos_pct> is a value between 1
and 65535 indicating how far we've proceeded through the
stream. C<$pos_time> gives how far we've proceeded through the stream
in milliseconds, and C<$length_time> gives the total length of the
stream in milliseconds.

=head3 get_status()

Returns the play status of the stream. It will return one of the
following constants, which are exported in the tag
':status_constants':

=head4 STREAM CONSTANTS

=over 4

=item *

XINE_STATUS_IDLE

The stream is idle.

=item *

XINE_STATUS_STOP

Indicates that the stream is stopped.

=item *

XINE_STATUS_PLAY

Indicates that the stream is playing.

=item *

XINE_STATUS_QUIT

=back


=head3 set_param()

  $s->set_param($param, $value)

Sets a parameter on the stream. C<$param> should be a xine parameter
constant. See xine.h for details.

=head3 get_param()

  $s->get_param($param)

Returns a parameter from the stream. C<$param> should be a xine
parameter constant.

=cut
