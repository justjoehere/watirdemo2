require 'watir-webdriver'
require 'rspec/expectations'
require 'pry'
require 'pry-stack_explorer'
require 'pry-byebug'
include RSpec::Matchers

# run bundle exec script.rb
def setup
  @b = Watir::Browser.new :chrome
end

def teardown
  @b.quit
end

def run
  setup
  yield
  teardown
end

location = false
stale = false
wait = false
textarea = true

run do
  # element not found error message
  if location
    @b.goto 'http://www.google.com'
    @b.text_field(title: 'Search2').set 'Hello World!'
    @b.button(type: 'submit').click

    @b.goto 'http://the-internet.herokuapp.com/iframe'
    @b.iframe(id: 'mce_0_ifr').body(id: 'tinymce2').wait_until_present
  end
  if stale
    Watir::always_locate = false
    @b.goto 'file://c:\casnc\repos\watirdemo2\pagereload.html'
    element = @b.button(id: 'refresh')
    i = 0
    while i < 50
      begin
        element.click
      rescue
        puts 'Element stale'
      end
      i += 1
    end
  end
  if textarea
    # the old way you get a warning
    @b.goto 'http://www.w3schools.com/tags/tryit.asp?filename=tryhtml_textarea'
    @b.iframe(id: 'iframeResult').textarea(index: 0).set 'This is a textarea'
    sleep 5
    @b.iframe(id: 'iframeResult').text_field(index: 0).set 'This is a text fieldThis is a text fieldThis is a text field'
    sleep 5
  end
end