#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'csv'
require 'optparse'

class NilClass
  def width
    0
  end
end

class String
  def width
    each_char.map {|c| c.bytesize == 1 ? 1 : 2}.inject(:+)
  end

  def mb_ljust(_width, _padding=' ')
    padding_size = [0, _width - width].max
    self + _padding * padding_size
  end
end

class Array
  def lrjoin(separator='')
    separator + self.join(separator) + separator
  end
end

class CSV::Table
  def to_ascii
    widths    = headers.map {|header| 2 + ([header] + self[header]).map(&:width).max }
    separator = widths.map {|width| '-' * width}.lrjoin('+')
    (
      [separator, headers.pretty_row(widths), separator] + \
      map {|row| row.pretty_row(widths)} + [separator]
    ).join("\n")
  end
end

module Enumerable
  def pretty_row(widths)
    widths.each_with_index.map {|width, i| " #{self[i]} ".mb_ljust(width)}.lrjoin('|')
  end
end

if __FILE__ == $0
  options = {:format => 'csv', :col_sep => ','}
  OptionParser.new.instance_eval do
    on("--format [FORMAT=#{options[:format]}]") {|v|
      case options[:format] = v
      when 'tsv'
        options[:col_sep] = "\t"
      end
    }
    parse(ARGV)
  end

  table     = CSV.parse(STDIN.read, :col_sep => options[:col_sep], :headers => true)
  puts table.to_ascii

  exit 0
end

