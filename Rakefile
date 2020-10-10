require 'bundler/setup'
require 'rubygems/tasks'
Gem::Tasks.new

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

if RUBY_VERSION >= '2.4' # Newest Rubocop fails on 2.3
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
  task default: %w[spec rubocop]
else
  task default: 'spec'
end
