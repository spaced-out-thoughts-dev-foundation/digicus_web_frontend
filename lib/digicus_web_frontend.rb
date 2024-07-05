# frozen_string_literal: true

# Core logic for consuming Digicus Textual Representation (DTR) files.
module DigicusWebFrontend
  autoload :Compiler, './lib/digicus_web_frontend/compiler'
end

def silence_streams
  original_stdout = $stdout
  original_stderr = $stderr
  $stdout = File.new('/dev/null', 'w')
  $stderr = File.new('/dev/null', 'w')
  yield
ensure
  $stdout = original_stdout
  $stderr = original_stderr
end

if __FILE__ == $PROGRAM_NAME
  input = ARGV[0]

  if input == 'version'
    gemspec_path = 'digicus_web_frontend.gemspec'

    # Extract version from gemspec
    gemspec = File.read(gemspec_path)
    version_match = gemspec.match(/\.version\s*=\s*["']([^"']+)["']/)
    version = version_match[1] if version_match

    puts version
  else

    if input.nil?
      puts 'Usage: ./digicus_web_frontend <file_path>'
      exit(1)
    end

    json_for_web = silence_streams do
      DigicusWebFrontend::Compiler.from_dtr(File.read(input))
    end

    puts json_for_web
  end
end
