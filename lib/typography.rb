require "typography/helper"
require "typography/core"

module TypographyHelper
  mattr_reader :registry
  
  def self.register(name, elements)
    @@registry ||= {}
    @@registry[name.to_sym] = get_parsers elements
  end
  
  def self.parse(string, type = :default)
    @@registry[type].each do |parser|
      string = parser.parse string
    end
    
    string
  end

  module Parsers
  end

  private
  #It can get as parameter:
  # => Class
  # => Symbol
  # => Object
  def self.get_parsers(elements)
    result = []
    
    elements.each do |element|
      if (element.is_a? Class)
        element = element.new
      elsif (element.is_a? String)
        cls = TypographyHelper::Parsers.name + '::' + element.to_s.split("::").last
        #Fails here of class doesn`t exist
        cls = cls.constantize
        element = cls.new
      end
      
      result.push element
    end
    
    result
  end
end

require "typography/parsers/basic"
require "typography/parsers/simple_format"

TypographyHelper.register(:default, [TypographyHelper::Parsers::Basic])

#TypographyHelper.register(:article, [TypographyHelper::Parsers::Basic, TypographyHelper::Parsers::AddToLastParagraph('<img src="sdfasdfasdfsd" />')])
#ty(@article.text, :article)

