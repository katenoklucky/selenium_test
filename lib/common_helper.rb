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
    # @driver = Selenium::WebDriver.for $browser.to_sym, :options => @option, :listener => MyListener.new(Logger.new(STDOUT))
    @driver = Selenium::WebDriver.for $browser.to_sym, :options => @option
  end

  def go_to_url(url)
    @driver.get(url)
    @driver.manage.timeouts.implicit_wait = $implicit_wait_time
  end

  def find_element(hash_element)
    finder = hash_element[:finder].to_sym
    selector = hash_element[:selector]
    @driver.manage.timeouts.implicit_wait = 3
    res_element = nil
    begin
      res_element = @driver.find_element(finder, selector) unless res_element
      @driver.action.move_to(res_element).perform
    rescue Selenium::WebDriver::Error::MoveTargetOutOfBoundsError
      @driver.action.send_keys :page_down
      res_element = @driver.find_element(finder, selector)
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      10.times do |try|
        puts "Got StaleElementReferenceError error in '#{self.class.name}.#{__method__}', try #{try+1} of 10..."
        res_element = @driver.find_element(finder, selector)
        break if res_element
      end
    rescue Selenium::WebDriver::Error::NoSuchElementError, Selenium::WebDriver::Error::InvalidSelectorError
    rescue Selenium::WebDriver::Error::TimeOutError
      raise "Element '#{res_element}' does not found by timeout!"
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

  def element_exist?(hash_element)
    begin
      el = find_element(hash_element)
      !el.nil?
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      puts "Got StaleElementReferenceError error in '#{self.class.name}.#{__method__}', try again..."
      element_exist?(hash_element)
    end
  end

  def is_element_displayed?(hash_element)
    begin
      el = find_element(hash_element)
      el.displayed? if el
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      puts "Got StaleElementReferenceError error in '#{self.class.name}.#{__method__}', try again..."
      is_element_displayed?(hash_element)
    end
  end

  def is_element_enabled?(hash_element)
    begin
      el = find_element(hash_element)
      el.enabled?
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      puts "Got StaleElementReferenceError error in '#{self.class.name}.#{__method__}', try again..."
      is_element_enabled?(hash_element)
    end
  end

  def wait_for_element_exists(hash_element)
    wait = Selenium::WebDriver::Wait.new(:timeout => $implicit_wait_time) # seconds
    wait.until { element_exist?(hash_element) }
  end

  def wait_for_element_does_not_exist(hash_element)
    wait = Selenium::WebDriver::Wait.new(:timeout => $implicit_wait_time) # seconds
    wait.until { !element_exist?(hash_element) }
  end

  def wait_for_element_is_not_visible(hash_element)
    wait = Selenium::WebDriver::Wait.new(:timeout => $implicit_wait_time) # seconds
    wait.until { !is_element_displayed?(hash_element) }
  end

  def wait_for_element_displayed(hash_element)
    wait = Selenium::WebDriver::Wait.new(:timeout => $implicit_wait_time) # seconds
    wait.until { is_element_displayed?(hash_element) }
  end

  def wait_for_element_enabled(hash_element)
    wait = Selenium::WebDriver::Wait.new(:timeout => $implicit_wait_time) # seconds
    wait.until { is_element_enabled?(hash_element) }
  end

  def wait_for_element_not_exist(element)
    wait = Selenium::WebDriver::Wait.new(:timeout => $implicit_wait_time) # seconds
    wait.until { !element.nil? }
  end

  def wait_for_title(title)
    wait = Selenium::WebDriver::Wait.new(:timeout => $implicit_wait_time) # seconds
    wait.until { get_title == title }
  end

  def wait_for_title_exist
    wait = Selenium::WebDriver::Wait.new(:timeout => $implicit_wait_time) # seconds
    wait.until { get_title != ''}
  end

  def get_title
    @driver.title
  end

  def close_browser
    @driver.close
  end

  def fill_field(hash_element, value)
    if hash_element.class == Selenium::WebDriver::Element
      element = hash_element
    else
      element = find_element(hash_element)
    end
    if element.enabled?
      if element.tag_name == 'select'
        wait_drop_down(element)
        options = element.find_elements(tag_name: 'option')
        options.each do |option|
          if option.text == value
            option.click unless option.attribute('selected')
            break
          end
        end
      elsif element.attribute('role') == 'listbox'
        result = false
        wait_listbox(element)
        list = element.find_elements(tag_name: 'li')
        list.each_with_index do |li, index|
          actual_value = li.text.downcase
          expected_value = value.downcase
          if actual_value == expected_value
            li_element = "#{hash_element[:selector]} > li:nth-child(#{index + 1}) > a"
            scroll_into_view(li_element)
            li_element_hash = {
                finder: 'css',
                selector: li_element
            }
            sleep 3
            puts "Selected #{actual_value} value"
            find_element(li_element_hash).click
            result = true
            break
          end
        end
        raise "Cannot find #{value} in list for element #{element}!" unless result
      elsif element.attribute('type') == 'checkbox'
        if value == 'check'
          element.click unless element.selected?
        else
          element.clear if element.selected?
        end

      else
        element.send_keys value
      end
    else
      raise "Element '#{hash_element[:selector]}' is not visible!"
    end
  end

  def check_uncheck_element(mode, checkbox, checkbox_button)
    act_result = checkbox.attribute('checked')
    mode == 'check' ? exp_result = 'true' : exp_result = nil
    checkbox_button.click unless exp_result == act_result
  end

  def wait_drop_down(element)
    wait = Selenium::WebDriver::Wait.new(:timeout => $implicit_wait_time)
    wait.until { true if element.all(:css, 'option').size > 0 }
    element
  end

  def wait_listbox(element)
    wait = Selenium::WebDriver::Wait.new(:timeout => $implicit_wait_time)
    wait.until { true if element.all(:css, 'li').size > 0 }
    element
  end

  def scroll_into_view(element)
    script = "$(\"#{element}\").get(0).scrollIntoView();"
    execute_script(script)
  end

  def execute_script(script)
    @driver.execute_script(script)
  end

  def get_element_style(element, style)
    element.style(style)
  end

  def wait_for(timeout = $implicit_wait_time, interval = 2, &_block)
    duration = 0
    start = Time.now
    loop do
      break if yield
      if duration > timeout
        raise TimeoutError, "The specified wait_for timeout (#{timeout} seconds) was exceeded!"
      end
      sleep(interval)
      duration = Time.now - start
    end
  end

  def remember_window
    @window = @driver.window_handle
  end

  def return_to_window
    @driver.switch_to.window(@window)
  end

  def close_window
    @driver.close
  end

  def go_to_new_window
    windows = @driver.window_handles
    windows.each do |window|
      if @window != window
        @driver.switch_to.window(window)
        break
      end
    end
  end

  def get_browser_logs
    @driver.manage.logs.get :browser
  end
end