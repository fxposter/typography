# encoding: utf-8
module TypographyHelper
  class Core

    def initialize(str, options = {})
      @source  = str
      @out     = str.dup
      @options = options.merge({})
    end

    def typography
      #apostrophe
      @out.gsub!(/(\w)'(\w)/, '\1&#146;\2')
      @out.gsub!(/\“/,'&#132;')
      @out.gsub!(/\”/,'&#147;')
      #russian quotes
      @out = replace_quotes '&laquo;', '&raquo;', '&#132;', '&#147;', 'а-яА-Я'

      #english quotes
      @out = replace_quotes

      #mdash
      @out.gsub!(/--/, '&mdash;')
      @out.gsub!(/(\w|;|,)\s+(—|–|-)\s*(\w)/, '\1&nbsp;&mdash; \3')
      @out.gsub!(/\s+&mdash;/, '&nbsp;&mdash;')

      #nobr
      #around dash-separated words (что-то)
      @out.gsub!(/(^|\s)((\w|0-9){1,3})-((\w|0-9){1,3})($|\s)/, '\1<span class="nobr">\2-\4</span>\6')
      #1980-x почему-то
      @out.gsub!(/(^|\s)((\w|0-9)+)-((\w|0-9){1,3})($|\s)/, '\1<span class="nobr">\2-\4</span>\6')

      #non brake space
      @out.gsub!(/(^|\s|\()(\w{1,2})\s+([^\s])/i, '\1\2&nbsp;\3')
      @out.gsub!(/(^|\s|\()&([A-Za-z0-9]{2,8}|#[\d]*);(\w{1,2})\s+([^\s])/i, '\1&\2;\3&nbsp;\4') #entities
      @out.gsub!(/(&nbsp;|&#161;)(\w{1,2})\s+([^\s])/i, '\1\2&nbsp;\3\4')

      @out
    end


  #  def replace_quotes!(*args)
  #    @source.replace self.replace_quotes(*args)
  #  end

    def replace_quotes(left1 = '&#147;', right1 = '&#148;', left2 = '&#145;', right2 = '&#146;', letters = 'a-zA-Z')
      str = @out.dup

      replace_quotes = lambda do
        old_str = str.dup
        str.gsub!(Regexp.new("(\"|\'|&quot;)((\s*<[^>]+>\s*)?[#{letters}]((<[^>]+>)|.)*?[^\\s])\\1", Regexp::MULTILINE | Regexp::IGNORECASE)) do |match|
          inside, before, after = $2, $`, $'
          if after.match(/^([^<]+>|>)/) || before.match(/<[^>]+$/) #inside tag
            match
          else
            "#{left1}#{inside}#{right1}"
          end
        end
        old_str != str
      end
      while replace_quotes.call do end

      # second level
      str.gsub!('&', "\0&")
      replace_second_level_quotes = lambda do
        str.gsub! Regexp.new("#{left1}([^\0`]*)\0#{left1}([^\0]*)\0#{right1}", Regexp::MULTILINE | Regexp::IGNORECASE) do
          "#{left1}#{$1}#{left2}#{$2}#{right2}"
        end
      end
      while replace_second_level_quotes.call do end
      str.gsub!("\0", '')

      str
    end
  end
end
