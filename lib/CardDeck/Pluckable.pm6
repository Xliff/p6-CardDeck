use v6.c;

use GTK::Compat::Pixbuf;

role CardDeck::Pluckable {
  has @!plucked;
  has $.cardLastPlucked;

  method elems {
    self.max-x * self.max-y;
  }

  method pluck is export {
    unless self.card-order {
      return IterationEnd unless self.autoShuffle;
      self.shuffle;
    }
    @!plucked.push: $!cardLastPlucked = self.card-order.pop;

    my $cardRow = $!cardLastPlucked div self.max-x;
    my $cardCol = $!cardLastPlucked   % self.max-x;

    GTK::Compat::Pixbuf.new-subpixbuf(
      self.pixbuf,
      self.offset-x + self.card-width  * $cardCol +
        ($cardCol > 0 ?? self.col-spacing * ($cardCol - 1) !! 0),
      self.offset-y + self.card-height * $cardRow +
        ($cardRow > 0 ?? self.row-spacing * ($cardRow - 1) !! 0),
      self.card-width,
      self.card-height
    );
  }

  method clear-plucked {
    @!plucked = ();
  }

}
