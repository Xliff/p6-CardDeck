use v6.c;

use CardDeck::Theme;

role CardDeck::Themes::Standard does CardDeck::Theme {
  constant deckPixbuf = "{$*CWD}/decks/deck-found-on-quora.png";

  method load-theme {
    $!row-spacing = 1;
    $!col-spacing = 0;
    $!offset-x    = 1;
    $!offset-y    = 1;
    $!max-x       = 13;
    $!max-y       = 4;
    $!card-width  = 72;
    $!card-height = 96;

    self.load-card-base(deckPixbuf);
  }

}
