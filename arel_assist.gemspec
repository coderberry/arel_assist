# frozen_string_literal: true

require_relative "lib/arel_assist/version"

Gem::Specification.new do |spec|
  spec.name = "arel_assist"
  spec.version = ArelAssist::VERSION
  spec.authors = ["Eric Berry"]
  spec.email = ["eric@berry.sh"]

  spec.summary = "Helpers and shortcuts with Arel"
  spec.description = spec.summary
  spec.homepage = "https://github.com/coderberry/arel_assist"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", ">= 3.1.0", "< 8"

  spec.add_development_dependency "magic_frozen_string_literal"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "standard"
  spec.add_development_dependency "bump"
  spec.add_development_dependency "sord"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "codecov"
end
