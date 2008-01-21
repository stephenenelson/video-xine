package Video::Xine::OSD;

use Carp;

sub new {
    my ($type) = shift;
    my (%in) = @_;

    defined $in{'stream'} or croak "Argument 'stream' required!";

    my $self = {};
    $self->{'stream'} = $in{'stream'};
    $self->{'x'} = $in{'x'};
    $self->{'y'} = $in{'y'};
    $self->{'width'} = $in{'width'};
    $self->{'height'} = $in{'height'};

    $self->{'osd'} = xine_osd_new($self->{'stream'}{'stream'},
				  $self->{'x'},
				  $self->{'y'},
				  $self->{'width'},
				  $self->{'height'}
				 );

    bless $self, $type;
    return $self;
}

sub clear {
    my $self = shift;

    xine_osd_clear($self->{'osd'});
}

sub draw_text {
    my $self = shift;
    my (%in) = @_;

    xine_osd_draw_text($self->{'osd'}, $in{'x'}, $in{'y'}, $in{'text'}, $in{'color_base'})
}

sub set_font {
    my $self = shift;
    my ($fontname, $fontsize) = @_;

    xine_osd_set_font($self->{'osd'}, $fontname, $fontsize)
}

sub show {
    my $self = shift;

    xine_osd_show($self->{'osd'}, 0);
}

sub hide {
    my $self = shift;

    xine_osd_hide($self->{'osd'}, 0)
}

sub DESTROY {
    my $self = shift;
    xine_osd_free($self->{'osd'});
}

1;

__END__

=head1 NAME

Video::Xine::OSD - Xine onscreen display

=head1 METHODS

These methods are used for the Xine on-screen display.

=head3 new()

  my $osd = Video::Xine::OSD->new($stream, $x, $y, $width, $height);

Creates a new OSD.

=head3 clear()

 $osd->clear()

Clears out the on-screen display.

=head3 draw_text()

 $osd->draw_text(x => 0, y => 0, text => 'hello world', color_base => 1)

Draw text on the on-screen display. Set the font with C<set_font()>
before calling this method, or no text will be drawn.

=head3 set_font()

 $osd->set_font($font_name, $font_size);

Sets the font and font size. C<$font_name> can be either a straight
name or a path to a TrueType font file. C<$font_size> is the point
size of the font. The Xine header seems to want you to make this a
multiple of 11; not sure why.

=head3 show()

 $osd->show();

Renders the OSD onto the screen.

=head3 hide()

 $osd->hide();

Hides the OSD from the screen.

=cut
