#
* fix bin/deck "theme" option bug
* replace CodeRay with Highlight - https://highlightjs.org

# 0.5.2
* fix link CSS

# 0.5.1
* bugfix for Ruby 2.0

# 0.5.0
* bring deck.js up to date (https://github.com/imakewebthings/deck.js/commit/069f63294abe8c2bfd0e3c9b34d26090802c4f46)
* add --style and --transition options
* improve table of contents style
* rename [toc] link to [contents]
* lines beginning with `.notes ` are skipped

# 0.4.2 2012-09-26
* require rack >= 1.4.1
* require erector >= 0.9.0

# 0.4.0 2012-07-24
* !VIDEO directive to embed youtube videos

# 0.3.1 2012-06-06
* better table styling (overriding deck.js which strips most style from tables)
* simple table of contents ([toc] link on lower left)

# v0.3.0 2012-03-26
* remove "build" command
* just say "deck foo.md" now, not "deck run foo.md"
* can name showoff.json file with a suffix e.g. showoff-intro.json

# v0.2.2 2012-02-29
* binary now takes a -p $PORT or --port $PORT option which is passed to the Rack server
* binary supports -v/--version option
* fix bug under 1.8.7 ("can't convert File into String")

# v0.2.1 2012-02-16
* update to new version of deck.js (with improved scale extension)

