require File.expand_path(File.join(*%w[ config environment ]), File.dirname(__FILE__))

use Rack::Static, :urls => ['/assets'], :root => 'public'

run App.new
