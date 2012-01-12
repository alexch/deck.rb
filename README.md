# deck.rb

*curing deck.js of angle bracket addiction*

## Summary

[deck.js](http://imakewebthings.github.com/deck.js) is a JavaScript library for building slide presentations using HTML 5. [deck.rb](http://github.com/alexch/deck.rb) builds on top of deck.js, adding some features:

* clean(ish) page skeleton allows you to focus on your slides, not the HTML/CSS infrastructure
* multiple slide source formats, including
  * Erector
  * Markdown
* presentations can comprise several source files

## Command-Line API (proposed)

`deck run foo.md`

 * start a local Rack server (probably Sinatra) on port 4333
 * http://localhost:4333/ serves the presentation in foo.md
 * can also specify multiple source files in a row

`deck build foo.md`

 * create a static site
 * default output dir = ./public (even if foo.md is elsewhere)
 * copies deck.js source
 * also copies "img" directory if it exists

`deck deploy` ???

 * some way to build/rebuild a project that is deployable to heroky


### Options

 * --output dir
 * --config deck.json
 * --port portnum
 * --theme themename

## Credits

* deck.js by Caleb at http://imakewebthings.com
* deck.rb by Alex Chaffee http://alexchaffee.com, with help from
  * Steven! Ragnarök @nuclearsandwich
* showoff by Scott Chacon

## TODO

* markdown
* multiple files
* rack app
* config: 
  * show theme selector
  * show page number/nav
  * choose deck extensions
* slim
* haml
* specify Redcarpet Markdown extensions
* syntax highlighting (using sh (js) or coderay (rack)?)
* option to render all JS and CSS inline, for a self-contained HTML doc (and maybe images too)

## TODO (community)

* add to deck.js wiki https://github.com/imakewebthings/deck.js/wiki
* announce on https://groups.google.com/forum/#!forum/webslideshow
* mix with keydown https://github.com/infews/keydown

