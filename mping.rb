#!/usr/bin/env ruby
require 'win32ole'
require 'pp'
args = ARGV

def command(ip,args)
  cmd = WIN32OLE.new("Wscript.Shell")
  cmd.run "ping -t #{args.join(' ')} #{ip}"
end

def get_ip(args)
  ips = []
  reg_ip = /\d+\.\d+\.\d+\.\d+/
  reg_ip_range = /(\d+-*\d+|\d+)\.(\d+-*\d+|\d+)\.(\d+-*\d+|\d+)\.(\d+-*\d+|\d+)/
  reg_ip_few = /{*[\d+,*]+}*\.{*[\d+,*]+}*\.{*[\d+,*]+}*\.{*[\d+,*]+}*/

  args.each do |arg|
    ips << arg if arg =~ reg_ip
    ips << arg if arg =~ reg_ip_range
    ips << arg if arg =~ reg_ip_few
  end

  args.delete_if do |arg|
    arg =~ reg_ip || arg =~ reg_ip_range || arg =~ reg_ip_few
  end

  ips = parse_ip(ips.uniq)
  while ips.select{|ip| ip =~ /^\d+\.\d+\.\d+\.\d+$/}.size < ips.size
    ips = parse_ip(ips.uniq)
  end
  [ips.uniq,args]
end

def parse_ip(ips)
  ip_arr = []
  ips.each do |ip|
    if ip =~ /^\d+\.\d+\.\d+\.\d+$/
      ip_arr << ip
    else
      ip_fs = ip.split('.')
      ip_fs.each do |ip_f|
        case ip_f
        when /(\d+)-(\d+)/
          ($1..$2).each do |x|
            ip_arr << ip.sub(/(\d+)-(\d+)/,x)
          end
        when /{([\d+,*]+)}/
          xx = $1.split(',')
          xx.each do |x|
            ip_arr << ip.gsub(/{([\d+,*]+)}/,x)
          end
        end
      end
    end
  end
  ip_arr
end

ips,args = get_ip(args)

ips.each do |ip|
  command(ip,args)
end
