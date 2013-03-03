require "bundler/setup"

require "bundler/gem_tasks"

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)

require "cucumber/rake/task"
Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = %w(--format progress)
  t.fork = false
end

task :default => [:spec, :cucumber]
