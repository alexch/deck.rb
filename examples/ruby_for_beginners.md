# The Complete Beginner's Guide to Programming

# What is a program?

# Operating Systems

![](img/os_x_logo.jpg)

![](img/windows_logo.gif)

![](img/linux_logo.gif)

# Applications

![](img/acrobat.jpg)
![](img/finder.png)
![](img/firefox.png)
![](img/itunes.png)
![](img/quicktime.jpg)
![](img/safari.png)
![](img/ms_office.png)
![](img/wordpress.jpg)

!SLIDE centereverything

# Web Application In Rails
![](img/web_app_in_rails.jpg)

!SLIDE incremental smbullets
# How do I write one?

* Learn about customer's requirements
* Translate to "stories"
* Pick a story that seems doable
* Write code that does it
* Show your work to the customer, get feedback
* Based on feedback, adjust your stories
* When a story is done, go back to "pick a story"
* Repeat until app is finished!

!SLIDE subsection

# Let's start writing code!

!SLIDE bullets

* Windows: git bash ![](img/git_bash.png)

* Mac OS X: Terminal ![](img/mac_terminal_sm.png)

!SLIDE commandline

    $ irb

!SLIDE

## Variables
### words that hold information

    ::: ruby
    > my_variable = 5
    => 5
    > my_other_variable = "hi"
    => "hi"

!SLIDE
## Types of information

!SLIDE
## Strings (text)

!SLIDE
## Numbers

!SLIDE
# Collections

!SLIDE
# Arrays

An Array is a list of objects.

    ::: ruby
    >> fruits = ["kiwi", "strawberry", "plum"]
    => ["kiwi", "strawberry", "plum"]

!SLIDE
# Array Indexing

Ruby starts counting at zero.

    ::: ruby
    >> fruits[0]
    => "kiwi"
    >> fruits[2]
    => "plum"
    >> fruits[3]
    => nil

!SLIDE
# Array methods

* first, last
* push, pop
* shift, unshift

        ::: ruby
        fruits.first #=> "kiwi"

!SLIDE
# Hashes

* aka Dictionary or Map
* collection of key/value pairs

        ::: ruby
        >> states = {"CA" => "California",
            "DE" => "Delaware"}
        => {"CA"=>"California", "DE"=>"Delaware"}

        >> states["CA"]
        => "California"

!SLIDE
## Operators

### doing stuff with variables

    ::: ruby
    > my_variable + 2
    => 7
    > my_variable * 3
    => 15
    > my_fruits = my_fruits + ["lychee"]
    => ["kiwi", "strawberry", "plum", "lychee"]
    > my_fruits = my_fruits - ["lychee"]
    => ["kiwi", "strawberry", "plum"]

!SLIDE
# Loops

### doing the same thing a bunch of times

The hard way:

    ::: ruby
    >> puts fruits[0]
    kiwi
    => nil
    >> puts fruits[1]
    strawberry
    => nil
    >> puts fruits[2]
    plum
    => nil

!SLIDE
# Loops

### doing the same thing a bunch of times

The easy way:

    >> fruits.each {|f| puts f}
    kiwi
    strawberry
    plum
    => ["kiwi", "strawberry", "plum"]

!SLIDE
# Loops (multi-line)

The easy way, with "do...end" rather than "{...}"

    >> fruits.each do |f|
    ?> puts f
    >> end
    kiwi
    strawberry
    plum
    => ["kiwi", "strawberry", "plum"]

!SLIDE
## Conditionals

### doing something only if a condition is met

    >> fruits.each do |f|
    ?> puts f if f == "plum"
    >> end
    plum
    => ["kiwi", "strawberry", "plum"]

!SLIDE subsection
# Command-Line Programs

!SLIDE bullets
# Hello World

hello.rb

    @@@ Ruby
    puts "Hello, World!"

!SLIDE bullets
# Arguments (ARGV)

hello.rb

    @@@ Ruby
    puts "Hello, #{ARGV.first}!"

    $ ruby hello.rb Alice
    Hello, Alice!

!SLIDE bullets
# Conditionals

hello.rb

    @@@ Ruby
    if ARGV.empty?
      puts "Hello, World!"
    else
      puts "Hello, #{ARGV.first}!"
    end

    $ ruby hello.rb
    Hello, World!
    $ ruby hello.rb Alice
    Hello, Alice!

!SLIDE
# Sinatra

## hello_app.rb

    @@@ Ruby
    require 'rubygems'
    require 'sinatra'

    get '/' do
      "<b>Hello, <i>bang bang</i>!"
    end

!SLIDE commandline
# Sinatra

    $ gem install sinatra
    $ ruby hello_app.rb
    == Sinatra/1.2.6 has taken the stage on 4567 for development with backup from Thin
    >> Thin web server (v1.2.7 codename No Hup)
    >> Maximum connections set to 1024
    >> Listening on 0.0.0.0:4567, CTRL+C to stop

then open a browser to <http://localhost:4567/>

!SLIDE bullets
# sinatra with rerun

    gem install rerun
    rerun hello_app.rb

...now it'll automatically reload when you edit a file.

!SLIDE
## Web App Network Architecture
![](img/web-application.png)

!SLIDE
## Web App MVC Architecture
![](img/mvc_simple.png)

