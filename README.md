# deck.rb

*curing deck.js of angle bracket addiction*

## Summary

[deck.js](http://imakewebthings.github.com/deck.js) is a JavaScript library for building slide presentations using HTML 5. [deck.rb](http://github.com/alexch/deck.rb) builds on top of deck.js, adding some features:

* clean(ish) page skeleton allows you to focus on your slides, not the HTML/CSS infrastructure
* multiple slide source formats, including
  * Erector
  * Markdown
* presentations can comprise several source files
* source files look good as source, built HTML, preview HTML, or as a deck doc
  * slide directives look like comments when rendered into HTML (e.g. as &lt;!SLIDE&gt;)
  * links to auxiliary files (e.g. `img src`) are resolved relative to the source file
  * generated HTML is pretty-printed
* uses RedCarpet markdown extensions, including
  * tables <http://michelf.com/projects/php-markdown/extra/#table>
  * fenced code blocks <http://michelf.com/projects/php-markdown/extra/#fenced-code-blocks>

## Command-Line API (proposed)

`deck run foo.md`

 * start a local Rack server (probably Sinatra) on port 4333
 * http://localhost:4333/ serves the presentation in foo.md
 * can specify multiple source files in a row

`deck build foo.md`

 * create a static site
 * default output dir = ./public (even if foo.md is elsewhere)
 * copies deck.js source
 * also copies "img" directory if it exists

`deck deploy` ???

 * some way to build/rebuild a project that is deployable to heroky

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

* auxiliary files are interleaved in URL path space, so overlapping file names might not resolve to the right file
* H1s are converted to H2s for compatibility with deck.js's CSS
  * unless they're the only item on the slide, in which case they remain H1s

## TODO

* config file
* config: 
  * show/hide theme selector
  * show/hide page number/nav
  * choose deck extensions
* command-line tool can take a directory
  * first pass: globs all *.md files in it
* command-line options:
  * --output dir
  * --config deck.json
  * --port portnum
  * --theme themename
* more slide file types
  * html
  * slim http://slim-lang.com/index.html
  * haml
  * tilt
* specify Redcarpet Markdown extensions
* syntax highlighting (using sh (js) or coderay (rack)?)
* option to render all JS and CSS inline, for a self-contained HTML doc 
  * and maybe images too, base64-encoded
* image scaling
* build and push into a gh-pages branch
* build and push into a heroku app
* find any lines that start with a <p>.(something) and turn them into <p class="something">
  * see showoff.rb:189
* fix title tag (base it off of presentation name or something)

## TODO (community)

* submit theme-picker extension to deck.js
* add to deck.js wiki https://github.com/imakewebthings/deck.js/wiki
* announce on https://groups.google.com/forum/#!forum/webslideshow
* mix with keydown https://github.com/infews/keydown
* gh-pages documentation site
* integrate with slideshow https://github.com/geraldb/slideshow-deck.js
