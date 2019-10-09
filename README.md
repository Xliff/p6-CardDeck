# p6-CardDeck

A very basic implementation of a graphical deck of cards for GTK-Based
code.

## Installation

Make a directory to contain the p6-Gtk-based projects. Once made, then set the P6_GTK_HOME environment variable to that directory:

```
$ export P6_GTK_HOME=/path/to/projects
```

Switch to that directory and clone both p6-GtkPlus and p6-Clutter

```
$ git clone https://github.com/Xliff/p6-Pango.git
$ git clone https://github.com/Xliff/p6-GtkPlus.git
$ git clone https://github.com/Xliff/p6-Clutter.git
$ cd p6-GtkPlus
$ zef install --deps-only .
```

To run the first example, do:

```
./p6gtkexec -Ilib card-deck-from-sprite.pl6
```

Running the second example is similar:

```
./p6gtkexec -Ilib spin-the-card.pl6
```
