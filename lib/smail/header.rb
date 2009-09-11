class SMail
  class Header #:nodoc: all
    attr_reader :crlf, :head

    def initialize(headers, smail)
      @crlf = smail.crlf || "\r\n"

      @order = Array.new
      @head = Hash.new
      headers.each do |header|
        @order << header.first
        if @head[header.first].nil?
          @head[header.first] = Array.new
        end
        @head[header.first] << header.last
      end

      @header_names = @head.collect {|header,value| [header.downcase, header] }
    end

    def to_s #:nodoc:
      header_pairs.collect {|pair| fold(pair.join(": "))}.join(@crlf) + @crlf
    end

    def header_names
      @header_names.collect {|pair| pair.last }
    end

    def header_pairs
      headers = []
      seen = {}
      seen.default = -1
      @order.each do |header|
        headers << [header, @head[header][seen[header] += 1]]
      end
        
      headers
    end

    def header(field)
      return unless names = @header_names.assoc(field.downcase)
      headers(field).first
    end

    def headers(field)
      return unless names = @header_names.assoc(field.downcase)
      
      @head[names.last]
    end

    def header_set(field, lines)
      unless field =~ /^[\x21-\x39\x3b-\x7e]+$/
        raise(ArgumentError, "Field name contains illegal characters")
      end
      unless field =~ /^[\w-]+$/
        raise(ArgumentError, "Field name is not limited to hyphens and alphanumerics")
      end

      old_length = 0
      if @header_names.assoc(field.downcase)
        old_length = @head[@header_names.assoc(field.downcase).last].length
      else
        @header_names << [field.downcase, field]
      #  @order << field # FIXME: add new fields onto the end
      end

      @head[@header_names.assoc(field.downcase).last] = lines
      if lines.length < old_length
        # Remove the last x instances of field from @order
        headers_to_remove = old_length - lines.length
        headers_seen = 0
        @order.collect! {|field_name|
          if field_name.downcase == field.downcase
            headers_seen += 1
            next if headers_seen > headers_to_remove
          end
          field_name
        }.compact!
      elsif lines.length > old_length
        # Add x instances of field to the end of @order
        @order = @order + ([field] * (lines.length - old_length))
      end

      headers(field)
    end

private

    def fold(line)
      # FIXME: this needs to actually fold the line
      line.gsub( /^(.{1,78})(\s+|$)/ ){ $2.empty? ? $1 : "#{$1}#{@crlf}\t" }
    end

  end
end
