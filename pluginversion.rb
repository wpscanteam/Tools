#!/usr/bin/env ruby
# encoding: UTF-8

require 'open-uri'
require 'net/http'

plugin = ARGV[0]

unless plugin
  puts 'No argument supplied'
  exit(1)
end

url = "http://plugins.svn.wordpress.org/#{plugin}/trunk/"
res = Net::HTTP.get_response(URI.parse(url))

# Output data if the trunk page is found.
if res.code == '200'
  readme_file = res.body[/href="(.+)">readme.txt/i, 1]

  url = "http://plugins.svn.wordpress.org/#{plugin}/trunk/#{readme_file}"
  f   = open(url)

  version  = ''
  tested   = ''
  requires = ''

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
  puts "Last update : #{f.last_modified.strftime('%Y-%m-%d')}"
else
  puts 'No plugin found'
end
