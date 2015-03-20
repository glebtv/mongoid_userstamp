$:.push File.expand_path('../lib', __FILE__)
require 'mongoid/userstamp/version'

Gem::Specification.new do |s|
  s.name        = 'glebtv_mongoid_userstamp'
  s.version     = Mongoid::Userstamp::VERSION
  s.authors     = ['GlebTv', 'Thomas Boerger', 'Johnny Shields']
  s.homepage    = 'https://github.com/glebtv/mongoid_userstamp'
  s.license     = 'MIT'
  s.summary     = 'Userstamp for Mongoid'
  s.description = 'Userstamp for creator and updater columns using Mongoid'
  s.email       = 'glebtv@gmail.com'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.post_install_message = File.read('UPGRADING') if File.exists?('UPGRADING')

  s.add_runtime_dependency 'mongoid', '~> 4.0.2'
  s.add_runtime_dependency 'request_store'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
end

