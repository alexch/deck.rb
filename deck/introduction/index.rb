class Index < Erector::Widget
  def content
    rawtext '<!DOCTYPE html>'
    rawtext '<!--[if lt IE 7]>'
    html :class => 'no-js ie6', :lang => 'en' do
      rawtext '<![endif]-->'
      rawtext '<!--[if IE 7]>'
      html :class => 'no-js ie7', :lang => 'en' do
        rawtext '<![endif]-->'
        rawtext '<!--[if IE 8]>'
        html :class => 'no-js ie8', :lang => 'en' do
          rawtext '<![endif]-->'
          rawtext '<!--[if gt IE 8]>'
          rawtext '<!-->'
          html :class => 'no-js', :lang => 'en' do
            rawtext '<!--<![endif]-->'
            head do
              meta :charset => 'utf-8' do
                meta 'http-equiv' => 'X-UA-Compatible', :content => 'IE=edge,chrome=1' do
                  title do
                    text 'Getting Started with deck.js'
                  end
                  meta :name => 'description', :content => 'A jQuery library for modern HTML presentations' do
                    meta :name => 'author', :content => 'Caleb Troughton' do
                      meta :name => 'viewport', :content => 'width=1024, user-scalable=no' do
                        rawtext '<!-- Core and extension CSS files -->'
                        link :rel => 'stylesheet', :href => '../core/deck.core.css' do
                          link :rel => 'stylesheet', :href => '../extensions/goto/deck.goto.css' do
                            link :rel => 'stylesheet', :href => '../extensions/menu/deck.menu.css' do
                              link :rel => 'stylesheet', :href => '../extensions/navigation/deck.navigation.css' do
                                link :rel => 'stylesheet', :href => '../extensions/status/deck.status.css' do
                                  link :rel => 'stylesheet', :href => '../extensions/hash/deck.hash.css' do
                                    rawtext '<!-- Theme CSS files (menu swaps these out) -->'
                                    link :rel => 'stylesheet', :id => 'style-theme-link', :href => '../themes/style/web-2.0.css' do
                                      link :rel => 'stylesheet', :id => 'transition-theme-link', :href => '../themes/transition/horizontal-slide.css' do
                                        rawtext '<!-- Custom CSS just for this page -->'
                                        link :rel => 'stylesheet', :href => 'introduction.css' do
                                          script :src => '../modernizr.custom.js' do
                                          end
                                        end
                                        body :class => 'deck-container' do
                                          section :class => 'slide', :id => 'title-slide' do
                                            h1 do
                                              text 'Getting Started with deck.js'
                                            end
                                          end
                                          a :href => '#', :class => 'deck-prev-link', :title => 'Previous' do
                                            text '←'
                                          end
                                          a :href => '#', :class => 'deck-next-link', :title => 'Next' do
                                            text '→'
                                          end
                                          p :class => 'deck-status' do
                                            span :class => 'deck-status-current' do
                                            end
                                            text '/'
                                            span :class => 'deck-status-total' do
                                            end
                                          end
                                          form :action => '.', :method => 'get', :class => 'goto-form' do
                                            label :for => 'goto-slide' do
                                              text 'Go to slide:'
                                            end
                                            input :type => 'text', :name => 'slidenum', :id => 'goto-slide', :list => 'goto-datalist' do
                                              datalist :id => 'goto-datalist' do
                                              end
                                              input :type => 'submit', :value => 'Go' do
                                              end
                                              
                                              
                                              a :href => '.', :title => 'Permalink to this slide', :class => 'deck-permalink' do
                                                text '#'
                                              end
                                              rawtext '<!-- Grab CDN jQuery, with a protocol relative URL; fall back to local if offline -->'
                                              script :src => '//ajax.aspnetcdn.com/ajax/jQuery/jquery-1.7.min.js' do
                                              end
                                              script do
                                                text 'window.jQuery || document.write(\''
                                                script :src => '../jquery-1.7.min.js' do
                                                  text '<\/script>\')'
                                                end
                                                rawtext '<!-- Deck Core and extensions -->'
                                                script :src => '../core/deck.core.js' do
                                                end
                                                script :src => '../extensions/hash/deck.hash.js' do
                                                end
                                                script :src => '../extensions/menu/deck.menu.js' do
                                                end
                                                script :src => '../extensions/goto/deck.goto.js' do
                                                end
                                                script :src => '../extensions/status/deck.status.js' do
                                                end
                                                script :src => '../extensions/navigation/deck.navigation.js' do
                                                end
                                                rawtext '<!-- Specific to this page -->'
                                                script :src => 'introduction.js' do
                                                end
                                              end
                                            end
  end
end
