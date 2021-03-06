#!/usr/bin/env ruby

require 'nokogiri'
require 'open-uri'

if ARGV.size != 2 || ARGV[0] == "--help" || ARGV[0] == "-h"
	STDERR.puts ""
	STDERR.puts "Lightly post-processes draft minutes as generated by RRSAgent"
	STDERR.puts "into the format suitable for inclusion in the browserext repos"
	STDERR.puts ""
	STDERR.puts "Syntax:"
	STDERR.puts "\tminutes_cleaner.rb <input_file_or_url> <date>"
	STDERR.puts ""
	STDERR.puts "Example:"
	STDERR.puts "\tscripts/minutes_cleaner.rb https://www.w3.org/2042/01/25-browserext-minutes.html 2042-01-25"


	exit 1
end

@doc = Nokogiri::HTML.parse( open(ARGV[0]).read)

@doc.css(".diagnostics").remove
@doc.css("hr + address").remove
@doc.css("body > p:first-of-type").remove
@doc.css("body > h1").remove
@doc.css("body > h2:first-of-type").remove
@doc.css("p:empty").remove
@doc.css("hr:last-of-type").remove

File.open("#{__dir__}/../_minutes/#{ARGV[1]}.html", "w") do |f_out|
	f_out.puts "---"
	f_out.puts "title: #{@doc.css("title").inner_text.sub('--','—')}"
	f_out.puts "date: #{ARGV[1]}"
	f_out.puts "---"
	f_out.puts "<div class='todo'>Review and clean up the minutes, then remove this message.</div>"
	f_out.puts "<div class='todo'>Replace any shortened URL with the expanded version.</div>"
	f_out.puts "<div class='todo'>Make Resolutions and Actions link to github issues, then remove this message.</div>"
	f_out.puts @doc.css("body").inner_html.sub("[End of minutes]","")
end
