bin = File.expand_path('bin', __dir__)
$LOAD_PATH.unshift(bin) unless $LOAD_PATH.include?(bin)
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
config = File.expand_path('config', __dir__)
$LOAD_PATH.unshift(config) unless $LOAD_PATH.include?(config)

Gem::Specification.new do |spec|
  spec.name          = 'mca'
  spec.version       = 1
  spec.authors       = ['Author']
  spec.email         = ['Author-email']

  spec.summary       = 'Gem for extending Peatio plugable system with tnc implementation.'
  spec.description   = ''
  spec.homepage      = 'https://mca-battle.com/'
  # spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'
  spec.add_dependency 'better-faraday'
  spec.add_dependency 'faraday'
  spec.add_dependency 'dotenv'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency "pry-reload"
  spec.add_development_dependency "timecop"
end
