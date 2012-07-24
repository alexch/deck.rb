# based on work by Alex and others in Showoff

require File.expand_path "../spec_helper", __FILE__
require "deck/slide"

module Deck
 describe Slide do

  describe "classes" do
    it "by default" do
      assert {Slide.new.classes == ["slide"]}
    end

    it "when passed a string" do
      assert {Slide.new(:classes => "foo bar").classes == ["slide", "foo", "bar"]}
    end

    it "when passed an array" do
      assert {Slide.new(:classes => ["foo", "bar"]).classes == ["slide", "foo", "bar"]}
    end
  end

  describe "splits Markdown into slides" do
    it "from an empty string" do
      slides = Slide.split ""
      assert { slides.empty? }
    end

    it "from a simple chunk of Markdown" do
      slides = Slide.split <<-MARKDOWN
# One
* uno
      MARKDOWN
      assert { slides.size == 1 }
      assert { slides.first.classes == ["slide"] }
      assert { slides.first.markdown_text == "# One\n* uno\n" }
    end

    it "from a simple chunk of Markdown with slide markers" do
      slides = Slide.split <<-MARKDOWN
!SLIDE cool
# One
* uno

!SLIDE neat
# Two
* dos
      MARKDOWN
      assert { slides.size == 2 }
      slide = slides.first
      assert { slide.classes == ["slide", "cool"] }
      assert { slides.first.markdown_text == "# One\n* uno\n\n" }
      slide = slides[1]
      assert { slide.classes == ["slide", "neat"] }
      assert { slide.markdown_text == "# Two\n* dos\n" }
    end

    it "from a simple chunk of Markdown with comment-style slide markers" do
      slides = Slide.split <<-MARKDOWN
<!SLIDE cool>
# One
* uno

<!SLIDE neat>
# Two
* dos
      MARKDOWN
      assert { slides.size == 2 }
      slide = slides.first
      assert { slide.classes == ["slide", "cool"] }
      assert { slides.first.markdown_text == "# One\n* uno\n\n" }
      slide = slides[1]
      assert { slide.classes == ["slide", "neat"] }
      assert { slide.markdown_text == "# Two\n* dos\n" }
    end


    it "omits empty slides" do
      slides = Slide.split <<-MARKDOWN
!SLIDE
# One
* uno

!SLIDE

!SLIDE
# Two
* dos
      MARKDOWN
      assert { slides.size == 2 }
    end

    def inner_html slide
      noko_doc(slide.to_html).css("section.slide").first.inner_html
    end

    describe "every H1 defines a new slide" do
      it "if there are no !SLIDE markers at all" do
        slides = Slide.split <<-MARKDOWN
# One
* uno

# Two
* dos
        MARKDOWN
        assert { slides.size == 2 }

        slide = slides.first
        assert { slide.classes == ["slide"] }
        assert { slide.markdown_text == "# One\n* uno\n\n" }

        slide = slides[1]
        assert { slide.classes == ["slide"] }
        assert { slide.markdown_text == "# Two\n* dos\n" }
      end

      it "with underline-style H1s" do
        slides = Slide.split <<-MARKDOWN
One
===
* uno

Two
===
* dos
        MARKDOWN
        assert { slides.size == 2 }

        slide = slides[0]
        assert { slide.classes == ["slide"] }
        assert { slide.markdown_text == "One\n===\n* uno\n\n" }

        slide = slides[1]
        assert { slide.classes == ["slide"] }
        assert { slide.markdown_text == "Two\n===\n* dos\n" }
      end


      it "with mixed SLIDE directives" do
        varied = <<-MARKDOWN
<!SLIDE>
# One
* uno

# Two
* dos

# Three
* tres

!SLIDE
# Four
* quatro
        MARKDOWN

        slides = Slide.split varied
        assert { slides.size == 4 }

        slide = slides[0]
        assert { slide.classes == ["slide"] }
        assert { slides.first.markdown_text == "# One\n* uno\n\n" }

        slide = slides[1]
        assert { slide.classes == ["slide"] }
        assert { slide.markdown_text == "# Two\n* dos\n\n" }

        slide = slides[2]
        assert { slide.classes == ["slide"] }
        assert { slide.markdown_text == "# Three\n* tres\n\n" }

        slide = slides[3]
        assert { slide.classes == ["slide"] }
        assert { slide.markdown_text == "# Four\n* quatro\n" }

      end
    end
  end

  def slide_from markdown_text
    Slide.split(markdown_text).first
  end

  describe "has an id" do
    it "based on the first header" do
      assert { slide_from("# foo").slide_id == "foo" }
    end

    it "lowercases and sanitizes" do
      assert { slide_from("# Foo's #1!").slide_id == "foos_1" }
    end

    it "from a parameter if one is passed" do
      slide = Slide.new(:markdown_text => "# foo", :slide_id => "bar")
      assert { slide.slide_id == "bar" }
    end
  end

  describe "has a title" do
    it "based on the first header" do
      assert { slide_from("# Foo").title == "Foo" }
    end

    it "preserves punctuation" do
      assert { slide_from("# Don't tread on me!").title == "Don't tread on me!" }
    end

    it "strips whitespace" do
      assert { slide_from("#    hi there    ").title == "hi there" }
    end
  end

  describe "renders deck.js-compatible HTML" do
    it "leaves a solo H1 as an H1" do
      html = slide_from(<<-MARKDOWN).to_pretty
# foo
      MARKDOWN
      expected_html = <<-HTML
<section class="slide" id="foo">
<h1>foo</h1>
</section>
      HTML
      assert { html == expected_html }
    end

    it "converts a non-solo H1 into an H2 for deck.js style compatibility)" do
      html = slide_from(<<-MARKDOWN).to_pretty
# foo
* bar
* baz
      MARKDOWN
      expected_html = <<-HTML
<section class="slide" id="foo">
<h2>foo</h2>

<ul>
<li>bar</li>
<li>baz</li>
</ul>
</section>
      HTML
      assert { html == expected_html }
    end

    it "with only a underline-style header, leaving a solo H1 as an H1" do
      html = slide_from(<<-MARKDOWN).to_pretty
foo
===
      MARKDOWN
      expected_html = <<-HTML
<section class="slide" id="foo">
<h1>foo</h1>
</section>
      HTML
      assert { html == expected_html }
    end

    it "converts a non-solo underline-style H1 into an H2 for deck.js style compatibility)" do
      html = slide_from(<<-MARKDOWN).to_pretty
foo
===
* bar
* baz
      MARKDOWN
      expected_html = <<-HTML
<section class="slide" id="foo">
<h2>foo</h2>

<ul>
<li>bar</li>
<li>baz</li>
</ul>
</section>
      HTML
      assert { html == expected_html }
    end


  end

  describe "slide classes" do
    it "are added to the section element" do
      html = slide_from(<<-MARKDOWN).to_pretty
<!SLIDE fancy pants>
# foo
* bar
* baz
      MARKDOWN
      expected_html = <<-HTML
<section class="slide fancy pants" id="foo">
<h2>foo</h2>

<ul>
<li>bar</li>
<li>baz</li>
</ul>
</section>
      HTML
      assert { html == expected_html }
    end
  end

  describe "!VIDEO" do
    it "embeds a YouTube video" do
      html = slide_from(<<-MARKDOWN).to_pretty
# foo
<!VIDEO xyzzy>
* bar
      MARKDOWN
      expected_html = <<-HTML
<section class="slide" id="foo">
<h2>foo</h2>

<iframe class="video youtube" type="text/html" width="640" height="390" src="http://www.youtube.com/embed/xyzzy" frameborder="0"></iframe>

<ul>
<li>bar</li>
</ul>
</section>
      HTML
      assert { html == expected_html }
    end
  end

  describe "==" do
    it "a slide is equal to itself" do
      s = slide_from("# hello")
      assert { s == s }
    end

    it "a slide is equal to a clone of itself" do
      s1 = slide_from("# hello")
      s2 = slide_from("# hello")
      assert { s1 == s2 }
    end

    it "a slide is not equal to a different slide" do
      s1 = slide_from("# hello")
      s2 = slide_from("# goodbye")
      deny { s1 == s2 }
    end
  end
 end
end
