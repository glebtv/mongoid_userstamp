# -*- encoding : utf-8 -*-
require 'rubygems'

$:.push File.expand_path('../../lib', __FILE__)

require 'active_support/all'
require 'mongoid'
require 'mongoid_userstamp'

Mongoid.configure do |config|
  config.connect_to(
    'mongoid_userstamp_test'
  )
end

begin
  Object.send :remove_const, :Config
rescue Exception => e
end
Config = RbConfig

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each do |f|
  require f
end

Mongo::Logger.logger.level = ::Logger::FATAL

RSpec.configure do |config|
  config.mock_with :rspec
  
  config.after :suite do
    Mongoid.purge!
  end
end
