use v6.c;

use GDK::Pixbuf;

role CardDeck::Pluckable {
  has @!plucked;
  has $.cardLastPlucked;

  method elems {
    self.max-x * self.max-y;
  }

  method pluck is export {
    unless self.deck.elems {
      say "AS: { self.autoShuffle }";
      return IterationEnd unless self.autoShuffle;
      self.shuffle;
    }
    say "D: { self.deck.gist }";
    @!plucked.push: ($!cardLastPlucked = self.deck.pop);

    my $cardRow = $!cardLastPlucked div self.max-x;
    my $cardCol = $!cardLastPlucked   % self.max-x;

    say "C: { $!cardLastPlucked }\nCard RC: ($cardRow, $cardCol)";

    my $pb = GDK::Pixbuf.new-subpixbuf(
      self.pixbuf,
      self.offset-x + self.card-width  * $cardCol + self.col-spacing * $cardCol,
      self.offset-y + self.card-height * $cardRow + self.row-spacing * $cardRow,
      self.card-width,
      self.card-height
    );
    say "PB: { $pb // 'WTF!' }";
    $pb;
  }

  method clear-plucked {
    @!plucked = ();
  }

}
