require 'rspec'
require 'selenium-webdriver'
require 'pp'

$browser = 'firefox'

describe 'Google search' do
  before(:each) do
    @driver = Selenium::WebDriver.for :firefox
    puts PP.pp(@driver.capabilities)
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
  end

  it 'should find webdriver' do
    @driver.navigate.to 'http://google.com'
    @driver.find_element(:name, 'q').send_keys 'webdriver'
    @driver.find_element(:css, 'input[type="submit"]:nth-child(1)').click
    @wait.until { @driver.title == 'webdriver - Google Search'}
  end

  after(:each) do
    @driver.quit
  end
end