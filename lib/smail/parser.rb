class SMail

private

  # We are liberal in what we accept.
  PATTERN_CRLF			= "\n\r|\r\n|\n|\r" #:nodoc:

  RE_CRLF           = Regexp.new(PATTERN_CRLF,      Regexp::MULTILINE) #:nodoc:

  def split_head_from_body(text)
    # The body is a sequence of characters after the header separated by an empty line
    if text =~ /(.*?(#{PATTERN_CRLF}))\2(.*)/m
      return $1, $3 || '', $2
    else  # The body is, of course, optional.
      return text, "", "\r\n"
    end
  end

  def read_header(head)
    headers = headers_to_list(head)

    SMail::Header.new(headers, self)
  end

  # Header fields are lines composed of a field name, followed by a colon (":"),
  # followed by a field body, and terminated by CRLF.  A field name MUST be
  # composed of printable US-ASCII characters (i.e., characters that have values
  # between 33 and 126, inclusive), except colon.  A field body may be composed
  # of any US-ASCII characters, except for CR and LF.

  # However, a field body may contain CRLF when used in header "folding" and
  # "unfolding" as described in section 2.2.3.

  def headers_to_list(head)
    headers = Array.new

    head.split(RE_CRLF).each do |line|
      if line.gsub!(/^\s+/, '') or line !~ /([^:]+):\s*(.*)/
        # This is a continuation line, we fold it on to the end of the previous header
        next if headers.empty? # Most likely an mbox From line, skip it

        #headers.last.last << (headers.last.empty? ? line : " #{line}")
        if headers.last.empty?
          headers.last.last << line
        else
          headers.last.last << " #{line}"
        end
      else
        headers << [$1, $2]
      end
    end

    headers
  end
end
