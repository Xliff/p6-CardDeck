use v6.c;

use CardDeck::Pluckable;

our enum ShuffleType <Default Random Custom>;

class CardDeck::Deck does CardDeck::Pluckable {
  has $!theme;
  has $!autoShuffle;
  has @!deck;
  has @!discarded;

  has @.card-order;

  has ShuffleType $.shuffleType is rw;

  submethod BUILD {
    @!card-order = (1...self.elems);
    $!autoShuffle = True;
  }

  method new (|) {
    die 'Cannot instantiate CardDeck::Deck. Please use one of the sub-classes!';
  }

  method shuffle (&custom?) {
    given $!shuffleType {
      when Default {
        @!deck = @!card-order;
      }
      when Random {
        @!deck = @!card-order.sort({ rand });
      }
      when Custom {
        die 'Custom function not specified for custom sort type.'
          unless &custom;
        @!deck = @!card-order.sort({ &custom($_) });
      }
    }
    self.clear-plucked;
    @!discarded = ();
  }

  method discard ($card) {
    # Error checking!
    @!discarded.push: $card;
  }

}
