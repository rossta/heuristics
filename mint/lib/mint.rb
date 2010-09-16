require 'mint/opts_parser'
require 'mint/base'

options = Mint::OptsParser.parse(ARGV)
mint    = Mint::Base.new(options)

mint.run!
puts "Total exact change number   : #{mint.total_exact_change_number}"
puts "Average exact change number : #{mint.average_exact_change_number}"