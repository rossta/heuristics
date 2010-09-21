require 'lib/base'
raise "Usage: mint [integer]" if ARGV.length != 1

mint    = Mint::Base.new(ARGV[0])
mint.run!
puts "\n"
puts "Total exact change number   : #{mint.total_exact_change_number}"
puts "Coin set : #{mint.coin_set_to_s}"