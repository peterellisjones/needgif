require 'sinatra'
require 'yaml'

# load config file
config = YAML::load(File.open('./config/settings.yml'))
config[settings.environment.to_s].each do |k, v|
  set k.to_sym, v
end

require './app'