require_relative 'lib/saharspec/version'

Gem::Specification.new do |s|
  s.name     = 'saharspec'
  s.version  = Saharspec::VERSION
  s.authors  = ['Victor Shepelev']
  s.email    = 'zverok.offline@gmail.com'
  s.homepage = 'https://github.com/zverok/saharspec'

  s.summary = 'Several additions for DRYer RSpec code'
  s.licenses = ['MIT']

  s.files = `git ls-files`.split($RS).reject do |file|
    file =~ /^(?:
    spec\/.*
    |Gemfile
    |Rakefile
    |\.rspec
    |\.gitignore
    |\.rubocop.yml
    |\.travis.yml
    )$/x
  end
  s.require_paths = ["lib"]

  s.required_ruby_version = '>= 3.1.0'

  s.add_development_dependency 'rubocop', '~> 1.76.0'
  s.add_development_dependency 'rspec', '>= 3.7.0'
  s.add_development_dependency 'rspec-its'
  s.add_development_dependency 'simplecov', '~> 0.9'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rubygems-tasks'
  s.add_development_dependency 'yard'
  #s.add_development_dependency 'coveralls'
end
