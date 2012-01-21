# deck.rb

*curing deck.js of angle bracket addiction*

## Summary

[deck.js](http://imakewebthings.github.com/deck.js) is a JavaScript library for building slide presentations using HTML 5. [deck.rb](http://github.com/alexch/deck.rb) builds on top of deck.js, adding some features:

* clean(ish) page skeleton allows you to focus on your slides, not the HTML/CSS infrastructure
* multiple slide source formats, including
  * Markdown
* presentations can comprise several source files
* source files look good as source, built HTML, preview HTML, or as a deck doc
  * each H1 designates the beginning of a new slide
  * explicit `!SLIDE` or `<!SLIDE>` directives can split slides too
  * slide directives look like comments when rendered into HTML (e.g. as &lt;!SLIDE&gt;)
  * generated HTML is pretty-printed for easier "view source"
  * links to auxiliary files (e.g. `img src`) are resolved relative to the source file -- no more broken images in markdown previews!
  * add CSS classes to slides inside the slide directive -- e.g. `<!SLIDE center>` gives `<section class="slide center">`
* uses RedCarpet markdown extensions, including
  * tables <http://michelf.com/projects/php-markdown/extra/#table>
  * fenced code blocks <http://michelf.com/projects/php-markdown/extra/#fenced-code-blocks>
* mostly compatible with Showoff
  * specifying 'showoff.json' on the command line loads all slides in its 'sections' section
* if the parameter starts with '# ' then it's parsed as literal markdown, not a file
* code syntax highlighting using Coderay
  * specify language at the top of the block using either ::: or @@@
  * e.g. `@@@ ruby`

## Command-Line API

`deck run foo.md`

 * start a local Rack server (probably Sinatra) on port 4333
 * http://localhost:4333/ serves the presentation built from `foo.md`
 * can specify multiple source files in a row
 * can also specify a showoff.json file to load multiple markdown files

`deck build foo.md`

 * creates a static page `foo.html` in the current directory
 * unfortunately the `deck.js` source code will not be around so this won't really work yet

## Command-Line API (proposed)

`deck build foo.md`

 * create a static site
 * default output dir = ./public (even if foo.md is elsewhere)
 * copies (or inlines) deck.js source
 * also copies (or inlines) "img" directory if it exists


### Options

* none yet :-)

## Credits

* deck.js by Caleb at <http://imakewebthings.com>
* deck.rb by Alex Chaffee <http://alexchaffee.com>, with help from
  * Steven! Ragnarök <http://nuclearsandwich.com>

### See Also

* showoff by Scott Chacon
* keydown by Davis Frank

## Bugs and Limitations

* auxiliary files (e.g. images) are interleaved in URL path space, so overlapping file names might not resolve to the right file
* H1s (which split slides) are converted to H2s for compatibility with deck.js's CSS themes
  * unless they're the only item on the slide, in which case they remain H1s
* we use RedCarpet to process markdown, which doesn't work exactly the same as RDiscount... for example:
  * indented code blocks under a bullet point may need to be indented more
  * code blocks must be separated from the previous text by a newline

## TODO

* fix title tag (base it off of presentation name or something)
* if no files are specified, use either './showoff.json' or all `.md` files under current directory
* deck.json config file
* config options:
  * show/hide theme selector
  * show/hide page number/nav
  * choose deck extensions
  * theme
  * specify which Redcarpet Markdown extensions to use
* command-line tool can take a directory
  * first pass: globs all *.md files in it
* command-line options (overriding or complementing config file options)
  * --output dir
  * --config deck.json
  * --port portnum
  * --theme themename
* more slide file types
  * Erector - `foo/bar_bar.rb` would expect `class BarBar < Deck::Slide` in there
  * html
  * slim http://slim-lang.com/index.html
  * haml
  * tilt
* option to render all JS and CSS inline, for a self-contained HTML doc
  * and maybe images too, base64-encoded
* image scaling
* build and push into a gh-pages branch
* build and push into a heroku app
* find any lines that start with a <p>.(something) and turn them into <p class="something">
  * see showoff.rb:189
* some way to build/rebuild a project that is deployable to heroku


## TODO (community)

* submit theme-picker extension to deck.js
* add to deck.js wiki https://github.com/imakewebthings/deck.js/wiki
* announce on https://groups.google.com/forum/#!forum/webslideshow
* mix with keydown https://github.com/infews/keydown
* gh-pages documentation site
* integrate with slideshow https://github.com/geraldb/slideshow-deck.js
