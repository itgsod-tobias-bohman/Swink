# Configuration for acceptance tests (rake test:acceptance)

require_relative '../test_helper'

Capybara.app = App
Capybara.default_driver = :webkit
Capybara.javascript_driver = :webkit
