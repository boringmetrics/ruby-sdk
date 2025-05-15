# frozen_string_literal: true

require "bundler/gem_tasks"
require "rubocop/rake_task"

RuboCop::RakeTask.new

task default: %i[rubocop]

namespace :build do
  desc "Build all gems"
  task all: %i[core rails]

  desc "Build boringmetrics gem"
  task :core do
    Dir.chdir("boringmetrics") do
      sh "gem build boringmetrics.gemspec"
    end
  end

  desc "Build boringmetrics-rails gem"
  task :rails do
    Dir.chdir("boringmetrics-rails") do
      sh "gem build boringmetrics-rails.gemspec"
    end
  end
end

namespace :release do
  desc "Release all gems"
  task all: %i[core rails]

  desc "Release boringmetrics gem"
  task :core do
    Dir.chdir("boringmetrics") do
      sh "gem push boringmetrics-*.gem"
    end
  end

  desc "Release boringmetrics-rails gem"
  task :rails do
    Dir.chdir("boringmetrics-rails") do
      sh "gem push boringmetrics-rails-*.gem"
    end
  end
end
