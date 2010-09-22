t_1     = Time.now
require 'lib/base'
raise "Usage: mint [integer]" if ARGV.length != 1
mint    = Mint::Base.new(ARGV[0])
mint.run!
t_2     = Time.now
puts "Calculating...\n"
puts "Total exact change number   : #{mint.total_exact_change_number}"
puts "Coin set                    : #{mint.coin_set_to_s}"
puts "Running time                : #{("%.3f" % (t_2 - t_1)).to_f}"
