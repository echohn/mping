#!/usr/bin/env ruby

class String
  def is_a_ip?
    IP.is_a_ip? self
  end

  def is_a_ip_range?
    IpRange.is_a_ip_range? self
  end
end

class IP
  def self.is_a_ip?(string)
    !!( string =~ /^\d+\.\d+\.\d+\.\d+$/ && string.split('.').map(&:to_i).select{|x|x < 256 && x >= 0}.size == 4 )
  end
end

class IpRange

  class << self

    def is_a_ip_range?(string)
      @fields = string.split('.')
      !!( length_right? && content_right? )
    end

    private
    def length_right?
      !!( @fields.size == 4 )
    end

    def content_right?
      right_count = @fields.select do |x|
        /^\d+$/.match(x) || /^\d+-\d+$/.match(x) || /^\{[\d+,*]+\}$/.match(x)
      end.size
      !!( right_count == 4 )
    end

  end

  attr_reader :ip_list

  def initialize(string)
    @ip_list = []
    @ip_range = string
    insert_ip_list @ip_range
    until @ip_list.select(&:is_a_ip?).size == @ip_list.size
      old_list = @ip_list.dup
      @ip_list = []
      old_list.each do |ip_range|
        insert_ip_list ip_range
      end
    end
  end

  private
  def insert_ip_list(ip_range)
    if ip_range.is_a_ip?
      @ip_list << ip_range
      return nil
    end
    fields = ip_range.split('.')
    fields.each do |f|
      case f
      when  /^(\d+)-(\d+)$/
        ($1..$2).each do |num|
          ip = ip_range.sub(f,num)
          @ip_list << ip unless @ip_list.include? ip
        end
      when /^\{([\d+,*]+)\}$/
        $1.split(',').each do |num|
          ip = ip_range.sub(f,num)
          @ip_list << ip unless @ip_list.include? ip
        end
      end
    end
  end
end





