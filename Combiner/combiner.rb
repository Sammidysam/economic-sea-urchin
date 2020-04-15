#! /usr/bin/env ruby
#
# Combiner
# Sam Craig
#
# Takes in a combiner file and writes the PostScript to turn it into a "sea urchin".
# See `example.combiner` for an example of a Combiner file.
# Note: runtime for getting one PostScript path seems to be about 0.3 seconds,
# so running too many graphs will probably get rather slow.
# Example: ./combiner.rb < example.dat > firstfunc.eps
#
# Long term, it seems "cooler" to have this call Ruby code directly, rather
# than using system calls.

require "optparse"
require "ostruct"

THIS_DIRECTORY = File.dirname(__FILE__)
PREPARE_LOCATION = File.join(THIS_DIRECTORY, "..", "Stocks", "prepare.rb")
GRAPHER_LOCATION = File.join(THIS_DIRECTORY, "..", "Grapher", "grapher.rb")

options = OpenStruct.new

OptionParser.new do |opt|
  opt.on("-d", "--dummy", "Produce dummy output") do |d|
    options.dummy = true
  end

  opt.on("-c", "--cones", "Produce cone output") do |c|
    options.cones = true
  end
end.parse!

argument_lines = $stdin.read.split("\n")
rotation = 180 / (argument_lines.length - 1).to_f

paths = argument_lines.map do |l|
  options.dummy ?
    `printf "0 0\n 1 0" | #{GRAPHER_LOCATION} -p` :
    `#{PREPARE_LOCATION} #{l} | #{GRAPHER_LOCATION} -p #{"-r #{rotation}" if options.cones}`
end

code = paths.map { |p| %(
0 0 translate

#{p}

stroke
) }

puts %(
%!PS-Adobe-3.0 EPSF-3.0
%%BoundingBox: -250 -150 250 250

0.0 setgray

1 setlinejoin
1 setlinecap

#{code.join(%(

#{rotation} rotate

))}

showpage
)
