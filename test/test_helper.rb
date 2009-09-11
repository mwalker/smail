require 'test/unit'

module Test #:nodoc: all
  class Unit::TestCase
    def email_text_from_file(name)
      IO.read(File.dirname(__FILE__) + "/email/#{name}.txt")
    end
  end
end

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'smail'

