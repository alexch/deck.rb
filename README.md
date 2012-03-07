# deck.rb

*slides in markdown, using deck.js*

Home: <http://github.com/alexch/deck.rb>

## Installation

    gem install deckrb

## Usage

Put this in a file named `meals.md`:

    # Breakfast
    * scrambled eggs
    * coffee
    * bacon

    # Lunch
    ## Ham Sandwich
    ## Caesar Salad

    <!SLIDE>
    ![a picture of my lunch](ham-sandwich.jpg)

    # Dinner
    > "To eat is to live." -Anon.

then run this:

    deck meals.md

and you'll get a web server running on `http://localhost:4333` serving up a slide presentation with four slides:

* One titled "Breakfast" with three bullet points
* One titled "Lunch" with three H2 headers ("Lunch", "Ham Sandwich", and "Caesar Salad")
* One with no headers, just a picture (stored in the same directory as `meals.md`)
* One titled "Dinner" with a blockquote

## Details

[deck.js](http://imakewebthings.github.com/deck.js) is a JavaScript library for building slide presentations using HTML 5. [deck.rb](http://github.com/alexch/deck.rb) builds on top of deck.js, adding some features:

* clean(ish) page skeleton allows you to focus on your slides, not the HTML/CSS infrastructure
* multiple slide source formats, including
  * [Markdown](http://daringfireball.net/projects/markdown/)
  * should be easy to add other formats
* presentations can span several source files, and can be assembled piecemeal
* source files look good as source, built HTML, preview HTML, or as a deck doc
  * each H1 (single hash) designates the beginning of a new slide
  * explicit `!SLIDE` or `<!SLIDE>` directives can split slides too -- use `<!SLIDE>` so they look like comments when rendered into normal HTML
  * links to image files are resolved relative to the source file -- no more broken images in markdown previews, and no need to put all your images in a separate directory!
  * add CSS classes to slides inside the slide directive - - e.g. `<!SLIDE center>` gives `<section class="slide center">`
  * generated HTML is pretty-printed for easier "view source"
* uses deck.js' "swiss" theme and several extensions, including `goto`, `menu`, `navigation`, `status`, `hash`,  and `scale`
* uses RedCarpet markdown extensions, including
  * tables <http://michelf.com/projects/php-markdown/extra/#table>
  * fenced code blocks <http://michelf.com/projects/php-markdown/extra/#fenced-code-blocks>
* mostly backwards-compatible with Showoff, i.e. you can specify a `showoff.json` file on the command line
* if the parameter (or 'sections' entry) starts with '# ' then it's parsed as literal markdown, not a file
* code syntax highlighting using Coderay
  * specify language at the top of the block using either ::: or @@@
  * e.g. `@@@ ruby`

## Command-Line API

`deck foo.md`

 * start a local Rack server (probably Sinatra) on port 4333
 * http://localhost:4333/ serves the presentation built from `foo.md`
 * can specify multiple source files in a row
 * can also specify a showoff.json file to load multiple markdown files

### Options

    --port, -p <i>:   Specify alternate port (default: 4333)
       --build, -b:   Build an HTML file instead of launching a server (WARNING: not very useful yet)
     --version, -v:   Print version and exit
        --help, -h:   Show this message

## Credits

* deck.js by Caleb at <http://imakewebthings.com>
* deck.rb by Alex Chaffee <http://alexchaffee.com>, with help from
  * Steven! Ragnarök <http://nuclearsandwich.com>

### See Also

* [Web Slide Show GGroup](https://groups.google.com/group/webslideshow)
* [Showoff](https://github.com/schacon/showoff) by Scott Chacon
* [Keydown](https://github.com/infews/keydown) by Davis Frank

## Bugs and Limitations

* auxiliary files (e.g. images) are interleaved in URL path space, so overlapping file names might not resolve to the right file
  * todo: rewrite internal links to files and serve them relative to current dir, not slide dir
* H1s (which split slides) are converted to H2s for compatibility with deck.js's CSS themes
  * unless they're the only item on the slide, in which case they remain H1s
* we use RedCarpet to process markdown, which doesn't work exactly the same as RDiscount... for example:
  * indented code blocks under a bullet point may need to be indented more
  * code blocks must be separated from the previous text by a newline
* slide scaling isn't perfect; sometimes either resizing or reloading will improve the layout

## TODO

* fix title tag (base it off of presentation name or something)
* scale images to fit on the page
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
  * --theme themename
* more slide file types
  * Erector - `foo/bar_bar.rb` would expect `class BarBar < Deck::Slide` in there
  * html
  * slim http://slim-lang.com/index.html
  * haml
  * tilt
* option to render all JS and CSS inline, for a self-contained HTML doc
* `deck --build dir foo.md`
  * create a self-contained static site inside dir
  * copies (or inlines) deck.js source, generated html, and axiliary files e.g. images
  * hell, maybe it should inline everything *including* images (using those base64 urls or whatever) into a single HTML file
* build and push into a gh-pages branch
* build and push into a heroku app
* find any lines that start with a <p>.(something) and turn them into <p class="something">
  * see showoff.rb:189
* some way to build/rebuild a project that is deployable to heroku
* PDF
* rewrite internal links to files and serve them relative to current dir, not slide dir
* custom `.css`, `.scss`, and `.js` files, which will get imported into all slides
* support some more extensions https://github.com/imakewebthings/deck.js/wiki

## TODO (community)

* submit theme-picker extension to deck.js
* mix with keydown https://github.com/infews/keydown
* gh-pages documentation site
* integrate with slideshow https://github.com/geraldb/slideshow-deck.js
