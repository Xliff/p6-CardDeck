use v6.c;

use CardDeck::Deck;
use CardDeck::Theme::Standard;

class CardDeck::Decks::Standard
  is CardDeck::Deck
  does CardDeck::Themes::Standard
{
  submethod TWEAK {
    load-theme;
  }

  proto method new (|)
  { * }

  method new {
    self.bless;
  }
}
