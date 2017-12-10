class UICommon
  def set_profile(browser)
    $browser = browser
    @browser = {
        firefox: Selenium::WebDriver::Firefox::Profile.new,
        chrome: Selenium::WebDriver::Chrome::Profile.new,
    }
    @options = {
        firefox: Selenium::WebDriver::Firefox::Options.new,
        chrome: Selenium::WebDriver::Chrome::Options.new,
    }
    @profile = @browser[$browser.to_sym]
    @option = @options[$browser.to_sym]
    @driver = Selenium::WebDriver.for $browser.to_sym, :options => @option
  end

  def go_to_url(url)
    @driver.get(url)
    @driver.manage.timeouts.implicit_wait = $implicit_wait_time
  end

  def find_element(selector, value)
    @driver.manage.timeouts.implicit_wait = 3
    res_element = nil
    begin
      res_element = @driver.find_element(selector, value) unless res_element
      @driver.action.move_to(res_element).perform
    rescue Selenium::WebDriver::Error::MoveTargetOutOfBoundsError
      @driver.action.send_keys :page_down
      res_element = @driver.find_element(selector, value)
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      10.times do |try|
        puts "Got StaleElementReferenceError error in '#{self.class.name}.#{__method__}', try #{try+1} of 10..."
        res_element = @driver.find_element(selector, value)
        break if res_element
      end
    rescue Selenium::WebDriver::Error::NoSuchElementError, Selenium::WebDriver::Error::InvalidSelectorError
    rescue Selenium::WebDriver::Error::TimeOutError
      raise "Element '#{element}' does not found by timeout!"
    end
    @driver.manage.timeouts.implicit_wait = $implicit_wait_time
    res_element
  end

  def find_elements(parent_element, selector)
    @driver.manage.timeouts.implicit_wait = 3
    res_element = nil
    begin
      res_element = parent_element.find_elements(selector) unless res_element
      @driver.action.move_to(parent_element).perform
    rescue Selenium::WebDriver::Error::MoveTargetOutOfBoundsError
      @driver.action.send_keys :page_down
      res_element = parent_element.find_elements(selector) unless res_element
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      10.times do |try|
        puts "Got StaleElementReferenceError error in '#{self.class.name}.#{__method__}', try #{try+1} of 10..."
        res_element = parent_element.find_elements(selector) unless res_element
        break if res_element
      end
    rescue Selenium::WebDriver::Error::NoSuchElementError, Selenium::WebDriver::Error::InvalidSelectorError
    rescue Selenium::WebDriver::Error::TimeOutError
      raise "Element '#{parent_element}' does not found by timeout!"
    end
    @driver.manage.timeouts.implicit_wait = $implicit_wait_time
    res_element
  end

  def send_keys(element, text)
    element.send_keys text
  end

  def element_exist?(selector, value)
    begin
      el = find_element(selector, value)
      !el.nil?
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      puts "Got StaleElementReferenceError error in '#{self.class.name}.#{__method__}', try again..."
      element_exist?(selector, value)
    end
  end

  def is_element_displayed?(selector, value)
    begin
      el = find_element(selector, value)
      el.displayed? if el
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      puts "Got StaleElementReferenceError error in '#{self.class.name}.#{__method__}', try again..."
      is_element_displayed?(selector, value)
    end
  end

  def is_element_enabled?(selector, value)
    begin
      el = find_element(selector, value)
      el.enabled?
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      puts "Got StaleElementReferenceError error in '#{self.class.name}.#{__method__}', try again..."
      is_element_enabled?(selector, value)
    end
  end

  def wait_for_element_exists(selector, value)
    wait = Selenium::WebDriver::Wait.new(:timeout => $implicit_wait_time) # seconds
    wait.until { element_exist?(selector, value) }
  end

  def wait_for_element_does_not_exist(selector, value)
    wait = Selenium::WebDriver::Wait.new(:timeout => $implicit_wait_time) # seconds
    wait.until { !element_exist?(selector, value) }
  end

  def wait_for_element_is_not_visible(selector, value)
    wait = Selenium::WebDriver::Wait.new(:timeout => $implicit_wait_time) # seconds
    wait.until { !is_element_displayed?(selector, value) }
  end

  def wait_for_element_displayed(selector, value)
    wait = Selenium::WebDriver::Wait.new(:timeout => $implicit_wait_time) # seconds
    wait.until { is_element_displayed?(selector, value) }
  end

  def wait_for_element_enabled(selector, value)
    wait = Selenium::WebDriver::Wait.new(:timeout => $implicit_wait_time) # seconds
    wait.until { is_element_enabled?(selector, value) }
  end

  def wait_for_title(title)
    wait = Selenium::WebDriver::Wait.new(:timeout => $implicit_wait_time) # seconds
    wait.until { @driver.title == title }
  end

  def close_browser
    @driver.quit
  end

end