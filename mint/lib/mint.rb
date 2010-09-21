require 'rubygems'
require 'mint/opts_parser'
require 'mint/base'

options = Mint::OptsParser.parse(ARGV)
mint    = Mint::Base.new(options)

mint.run!
puts "\n"
puts "Total exact change number   : #{mint.total_exact_change_number}"
puts "Coin set : #{mint.coin_set_to_s}"