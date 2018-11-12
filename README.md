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
    <!VIDEO u1zgFlCw8Aw>

then run this:

    deck meals.md

and you'll get a web server running on `http://localhost:4333` serving up a slide presentation with four slides:

* One titled "Breakfast" with three bullet points
* One titled "Lunch" with three H2 headers ("Lunch", "Ham Sandwich", and "Caesar Salad")
* One with no headers, just a picture (stored in the same directory as `meals.md`)
* One titled "Dinner" with a blockquote and an embedded youtube video player

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
* uses deck.js' "swiss" and "horizontal-slide" themes (configurable; see below)
* uses several deck.js extensions, including `goto`, `menu`, `navigation`, `status`, `hash`,  and `scale`
* uses RedCarpet markdown extensions, including
  * tables <http://michelf.com/projects/php-markdown/extra/#table>
  * fenced code blocks <http://michelf.com/projects/php-markdown/extra/#fenced-code-blocks>
* mostly backwards-compatible with Showoff, i.e. you can specify a `showoff.json` file on the command line
* if the parameter (or 'sections' entry) starts with '# ' then it's parsed as literal markdown, not a file
* code syntax highlighting using [highlight.js](https://highlightjs.org)
  * specify language in a fenced code block
  * e.g. <code>\`\`\` ruby</code>
* lines beginning with `.notes ` are skipped
* each slide is preceded by an `<a class=\"slide-anchor\" name=\"anchor/slidename\">` so you can render slides into a top-to-bottom list and have a table of contents link to inner anchors (and format them with a height and/or a negative top, to allow spacing past a fixed page header)
* slides include `markdown-body` css class, for compatibility with the [github-markdown](https://github.com/sindresorhus/github-markdown-css/blob/gh-pages/github-markdown.css) stylesheet
* directives:
    * `<!VIDEO youtubeid>`
    * `<!--BOX-->` / `<!--/BOX-->`  open/close a `section` with class `box`

## Command-Line API

`deck foo.md`

 * start a local Rack server (probably Sinatra) on port 4333
 * http://localhost:4333/ serves the presentation built from `foo.md`
 * can specify multiple source files in a row
 * can also specify a showoff.json file to load multiple markdown files

### Options

            --port, -p <i>:   Specify alternate port (default: 4333)
               --build, -b:   Build an HTML file instead of launching a server (WARNING: not very useful yet)
           --theme, -s <s>:   Specify the style theme from deck.js/themes/style/ (default: swiss)
      --transition, -t <s>:   Specify the transition theme from deck.js/themes/transition/ (default: horizontal-slide)
             --version, -v:   Print version and exit
                --help, -h:   Show this message

## Themes

`deck.js` has several themes for styling and animating your presentation.
You can select these from the command line or from a `showoff.json` file with the `style` and `transition` options.

To skip the deck theme and use your own CSS file, pass its URL (full or partial) as the `style` param. (TODO: allow this for transition as well)

Currently the following themes are available:

### Style Themes

* neon
* swiss
* web-2.0

### Transition Themes

* fade
* horizontal-slide
* vertical-slide

## Deploying to Heroku

To deploy your slides as a Heroku app, put them into a Git repo, and add a file
called `config.ru` with contents like this:

    require "rubygems"
    require "bundler"
    Bundler.setup
    Bundler.require

    require 'deck/rack_app'
    run Deck::RackApp.build('slides.md')

and a `Gemfile` like this:

    gem "deckrb"

Then deploy to Heroku as usual (e.g. `heroku apps:create`).

Note that `Deck::RackApp.build` can accept either a filename or an array of filenames.
It also accepts options, e.g.

    run Deck::RackApp.build('slides.md', transition: 'fade')


## Known Issues (Bugs and Limitations)

* If you're running Webrick, you may not be able to kill the server with Ctrl-C. This is apparently due to a bug in recent versions of Webrick.
  * Workaround: `gem install thin` -- if thin is installed, deck will use it instead of webrick
* Auxiliary files (e.g. images) are interleaved in URL path space, so overlapping file names might not resolve to the right file.
  * todo: rewrite internal links to files and serve them relative to current dir, not slide dir
* H1s (which split slides) are converted to H2s for compatibility with deck.js's CSS themes
  * unless they're the only item on the slide, in which case they remain H1s
* We use RedCarpet to process markdown, which doesn't work exactly the same as RDiscount... for example:
  * indented code blocks under a bullet point may need to be indented more
  * code blocks must be separated from the previous text by a newline
* Slide scaling isn't perfect; sometimes either resizing or reloading will improve the layout.

Report bugs on <http://github.com/alexch/deck.rb/issues>

## Credits

* deck.js by Caleb at <http://imakewebthings.com>
* deck.rb by Alex Chaffee <http://alexchaffee.com>, with help from
  * Steven! Ragnarök <http://nuclearsandwich.com>
  * David Doolin <http://dool.in>
  * and other awesome patchers

### See Also

* [Web Slide Show GGroup](https://groups.google.com/group/webslideshow)
* [Showoff](https://github.com/schacon/showoff) by Scott Chacon
* [Keydown](https://github.com/infews/keydown) by Davis Frank

## TODO

* find any lines that start with a <p>.(something) and turn them into <p class="something">
  * see showoff.rb:189
* fix title tag (base it off of presentation name or something)
* scale images to fit on the page
* if no files are specified, use either './showoff.json' or all `.md` files under current directory
* `deck.json` config file
* config options:
  * show/hide theme selector
  * show/hide page number/nav
  * better contents popup behavior
  * choose deck extensions
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
* some way to build/rebuild a project that is deployable to heroku
* PDF
* rewrite internal links to files and serve them relative to current dir, not slide dir
* custom `.css`, `.scss`, and `.js` files, which will get imported into all slides
* support some more extensions https://github.com/imakewebthings/deck.js/wiki
* improve table of contents
  * nested sections
  * disappear when clicked outside of, esc pressed, etc.
  * close box
* requests from Christopher Gandrud <http://christophergandrud.blogspot.com/2012/05/aspirational-useful-deckrb-with.html>
  * There really aren’t title slides.
  * The slideshow opens as a locally hosted webserver, and the command to build a stand alone HTML presentation doesn’t seem to work that well (hence no example included with this post).
  * It only allows you to use the Swiss template.
  * I couldn’t figure out how to easily get MathJax support to display equations.



## TODO (community)

* submit theme-picker extension to deck.js
* mix with keydown https://github.com/infews/keydown
* gh-pages documentation site
* integrate with slideshow https://github.com/geraldb/slideshow-deck.js
* make it a proper Rack middleware thingy and add to https://github.com/rack/rack/wiki/List-of-Middleware

# License

The MIT License

deck.js Copyright (c) 2011 Caleb Troughton

deck.rb Copyright (c) 2011-12 Alex Chaffee

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.


