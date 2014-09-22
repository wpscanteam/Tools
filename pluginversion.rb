#!/usr/bin/env ruby
# encoding: UTF-8

require 'open-uri'
require 'net/http'


def outputinfo(plugin)

   url = "http://plugins.svn.wordpress.org/"+plugin+"/trunk/readme.txt"
   res = Net::HTTP.get_response(URI.parse(url.to_s))

   if res.code == "200"
      f = open(url)

      puts "URL    : #{url}"
      puts "Plugin : #{plugin}"

      regex = /[S|s]table tag: ([\d\.]{1,10})/
      f.each_line do |line|
         puts "Version: #{regex.match(line)[1]}" if line =~ regex
      end
      puts "Date   : #{f.last_modified.strftime("%Y-%m-%d")}"
   else
      puts "No plugin found"
   end
end

if ARGV[0]
   outputinfo(ARGV[0])
else 
   puts "No argument supplied"
end

