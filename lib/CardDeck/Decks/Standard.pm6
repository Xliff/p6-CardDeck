use v6.c;

use CardDeck::Deck;
use CardDeck::Themes::Standard;

class CardDeck::Decks::Standard
  is CardDeck::Deck
  does CardDeck::Themes::Standard
{

  submethod TWEAK {
    self.load-theme;
    self.init-attributes;
    self.set-order;
  }

  proto method new (|)
  { * }

  multi method new {
    self.bless;
  }

}
