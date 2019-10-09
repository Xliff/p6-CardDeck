use v6.c;

use GTK::Compat::Pixbuf;

role CardDeck::Theme {

  has $!row-spacing;
  has $!col-spacing;
  has $!offset-x   ;
  has $!offset-y   ;
  has $!max-x      ;
  has $!max-y      ;
  has $!card-width ;
  has $!card-height;
  has $!currentCard;
  has $!pixbuf     ;

  has @!order;

  method load-card-base ($filename) {
    $!pixbuf = GTK::Compat::Pixbuf.new-from-file($filename);
  }

  method elems {
    $!max-x * $!max-y;

  }
  method pluck is export {
    unless @!order {
      @!order = (1...self.elems).reverse;
    }

    $!currentCard = @!order.pop;
    $!currentCard = 0 if $!currentCard > self.elems - 1;

    my $cardRow = $!currentCard div $!max-x;
    my $cardCol = $!currentCard   % $!max-x;

    GTK::Compat::Pixbuf.new-subpixbuf(
      $!pixbuf,
      $!offset-x + $!card-width  * $cardCol +
        ($cardCol > 0 ?? $!col-spacing * ($cardCol - 1) !! 0),
      $!offset-y + $!card-height * $cardRow +
        ($cardRow > 0 ?? $!row-spacing * ($cardRow - 1) !! 0),
      $!card-width,
      $!card-height
    );
  }

}
