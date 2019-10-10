use v6.c;

use CardDeck::Theme;

constant deckPixbuf = "{$*CWD}/decks/deck-found-on-quora.png";

role CardDeck::Themes::Standard does CardDeck::Theme {

  method load-theme {
    self.row-spacing = 1;
    self.col-spacing = 0;
    self.offset-x    = 1;
    self.offset-y    = 1;
    self.max-x       = 13;
    self.max-y       = 4;
    self.card-width  = 72;
    self.card-height = 96;

    self.load-card-base(deckPixbuf);
  }

}
