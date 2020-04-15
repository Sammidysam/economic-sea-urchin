#! /usr/bin/env ruby
#
# Grapher
# Sam Craig
#
# Takes in a data file and writes the PostScript to turn it into a graph.
# Example: ./grapher.rb < example.dat > firstfunc.eps
#
# Exit codes:
# 1: invalid angle argument

require "optparse"
require "ostruct"

def scale_values(array, max)
  local_max = array.map { |e| e.abs }.max.to_f

  scale = local_max == 0 ? 1 : (max / local_max)
  array.map { |v| v * scale }
end

def scale_trig(y_values, x_values, angle)
  # Also converting this bounding angle to radians.
  bounding_angle = (angle / 2) * Math::PI / 180
  merged_values = y_values.zip x_values
  local_max = y_values.map { |v| v.abs }.max.to_f

  scaled_y = []
  merged_values.each do |v|
    y_limit = v[1] * Math.tan(bounding_angle)

    scale = local_max == 0 ? 1 : (y_limit / local_max)
    scaled_y << v[0] * scale
  end

  scaled_y
end

options = OpenStruct.new

OptionParser.new do |opt|
  opt.on("-p", "--path", "Provide only the path") do |p|
    options.path = true
  end

  opt.on("-r", "--rotation ANGLE", "Scales into a cone at ANGLE") do |r|
    angle = r.to_f

    if angle < 0 && angle > 180
      puts "Angle must be in [0, 180]"
      exit 1
    end

    options.angle = angle
  end
end.parse!

data = $stdin.read.split("\n").map { |d| d.split(' ') }.map { |d| d.map { |i| i.to_f } }

x_values = scale_values data.map { |d| d[0] }, 200
y_values = scale_values data.map { |d| d[1] }, 98

y_values = scale_trig(y_values, x_values, options.angle) if options.angle

scaled_data = x_values.zip y_values

data_for_ps = scaled_data.map { |d| d.join(' ') }
line_tos = data_for_ps[1..-1].map { |line| "#{line} lineto" }.join("\n")

path = %(
newpath
  #{data_for_ps[0]} moveto
  #{line_tos}
)

puts options.path ? path : %(
%!PS-Adobe-3.0 EPSF-3.0
%%BoundingBox: 0 -100 200 100

0 0 translate

0.0 setgray

1 setlinejoin
1 setlinecap

#{path}

stroke

showpage
)
