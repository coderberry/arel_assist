# frozen_string_literal: true

if ENV.fetch("COVERAGE", false)
  require "simplecov"
  SimpleCov.start

  require "codecov"
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

require "rspec"
require "arel_assist"
require "fileutils"
require "whoop"
require "pry"
require "combustion"
require "database_cleaner"
require "env/models"

Combustion.initialize! :active_record

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  DatabaseCleaner.strategy = :transaction

  config.before { DatabaseCleaner.start }
  config.after { DatabaseCleaner.clean }
end
