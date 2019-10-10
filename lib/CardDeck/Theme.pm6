use v6.c;

use GTK::Compat::Pixbuf;

use RSVG;

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
  has $.dpi         is rw;

  has $.pixbuf;

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
    $!pixbuf = do given $filename.IO.extension {
      when 'svg' {
        die 'Must have a DPI value set via theme!' unless $!dpi;

        my $svg = RSVG.new-from-file($filename);
        $svg.set-dpi($!dpi);
        $svg.pixbuf;
      }

      when GTK::Compat::Pixbuf.get-formats.any {
        GTK::Compat::Pixbuf.new-from-file($filename);
      }

      default {
        die "Unknown image format '{$_}'";
      }
    }
  }

}
