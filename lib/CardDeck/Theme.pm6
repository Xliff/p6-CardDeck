use v6.c;

use GTK::Compat::Pixbuf;

our enum ShuffleType <Default Random Custom>;

role CardDeck::Theme {

  has $.row-spacing;
  has $.col-spacing;
  has $.offset-x   ;
  has $.offset-y   ;
  has $.max-x      ;
  has $.max-y      ;
  has $.card-width ;
  has $.card-height;
  has $.currentCard;
  has $!pixbuf     ;

  method load-card-base ($filename) {
    $!pixbuf = GTK::Compat::Pixbuf.new-from-file($filename);
  }  

}
