require 'sinatra'
require 'yaml'
require 'dalli'
require 'memcachier'

# load config file
config = YAML::load(File.open('./config/settings.yml'))
config[settings.environment.to_s].each do |k, v|
  set k.to_sym, v
end

# load memcache client

$Cache = Dalli::Client.new

require './app'