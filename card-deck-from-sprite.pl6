use v6.c;

use GTK::Raw::Types;

use GLib::Signal;
use GLib::Timeout;
use GDK::Pixbuf;

use GTK::Application;
use GTK::Image;
use GTK::EventBox;

use CardDeck::Themes::Standard;

my $a = GTK::Application.new(
  title  => 'org.genex.card_deck',
  width  => 72,
  height => 96
);

$a.activate.tap({
  $a.wait-for-init;

  my $image = GTK::Image.new-from-pixbuf(get-next-card);
  my $ebox  = GTK::EventBox.new;
  $ebox.events = GDK_BUTTON_PRESS_MASK;
  $ebox.add($image);

  my $cards = CardDeck::Deck::Standard;

  my $event = -> *@a {
    CATCH { default { .message.say } }

    $image.pixbuf = $cards.pluck;
    G_SOURCE_CONTINUE;
  };
  GLib::Timeout.add(100, $event);
  #GTK::Compat::Signal.connect($ebox, 'button-press-event', $event);

  $a.window.destroy-signal.tap({ $a.exit });
  $a.window.add($ebox);
  $a.window.show-all;
});

$a.run;
