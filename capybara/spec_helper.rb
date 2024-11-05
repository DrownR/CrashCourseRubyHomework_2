# frozen_string_literal: true

require 'capybara'
require 'rspec'


RSpec.configure do |config|
  config.add_formatter 'html', 'results.html'

  config.after(:each) do |example|
    if example.exception
      Dir.mkdir('screenshots') unless Dir.exist?('screenshots')

      time = Time.now.strftime('%Y-%m-%d_%H_%M_%S')
      filename = "screenshots/#{time}_#{example.description.gsub(' ', '_')}.png"
      @driver.save_screenshot(filename)
    end
  end
end
Capybara.default_driver = :selenium
Capybara.app_host = 'https://www.saucedemo.com/'

Capybara::Selenium::Driver.class_eval do
  def quit
  end
end