# frozen_string_literal: true

require_relative "lib/turbo_transition/version"

Gem::Specification.new do |spec|
  spec.name = "turbo_transition"
  spec.version = TurboTransition::VERSION
  spec.authors = ["Jonathan"]
  spec.email = ["jonathan@productmatter.co"]

  spec.summary = "Animated content transitions for Turbo Streams"
  spec.description = "A Rails gem that provides smooth, animated transitions between content updates via Turbo Streams"
  spec.homepage = "https://github.com/productmatter/turbo_transition"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Dependencies
  spec.add_dependency "rails", ">= 6.1.0"
  spec.add_dependency "turbo-rails", ">= 1.0.0"
  spec.add_dependency "view_component", ">= 2.0.0"

  # Development dependencies
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
