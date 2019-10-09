use v6.c;

use COGL::Raw::Types;
use Clutter::Raw::Types;

use Clutter::Actor;
use Clutter::Image;
use Clutter::Stage;
use Clutter::Timeline;
use Clutter::Main;

use CardDeck;

my $stage-color = Clutter::Color.new(   0,   0,   0, 255);
my $red         = Clutter::Color.new( 255,   0,   0, 255);
my $green       = Clutter::Color.new(   0, 255,   0, 255);
my $blue        = Clutter::Color.new(   0,   0, 255, 255);
my $yellow      = Clutter::Color.new( 255, 255,   0, 255);
my $cyan        = Clutter::Color.new(   0, 255, 255, 255);
my $purple      = Clutter::Color.new( 255,   0, 255, 255);

sub get-next-card-face {
  my $pixbuf = get-next-card;

  my $image = Clutter::Image.new;
  $image.set_data(
    $pixbuf.pixels,
    $pixbuf.has_alpha ??
      COGL_PIXEL_FORMAT_RGBA_8888 !! COGL_PIXEL_FORMAT_RGB_888,
    $pixbuf.width,
    $pixbuf.height,
    $pixbuf.rowstride
  );
  $image;
}

my (@g, $side);
sub create-group($card, $back-col) {
  for Clutter::Actor.new xx 3 {
    @g.push: .setup(
      size             => (64, 196)
    );
    .show-actor;
  }

  @g[0].set-position(96, 30);
  @g[0].add-child($_) for @g[1, 2];
  @g[0].set-child-below-sibling( @g[1], @g[2] );
  @g[0].set-pivot-point(0.5, 0.5);

  @g[2].content          = $card;
  @g[1].background-color = $back-col;
  @g[1].hide-actor;

  $*stage.add-child( @g[0] );

  @g;
}

enum Side <Front Back>;

sub MAIN {
  exit(1) unless Clutter::Main.init == CLUTTER_INIT_SUCCESS;

  my $*stage = Clutter::Stage.new.setup(
    background-color => $stage-color,
    size             => (256, 256),
  );
  $*stage.destroy.tap({ Clutter::Main.quit });

  load-card-base("{$*CWD/decks/deck-found-on-quora.png");

  $*stage.set_content_scaling_filters(
    CLUTTER_SCALING_FILTER_TRILINEAR,
    CLUTTER_SCALING_FILTER_LINEAR
  );

  create-group(get-next-card-face, $red);

  sub front {
    $side = Front;
    @g[2].show-actor;
    @g[1].hide-actor;
  }

  sub back {
    $side = Back;
    @g[2].hide-actor;
    @g[1].show-actor;
    @g[2].content = get-next-card-face;
  }

  my ($timeline, $rotation) = (Clutter::Timeline.new(60), 0);
  $timeline.repeat-count = -1;
  front;
  my $next-swap = 90;
  $timeline.new-frame.tap(-> *@a {
    $rotation += 1.8;

    # Given: my @a = (0, 90, *+180 ... Inf);
    # Find the index where rotation.abs falls, if that index
    # is odd, card side is back, otherwise front.
    if $rotation >= $next-swap {
      if $side == Back {
        front
      } else {
        back
      }
      $next-swap += 180;
    }

    @g[0].rotation-angle-y = $rotation;
  });
  $timeline.start;

  $*stage.show-actor;

	Clutter::Main.run;
}
