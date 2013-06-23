package Video::Xine;

use 5.008003;
use strict;
use warnings;

use Exporter;
use Carp;

use Video::Xine::Stream;
use Video::Xine::Driver::Audio;
use Video::Xine::Driver::Video;
use Video::Xine::Event;
use Video::Xine::Event::Queue;
use Video::Xine::OSD;

our $VERSION = '0.18';

our @ISA = qw(Exporter);
our @EXPORT = qw(
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
  XINE_VERBOSITY_DEBUG              => 2,

};

sub get_version {
    my $type = shift;

    my ($major, $minor, $sub);
    xine_get_version($major, $minor, $sub);
    return "$major.$minor.$sub";
}

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

1;
__END__

=head1 NAME

Video::Xine - Perl interface to libxine

=head1 SYNOPSIS

  use Video::Xine;
  use Video::Xine::Stream;
  use Video::Xine::Driver::Audio;
  use Video::Xine::Driver::Video qw/:constants/;

  # Create and initialize the Xine object
  my $xine = Video::Xine->new(
    config_file => "$ENV{'HOME'}/.xine/config",
  );

  # Load a video driver
  my $video_driver = Video::Xine::Driver::Video->new($xine,"auto", XINE_VISUAL_TYPE_X11, $x11_visual);

  # Load an audio driver
  my $audio_driver = Video::Xine::Driver::Audio->new($xine, "auto");

  # Create a new stream
  my $stream = $xine->stream_new($AUDIO_DRIVER,$VIDEO_DRIVER);

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

Video::Xine by itself does not provide a user interface or windowing system,
and neither does this interface. Instead, you must set up the window
using your own windowing code, and pass the window information to
Video::Xine. The "X11::FullScreen" module provides a simple interface for
doing this with X.


=head2 METHODS

=head3 new()

Constructor. Takes named argument 'config_file'.

Example:

  my $xine = Video::Xine->new( config_file => "$ENV{'HOME'}/xine/config" )

=head3 get_version()

Returns the version of the xine library to which we're linked. Static
method.

Example:

 my $version = Video::Xine->get_version(); # returns something like '1.1.8'

=head3 set_param()

  set_param($param, $value);

Sets an engine parameter.

Xine engine parameter constants:

=over

=item *

XINE_ENGINE_PARAM_VERBOSITY

Possible values are XINE_VERBOSITY_NONE, XINE_VERBOSITY_LOG,
and XINE_VERBOSITY_DEBUG, which are exported by default.

=back

=head3 stream_new()

  stream_new($audio_port, $video_port)

Creates a new stream. The C<$audio_port> and C<$video_port> options
are optional and default to automatically-selected drivers. A
convenience method around Xine::Stream::new.

See Video::Xine::Stream for stream methods.

=head3 get_error()

Returns the error code for the last error. Xine error codes are:

=over

=item *

XINE_ERROR_NONE

=item *

XINE_ERROR_NO_INPUT_PLUGIN

=item *

XINE_ERROR_NO_DEMUX_PLUGIN

=item *

XINE_ERROR_DEMUX_FAILED

=item *

XINE_ERROR_MALFORMED_URL

=item *

XINE_ERROR_INPUT_FAILED

=back

=head1 SEE ALSO

Xine (

=head1 AUTHOR

Stephen Nelson <stephenenelson@mac.com>

=head1 SPECIAL THANKS TO

Joern Reder

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005-2008 by Stephen Nelson

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.6 or,
at your option, any later version of Perl 5 you may have available.


=cut
