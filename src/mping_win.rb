#!/usr/bin/env ruby

$LOAD_PATH.unshift File.join(File.dirname(__FILE__))
require 'win32ole'
require 'lib/mping'
def ping(ip,args)
  cmd = WIN32OLE.new("Wscript.Shell")
  command =  "ping -t #{args.join(' ')} #{ip}"
  cmd.run command
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



