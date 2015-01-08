#!/usr/bin/env ruby
# encoding: UTF-8

require 'open-uri'
require 'net/http'

def outputinfo(plugin)

  # Possible readme filenames
  readme = ["readme.txt", "README.txt", "README.TXT", "Readme.txt", "ReadMe.txt"]
  i = 0

  # Try to find a readme file
  while i < readme.count do
    url = "http://plugins.svn.wordpress.org/#{plugin}/trunk/#{readme[i]}"
    res = Net::HTTP.get_response(URI.parse(url.to_s))
    break if res.code == '200' # exit loop when a file is found
    i += 1
  end

  # Output data if a readme file is found.
  if res.code == '200'
    f = open(url)

    version  = ""
    tested   = ""
    requires = ""

    regex1 = /[S|s]table tag: (.*)/
    regex2 = /[T|t]ested up to: (.*)/
    regex3 = /[R|r]equires at least: (.*)/

    f.each_line do |line|
      version  = regex1.match(line)[1] if line =~ regex1
      tested   = regex2.match(line)[1] if line =~ regex2
      requires = regex3.match(line)[1] if line =~ regex3
    end

    puts "URL         : #{url}"
    puts "Plugin      : #{plugin}"
    puts "Version     : #{version}"
    puts "Requires WP : #{requires}"
    puts "Tested up to: #{tested}"
    puts "Last update : #{f.last_modified.strftime("%Y-%m-%d")}"

  else
    puts "No plugin found"
   end
end

if ARGV[0]
   outputinfo(ARGV[0])
else 
   puts "No argument supplied"
end

