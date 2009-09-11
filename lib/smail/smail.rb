# SMail
#
# A very simple library for parsing email messages.
#
# Based on Email::Simple from CPAN
#
# No decoding of any fields or the body is attempted, see SMail::MIME.

class SMail
  # The line ending found in this email.
  attr_reader :crlf
  # The body text of the email.
  attr_accessor :body

  def initialize(text = '')
    head, @body, @crlf = split_head_from_body(text)

    @head = read_header(head)
  end

  # Returns the first value for the named header
  def header(field)
    @head.header(field)
  end

  # Returns an array containing every value for the named header, for the first instance
  # see header
  def headers(field)
    @head.headers(field)
  end

  # Sets the header to contain the given data, if there is more than one existing header
  # the extra headers are removed.
  def header_set(field, line)
    headers_set(field, line).first
  end

  # Sets the headers to contain the given data, passing in multiple lines results in
  # multiple headers and order is retained.
  def headers_set(field, *lines)
    @head.header_set(field, lines)
  end

  def header=(header) #:nodoc:
    # FIXME: takes a string and splits it??
  end

  # Returns the list of header names currently in the message. The order is not significant.
  def header_names
    @head.header_names
  end

  # Returns a list of pairs describing the contents of the header.
  def header_pairs
    @head.header_pairs
  end

  def to_s #:nodoc:
    @head.to_s + @crlf + @body
  end
end
