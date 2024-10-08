require 'fileutils'

VERSION_FILE = 'lib/nse_data/version.rb'

def current_version
  version_file = File.read(VERSION_FILE)
  version_file.match(/VERSION = ['"](.*)['"]/)[1]
end

def bump_version(type)
  major, minor, patch = current_version.split('.').map(&:to_i)

  case type
  when 'major'
    major += 1
    minor = 0
    patch = 0
  when 'minor'
    minor += 1
    patch = 0
  else
    patch += 1
  end

  new_version = "#{major}.#{minor}.#{patch}"
  update_version_file(new_version)
end

def update_version_file(new_version)
  content = File.read(VERSION_FILE)
  new_content = content.gsub(/VERSION = ['"].*['"]/, "VERSION = '#{new_version}'")
  File.open(VERSION_FILE, 'w') { |file| file.write(new_content) }
end

def determine_bump_type
  labels = ENV['PR_LABELS'].to_s.split(',')
  puts "PR_LABELS: #{labels}" # Debugging line to check labels

  # Check if any skip labels are present
  if labels.any? { |label| label.strip == 'skip-version-bump' || label.strip == 'ci' }
    return 'skip'
  end

  # Check if any bump labels are present
  if labels.any? { |label| label.strip == 'bump-major' }
    return 'major'
  elsif labels.any? { |label| label.strip == 'bump-minor' }
    return 'minor'
  end

  # Default to patch bump
  'patch'
end

bump_type = determine_bump_type
if bump_type == 'skip'
  puts "Skipping version bump due to label presence"
else
  bump_version(bump_type)
  puts "Bumped version to #{current_version}"
end
