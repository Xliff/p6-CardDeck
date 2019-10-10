use v6.c;

use GTK::Compat::Pixbuf;

use CardDeck::Pluckable;

role CardDeck::Theme {

  has $.row-spacing is rw;
  has $.col-spacing is rw;
  has $.offset-x    is rw;
  has $.offset-y    is rw;
  has $.max-x       is rw;
  has $.max-y       is rw;
  has $.card-width  is rw;
  has $.card-height is rw;
  has $.currentCard is rw;

  has $.pixbuf;

  # method row-spacing is rw {
  #   die 'Cannod call row-spacing from a non CardDeck::Theme routine.'
  #     unless callframe(1).code.package ~~ CardDeck::Theme;
  #   $!row-spacing;
  # }
  #
  # method col-spacing is rw {
  #   die 'Cannod call col-spacing from a non CardDeck::Theme routine.'
  #     unless callframe(1).code.package ~~ CardDeck::Theme;
  #   $!col-spacing;
  # }
  #
  # method offset-x is rw {
  #   die 'Cannod call offset-x from a non CardDeck::Theme routine.'
  #     unless callframe(1).code.package ~~ CardDeck::Theme;
  #   $!offset-x;
  # }
  #
  # method offset-y is rw {
  #   die 'Cannod call offset-y from a non CardDeck::Theme routine.'
  #     unless callframe(1).code.package ~~ CardDeck::Theme;
  #   $!offset-y;
  # }

  method init-attributes {
    for ::?ROLE.^attributes».grep( *.has_accessor )».map( *.name.substr(2) ) {
      next unless $_;

      my $m = self.^lookup($_);
      next unless $m;
      $m.wrap: sub (|args) {
        die "Cannot call { $m.name } from a non compatible object."
          unless callframe(5).code.package ~~
                 ( CardDeck::Pluckable, CardDeck::Theme ).any;
        nextsame;
      }
    }
  }

  # Virtual
  method load-theme { ... }

  method load-card-base ($filename) {
    $!pixbuf = GTK::Compat::Pixbuf.new-from-file($filename);
  }

}
