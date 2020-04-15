#! /usr/bin/env ruby
#
# Generator
# Sam Craig
#
# The goal of the generator is to produce combiner files.
# It takes in command-line arguments, and proceeds to create a combiner file
# either for each month in a year, or each instance of a month in the data,
# or other future possibilities!
#
# Exit codes:
# 1: invalid month argument
# 2: invalid year argument
# 3: invalid day argument
# 4: provided neither a month nor a year, or both a month and a year

require "optparse"
require "ostruct"

options = OpenStruct.new

# This parsing is copied from Stock prepare.rb.
# Maybe this common option parsing could be separated into its own file?
OptionParser.new do |opt|
  opt.on("-m", "--month MONTH", "The month") do |m|
    month = m.to_i

    if month < 1 || month > 12
      puts "Month must be in [1, 12]"
      exit 1
    end

    options.month = month
  end

  opt.on("-y", "--year YEAR", "The year") do |y|
    year = y.to_i

    if year < 2000 || year > 2020
      puts "Year must be in [2000, 2020]"
      exit 2
    end

    options.year = year
  end

  opt.on("-d", "--day DAY", "The day") do |d|
    day = d.to_i

    if day < 1 || day > 31
      puts "Day must be in [1, 31]"
      exit 3
    end

    options.day = day
  end
end.parse!

# For exclusive or to work, both need to be coerced to booleans.
unless !!options.month ^ !!options.year
  puts "Must provide either a month or a year"
  exit 4
end

if options.month
  year_start = 2000
  year_end = options.month <= 3 ? 2020 : 2019

  lines = (year_start..year_end).map { |y| "-y #{y} -m #{options.month} #{"-d #{options.day}" if options.day}" }

  puts lines.join("\n")
end

if options.year
  month_start = 1
  month_end = options.year < 2020 ? 12 : 3

  lines = (month_start..month_end).map { |m| "-y #{options.year} -m #{m} #{"-d #{options.day}" if options.day}" }

  puts lines.join("\n")
end
