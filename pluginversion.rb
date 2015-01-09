#!/usr/bin/env ruby
# encoding: UTF-8

require 'open-uri'
require 'net/http'

def outputinfo(plugin)

  # Get the correct readme filename
  readme_file  = ""
  regex_readme = /href=\"(.+)\"\>readme.txt/i

  url = "http://plugins.svn.wordpress.org/#{plugin}/trunk/"
  res = Net::HTTP.get_response(URI.parse(url.to_s))

  # Output data if a readme file is found.
  if res.code == '200'
    f = open(url)
    f.each_line do |line|
      readme_file = regex_readme.match(line)[1] if line =~ regex_readme
    end

    url = "http://plugins.svn.wordpress.org/#{plugin}/trunk/#{readme_file}"
    res = Net::HTTP.get_response(URI.parse(url.to_s))
    f = open(url)

    version  = ""
    tested   = ""
    requires = ""

    regex1 = /stable tag:\s*(.+)/i
    regex2 = /tested up to:\s*(.+)/i
    regex3 = /requires at least:\s*(.+)/i

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

