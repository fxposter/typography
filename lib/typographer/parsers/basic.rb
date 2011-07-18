# encoding: utf-8
module TypographerHelper
  module Parsers
    class Basic
      def initialize(options = {})
        @options = options.merge({})
      end

      def parse(string)
        #apostrophe
        # Here comes 1.9 compatibility.
        # My eyes bleed !!

        string= string.gsub(/“/,'&#132;')
        string.gsub!(/”/,'&#147;')

        if Regexp.instance_methods.include?(:encoding)
          string.gsub!(/(\p{Word})'(\p{Word})/, '\1&#146;\2')

          #russian quotes
          string = replace_quotes string, '&laquo;', '&raquo;', '&#132;', '&#147;', 'а-яА-Я'

          #english quotes
          string = replace_quotes string

          #mdash
          string.gsub!(/--/, '&mdash;')
          string.gsub!(/(\p{Word}|;|,)\s+(—|–|-)\s*(\p{Word})/, '\1&nbsp;&mdash; \3')
          string.gsub!(/\s+&mdash;/, '&nbsp;&mdash;')

          #nobr
          #around dash-separated words (что-то)
          string.gsub!(/(^|\s)((\p{Word}|0-9){1,3})-((\p{Word}|0-9){1,3})($|\s)/, '\1<span class="nobr">\2-\4</span>\6')
          #1980-x почему-то
          string.gsub!(/(^|\s)((\p{Word}|0-9)+)-((\p{Word}|0-9){1,3})($|\s)/, '\1<span class="nobr">\2-\4</span>\6')

          #non brake space
          string.gsub!(/(^|\s|\()(\p{Word}{1,2})\s+([^\s])/i, '\1\2&nbsp;\3')
          string.gsub!(/(^|\s|\()&([A-Za-z0-9]{2,8}|#[\d]*);(\p{Word}{1,2})\s+([^\s])/i, '\1&\2;\3&nbsp;\4') #entities
          string.gsub!(/(&nbsp;|&#161;)(\p{Word}{1,2})\s+([^\s])/i, '\1\2&nbsp;\3\4')
        else
          string.gsub!(/(\w)'(\w)/, '\1&#146;\2')

          #russian quotes
          string = replace_quotes string, '&laquo;', '&raquo;', '&#132;', '&#147;', 'а-яА-Я'

          #english quotes
          string = replace_quotes string

          #mdash
          string.gsub!(/--/, '&mdash;')
          string.gsub!(/(\w|;|,)\s+(—|–|-)\s*(\w)/, '\1&nbsp;&mdash; \3')
          string.gsub!(/\s+&mdash;/, '&nbsp;&mdash;')

          #nobr
          #around dash-separated words (что-то)
          string.gsub!(/(^|\s)((\w|0-9){1,3})-((\w|0-9){1,3})($|\s)/, '\1<span class="nobr">\2-\4</span>\6')
          #1980-x почему-то
          string.gsub!(/(^|\s)((\w|0-9)+)-((\w|0-9){1,3})($|\s)/, '\1<span class="nobr">\2-\4</span>\6')

          #non brake space
          string.gsub!(/(^|\s|\()(\w{1,2})\s+([^\s])/i, '\1\2&nbsp;\3')
          string.gsub!(/(^|\s|\()&([A-Za-z0-9]{2,8}|#[\d]*);(\w{1,2})\s+([^\s])/i, '\1&\2;\3&nbsp;\4') #entities
          string.gsub!(/(&nbsp;|&#161;)(\w{1,2})\s+([^\s])/i, '\1\2&nbsp;\3\4')
        end

        string
      end

      def replace_quotes(string, left1 = '&#147;', right1 = '&#148;', left2 = '&#145;', right2 = '&#146;', letters = 'a-zA-Z')
        str = string.dup

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
end
