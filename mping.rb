#!/usr/bin/env ruby

require 'win32ole'

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

def ping(ip,args)
  cmd = WIN32OLE.new("Wscript.Shell")
  cmd.run "ping -t #{args.join(' ')} #{ip}"
end

args = ARGV

ip_args = args.select{|x| x.is_a_ip? or x.is_a_ip_range? }
args = args - ip_args
ip_list ||= []
ip_args.each do |ip_arg|
  ip_list << IpRange.new(ip_arg).ip_list
end

ip_list.flatten.each do |ip|
  ping(ip,args)
end



