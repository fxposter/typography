# encoding: utf-8
require "typographer/helper"

module TypographerHelper
  mattr_reader :registry

  def self.register(name, elements)
    @@registry ||= {}
    @@registry[name.to_sym] = get_parsers elements
  end

  def self.parse(string, type = :default)
    @@registry[type].each do |parser|
      string = parser.parse string
    end

    string.html_safe
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
        cls = TypographerHelper::Parsers.name + '::' + element.to_s.split("::").last
        #Fails here of class doesn`t exist
        cls = cls.constantize
        element = cls.new
      end

      result.push element
    end

    result
  end
end

require "typographer/parsers/basic"
require "typographer/parsers/simple_format"

TypographerHelper.register(:default, [TypographerHelper::Parsers::Basic])

