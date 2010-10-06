# myapp.rb
require 'rubygems'
require 'sinatra'
require File.expand_path(File.dirname(__FILE__) + '/lib/config')
get '/' do
  'Hello world!'
end