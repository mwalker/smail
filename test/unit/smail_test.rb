require File.dirname(__FILE__) + "/../test_helper"

class SMailTest < Test::Unit::TestCase #:nodoc: all

  def test_harness
    assert !email_text_from_file('simple').empty? # we can load an email from a file
  end

  def test_parsing
    s = SMail.new(email_text_from_file('simple'))

    assert s.body
    assert s.crlf
  end

  def test_line_endings_lf
    s = SMail.new(email_text_from_file('lf'))

    assert_equal "\n", s.crlf
  end

  def test_line_endings_cr
    s = SMail.new(email_text_from_file('cr'))

    assert_equal "\r", s.crlf
  end

  def test_line_endings_crlf
    s = SMail.new(email_text_from_file('crlf'))

    assert_equal "\r\n", s.crlf
  end

  def test_line_endings_lfcr
    s = SMail.new(email_text_from_file('lfcr'))

    assert_equal "\n\r", s.crlf
  end

  def test_header_names
    s = SMail.new(email_text_from_file('simple'))

    assert_equal \
      ["Content-Type", "Date", "From", "Message-Id", "Mime-Version", "Subject", "To"], \
        s.header_names.sort 
  end

  def test_header
    s = SMail.new(email_text_from_file('simple'))

    assert_nil s.header('non-existent')
    assert_equal "<8603715@mail.example.com>", s.header('message-id')
    assert_equal "<8603715@mail.example.com>", s.header('Message-Id') # try different
    assert_equal "<8603715@mail.example.com>", s.header('Message-ID') # cases as well
  end

  def test_headers
    s = SMail.new(email_text_from_file('simple'))

    assert_nil s.header('non-existent')
    assert_equal ["<8603715@mail.example.com>"], s.headers('message-id')
    assert_equal ["<8603715@mail.example.com>"], s.headers('Message-Id') # try different
    assert_equal ["<8603715@mail.example.com>"], s.headers('Message-ID') # cases as well

    s = SMail.new(email_text_from_file('multi-received'))

    assert_equal 2, s.headers('Received').length
  end

  def test_header_set
    s = SMail.new(email_text_from_file('simple'))

    assert_raise(ArgumentError) { s.header_set('!@#$%', 'Irrelevant') }
    assert_raise(ArgumentError) { s.header_set("\001isbad", 'Irrelevant') }

    old_from = s.header('from')
    new_from = "\"New From\" <mew@example.com>"
    
    assert_equal new_from, s.header_set('From', new_from) # returns the new value
    assert_equal new_from, s.header('from')                 # and it still has it

    assert_equal [old_from], s.headers_set('From', old_from) # now set it back
    assert_equal [old_from], s.headers('from')              # and it still has it

    assert_equal [new_from, old_from], s.headers_set('From', new_from, old_from)
    assert_equal [new_from, old_from], s.headers('From')

    assert_equal [old_from], s.headers_set('From', old_from) # now set it back
    assert_equal old_from, s.header('from')              # and it still has it

    # FIXME: above does not actually test that @order is set correctly
  end

  def test_body
    s = SMail.new(email_text_from_file('simple'))

    assert_equal "A simple boring email.\n", s.body
  end

  def test_body=
    s = SMail.new(email_text_from_file('simple'))

    assert_equal "A simple boring email.\n", s.body

    s.body = "A new simple boring email.\n"

    assert_equal "A new simple boring email.\n", s.body
  end
end

