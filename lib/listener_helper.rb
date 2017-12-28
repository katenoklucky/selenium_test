require 'logger'

class MyListener < Selenium::WebDriver::Support::AbstractEventListener
  def initialize(log)
    @log = log
  end

  def before_find(by, what, driver)
    @log.info "#{by} #{what}"
  end

  def after_find(by, what, driver)
    @log.info "#{by} #{what} found"
  end
end