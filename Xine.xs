#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <xine.h>

MODULE = Video::Xine		PACKAGE = Video::Xine


#
# Pre-init the xine engine. Need to call xine_init()
# afterwards.
#
xine_t *
xine_new()
    CODE:
	{
	  RETVAL = xine_new();
          if (RETVAL == NULL) {
             XSRETURN_UNDEF;
          }
        }
    OUTPUT:
	RETVAL


#
# Post-init the xine engine. Call after xine_new() and configuration.
# 
void
xine_init(self)
	xine_t *self

#
# Shut down and clean up xine.
#
void
xine_exit(self)
	xine_t *self


#
# Load a file into the config system
#
void
xine_config_load(self, cfg_filename)
	xine_t *self
	const char *cfg_filename


MODULE = Video::Xine		PACKAGE = Video::Xine::Stream

#
# Create a new Xine stream.
#
xine_stream_t *
xine_stream_new(xine,ao,vo)
	xine_t *xine
	xine_audio_port_t *ao
	xine_video_port_t *vo
    CODE:
	RETVAL = xine_stream_new(xine,ao,vo);
        if (RETVAL == NULL) {
           XSRETURN_UNDEF;
        }
    OUTPUT:
        RETVAL

##
## Opens a xine mrl on an existing stream.
##
int
xine_open(stream,mrl)
	xine_stream_t *stream
	const char *mrl

##
## Play the stream
##
int
xine_play(stream,start_pos=0,start_time=0)
	xine_stream_t *stream
	int start_pos
	int start_time

##
## Stop playing
##
void
xine_stop(self)
	xine_stream_t *self

##
## Close MRL; stream can be reused
##
void
xine_close(self)
	xine_stream_t *self

#
# Get the stream position and length
#
int
xine_get_pos_length(self, pos_stream, pos_time, length_time)
	xine_stream_t* self
	int &pos_stream
	int &pos_time
	int &length_time
	OUTPUT:
		RETVAL
		pos_stream
		pos_time
		length_time


#
# Get the playback status
#
int
xine_get_status(self)
	xine_stream_t *self

# Destroy all monsters
void
xine_dispose(self)
	xine_stream_t *self

MODULE = Video::Xine		PACKAGE = Video::Xine::Driver::Audio

##
## Open an audio driver for this Xine player.
##
xine_audio_port_t *
xine_open_audio_driver(self,id=NULL,data=NULL)
	xine_t *self
	const char *id
	void *data
	
##
## Close an opened audio driver
##
void
xine_close_audio_driver(xine,driver)
	xine_t *xine
	xine_audio_port_t *driver

MODULE = Video::Xine        PACKAGE = Video::Xine::Driver::Video

##
## Open a video driver for this Xine player.
##
xine_video_port_t *
xine_open_video_driver(self,id=NULL,visual=XINE_VISUAL_TYPE_NONE,data=NULL)
	xine_t *self
	const char *id
	int visual
	void *data
	CODE:
		

##
## Close a video driver
##
void
xine_close_video_driver(xine,driver)
	xine_t *xine
	xine_video_port_t *driver


MODULE = Video::Xine        PACKAGE = Video::Xine::Driver::Video::X11Visual

x11_visual_t *
xine_x11_visual_new(display,screen,window,user_data=NULL)
	void *display
	int screen
	unsigned long window
	void *user_data
	CODE:
		RETVAL = (x11_visual_t*) safemalloc( sizeof( x11_visual_t ) );
		RETVAL->display = display;
		RETVAL->screen = screen;
		RETVAL->d = window;
		RETVAL->user_data = user_data;
		RETVAL->frame_output_cb = NULL;
		RETVAL->dest_size_cb = NULL;
	OUTPUT:
		RETVAL
