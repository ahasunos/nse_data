# frozen_string_literal: true

require_relative 'lib/nse_data/version'

Gem::Specification.new do |spec|
  spec.name = 'nse_data'
  spec.version = NseData::VERSION
  spec.authors = ['Sonu Saha']
  spec.email = ['ahasunos@gmail.com']

  spec.summary = 'A Ruby gem for accessing NSE data'
  spec.description = 'Retrieves stock market data from the NSE (National Stock Exchange) of India'
  spec.homepage = 'https://github.com/ahasunos/nse_data'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.1.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/ahasunos/nse_data'
  spec.metadata['changelog_uri'] = 'https://github.com/ahasunos/nse_data/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'api_wrapper'
end
