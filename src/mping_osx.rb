#!/usr/bin/env ruby

$LOAD_PATH.unshift File.join(File.dirname(File.realpath(__FILE__)))

require 'lib/mping'

def ping(ip,args)
  command =  "ping #{args.join(' ')} #{ip}"
  cmd = <<-EOF.gsub(/^\s+|/,'')
    osascript -e 'tell application "Terminal"' -e 'do script "#{command}"' -e 'end tell'
  EOF
  system cmd
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



