# frozen_string_literal: true

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
      # Clean up old gem files first
      sh "rm -f *.gem" if Dir.glob("*.gem").any?
      
      # Build the gem
      sh "gem build boringmetrics.gemspec"
      
      # Find the specific gem file with the current version
      gem_file = Dir.glob("boringmetrics-*.gem").first
      sh "gem push #{gem_file}" if gem_file
    end
  end

  desc "Release boringmetrics-rails gem"
  task :rails do
    Dir.chdir("boringmetrics-rails") do
      # Clean up old gem files first
      sh "rm -f *.gem" if Dir.glob("*.gem").any?
      
      # Build the gem
      sh "gem build boringmetrics-rails.gemspec"
      
      # Find the specific gem file with the current version
      gem_file = Dir.glob("boringmetrics-rails-*.gem").first
      sh "gem push #{gem_file}" if gem_file
    end
  end
end
