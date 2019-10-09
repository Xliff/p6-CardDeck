use v6.c;

unit module CardDeck;

use GTK::Compat::Pixbuf;

constant row_spacing = 2;
constant col_spacing = 0;
constant offset_x    = 1;
constant offset_y    = 1;
constant max_x       = 13;
constant max_y       = 4;
constant card_width  = 73;
constant card_height = 96;

my ($currentCard, $currentCol, $currentRow) = (0, 0, 0);
our $pixbuf;

sub load-card-base ($filename) is export {
  $pixbuf = GTK::Compat::Pixbuf.new-from-file($filename);
}

sub get-next-card is export {
  $currentCard++;
  $currentCard = 0 if $currentCard > (max_x * max_y) - 1;

  my $cardRow = $currentCard div max_x;
  my $cardCol = $currentCard   % max_x;

  my $nc = GTK::Compat::Pixbuf.new-subpixbuf(
    $pixbuf,
    offset_x + card_width  * $cardCol +
      ($currentCol > 0 ?? col_spacing * ($currentCol - 1) !! 0),
    offset_y + card_height * $cardRow +
      ($currentRow > 0 ?? row_spacing * ($currentRow - 1) !! 0),
    card_width,
    card_height
  );
  $nc;
}
