#!/usr/bin/env ruby

require 'net/http'
require 'uri'

def make_request(url)
  uri = URI.parse(url)
  Net::HTTP.get(uri)
end

def get_download_count(plugin_name)
  url = "http://wordpress.org/extend/plugins/#{plugin_name}/"
  response = make_request(url)
  downloads = response.scan(/<meta itemprop="interactionCount" content="UserDownloads:(\d+)"\/>/i).flatten[0]
  downloads
end

def get_list_from_grep_result(file)
  names = []
  File.open(file, 'r') do |file_handle|
    file_handle.each_line do |line|
      next if line =~ /Binary file .* matches/
      name = line.scan(/^([^\/\s<>]+)\/[^\s:]+?:\s?/).flatten[0]
      next if name.nil? or name.empty?
      name.strip!
      names << name unless names.include?(name)
    end
  end
  names
end

def write_list(path, input)
  File.open(path, 'w') do |file|
    input.each do |i|
      file.puts "Plugin: #{i[0]}, Downloads: #{i[1]}"
    end
  end
end

plugins = get_list_from_grep_result('results.txt')

hash = {}
plugins.each do |p|
  downloads = get_download_count(p) || 0
  puts "Plugin: #{p}, Downloads: #{downloads}"
  hash[p] = downloads.to_i
end
sorted = hash.sort_by{|k,v| v}.reverse
write_list('output.txt', sorted)
