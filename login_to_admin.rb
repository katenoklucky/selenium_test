require 'rspec'
require 'selenium-webdriver'
require 'pp'

describe 'Login to admin' do
  before(:each) do
    @driver = Selenium::WebDriver.for :firefox
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
  end

  it 'should login to admin' do
    @driver.navigate.to 'http://localhost/litecart/admin'
    @driver.find_element(:name, 'username').send_keys 'admin'
    @driver.find_element(:name, 'password').send_keys 'admin'
    @driver.find_element(:name, 'login').click
    @wait.until { @driver.title == 'My Store'}
  end

  after(:each) do
    @driver.quit
  end
end