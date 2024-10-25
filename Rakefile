# frozen_string_literal: true

# Load Bundler's gem tasks (e.g., `rake build`, `rake install`, etc.)
require 'bundler/gem_tasks'

# Load RSpec's rake task to run the test suite using `rake spec`
require 'rspec/core/rake_task'

# Define the `spec` task to run RSpec tests
RSpec::Core::RakeTask.new(:spec)

# Load RuboCop's rake task to check for style guide violations using `rake rubocop`
require 'rubocop/rake_task'

# Define the `rubocop` task to run RuboCop linter
RuboCop::RakeTask.new

# Load Yard's rake task for generating documentation using `rake yard`
require 'yard'

# Define the `yard` task to generate documentation in the `docs` directory
YARD::Rake::YardocTask.new do |t|
  t.options = ['--output-dir', 'docs']
end

# By default, run both the `spec` (tests) and `rubocop` (linter) tasks
task default: %i[spec rubocop]

require_relative 'lib/nse_data'

namespace :docs do
  desc 'Update README with dynamically defined methods'
  task :update_readme do
    # Ensure the API methods are defined
    NseData.define_api_methods

    # List all methods defined on NseData
    methods = NseData.methods(false).grep(/^fetch_/)

    # Read the existing README
    readme_path = 'README.md'
    readme_content = File.read(readme_path)

    # Define markers for where to insert the methods section
    start_marker = '## Available Methods'
    end_marker = '## Usage'
    start_index = readme_content.index(start_marker) + start_marker.length
    end_index = readme_content.index(end_marker)

    if start_index && end_index
      methods_section = readme_content[start_index...end_index]
      new_methods_section = "#{start_marker}\n\n"
      methods.each do |method|
        new_methods_section += "- #{method}\n"
      end

      # Write back the updated README
      updated_content = readme_content.sub(methods_section, new_methods_section)
      File.write(readme_path, updated_content)

      puts 'README updated with the following methods:'
      methods.each { |method| puts "- #{method}" }
    else
      puts 'Could not find markers to update in README.md'
    end
  end
end

# Usage:
# 1. `rake spec` - Runs the RSpec tests
# 2. `rake rubocop` - Runs RuboCop linter for code quality checks
# 3. `rake yard` - Generates Yard documentation (output in the `docs/` folder)
# 4. `rake` - Runs both the tests and RuboCop checks (default task)
# 5. `rake docs:update_readme` - Update readme with available methods generated dynamically in nse_data.rb
