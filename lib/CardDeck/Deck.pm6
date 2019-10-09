use v6.c;

use CardDeck::Themes::Standard;

class CardDeck::Deck {
  has $!autoShuffle;
  has $!shuffleType;
  has @!order;
  has @!deck;
  has @!plucked;
  has @!discarded;

  has $!theme;

  submethod BUILD {
    @!order = (1...self.elems);
    $!autoShuffle = True;
  }

  method new (|) {
    die 'Cannot instantiate CardDeck::Deck. Please use one of the sub-classes!';
  }

  method setShuffleType (ShuffleType $type) {
    $!shuffleType = $type;
  }

  method shuffle (&custom?) {
    given $shuffleType {
      when Default {
        @!deck = @!order;
      }
      when Random {
        @!deck = @!order.sort({ rand });
      }
      when Custom {
        die 'Custom function not specified for custom sort type.'
          unless &custom;
        @!deck = @!order.sort({ &custom($_) });
      }
    }
    @!plucked = ()
    @!discarded = ();
  }

  method elems {
    $!max-x * $!max-y;
  }

  method pluck is export {
    unless @!order {
      return IterationEnd unless $!autoShuffle;
      self.shuffle;
    }
    @!plucked.push: $!currentCard = @!order.pop;

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

  method discard ($card) {
    # Error checking!
    @!discarded.push: $card;
  }

}
