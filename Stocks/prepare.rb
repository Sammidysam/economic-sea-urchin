#! /usr/bin/env ruby
#
# Prepare
# Sam Craig
#
# As part of the Stocks subproject of the Midterm project,
# Prepare transforms the historical database of Dow Jones
# data into a data file that the graphing engine can handle.
#
# Exit codes:
# 1: invalid month argument
# 2: invalid year argument
# 3: invalid day argument
# 4: month and year not provided

require "active_support/core_ext/date_time"
require "active_support/core_ext/numeric/time.rb"
require "csv"
require "date"
require "optparse"
require "ostruct"

# How many days our graph will be when we start mid-month.
IRREGULAR_DURATION = 30

# Helper class, stores a row of the stock data.
class DailyEntry
  attr_accessor :date, :open, :high, :low, :close, :volume

  def initialize(date, open, high, low, close, volume)
    @date = DateTime.new(*(date.split("-").map(&:to_i)))
    @open = open.to_f
    @high = high.to_f
    @low = low.to_f
    @close = close.to_f
    @volume = volume.to_i
  end
end

# Parse the options provided to the program.
options = OpenStruct.new

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

unless options.month && options.year
  puts "Must provide a month and a year"
  exit 4
end

entries = []

CSV.parse(File.read(File.join(File.dirname(__FILE__), "daily_DJI.csv")), return_headers: false).each do |row|
  entries << DailyEntry.new(*row)
end
entries.shift

relevant_entries = entries.select do |e|
  if options.day
    start_date = DateTime.new(options.year, options.month, options.day)
    end_date = start_date + IRREGULAR_DURATION.days

    e.date >= start_date && e.date <= end_date
  else
    e.date.year == options.year && e.date.month == options.month
  end
end.sort_by { |e| e.date }

basis_open = relevant_entries.first.open
data_entries = relevant_entries.map.with_index do |re, index|
  "#{index} #{re.open - basis_open}"
end

puts data_entries
