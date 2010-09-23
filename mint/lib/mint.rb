t_1     = Time.now
require 'lib/base'
raise "Usage: mint [integer]" if ARGV.length != 1
mint    = Mint::ExactChange.new(ARGV[0])
puts "Calculating...\n"
mint.calculate!
t_2     = Time.now
puts "Total exact change number   : #{mint.results}"
puts "Coin set                    : #{mint.coin_set.join(", ")}"
puts "Running time                : #{("%.3f" % (t_2 - t_1)).to_f}"
