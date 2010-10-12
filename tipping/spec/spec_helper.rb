require File.dirname(__FILE__) + '/../lib/tipping'
Pathname.glob(Pathname.new(File.dirname(__FILE__)).join("helpers/*.rb")).each do |filename|
  require filename.to_s
end
