Then /^I verify all stickers on opened page$/ do
  page = $ui.find_element($locators[:page])
  images = $ui.find_elements(page, class: 'image-wrapper')
  images.each do |el|
    result = $ui.find_elements(el, class: 'sticker').length
    raise "Image #{el.attribute('title')} does not have sticker!" if result == 0
    raise "Image #{el.attribute('title')} has more stickers than 1!" if result > 1
  end
end

Then /^I navigate to "Yellow Duck" item/ do
  el = $ui.find_element(:css, '#box-campaigns > div > ul > li > a.link')
  el.click
end

Then /^I navigate to the first item/ do
  el = $ui.find_element($locators[:first_item])
  el.click
end

Then /^I verify settings for the item are equal on pages:$/ do |table|
  settings = table.raw
  settings.map do |el|
    setting = el[0]
    actual_res = expected_res = nil
    if setting == 'name'
      raise "Cannot find 'name' setting for item page!" unless @item_settings.has_key?(:name)
      raise "Cannot find 'name' setting for main page!" unless @main_settings.has_key?(:name)
      actual_res = @main_settings[:name]
      expected_res = @item_settings[:name]
    end

    if setting == 'regular price'
      raise "Cannot find 'regular_price' setting for item page!" unless @item_settings.has_key?(:regular_price)
      raise "Cannot find 'regular_price' setting for main page!" unless @main_settings.has_key?(:regular_price)
      actual_res = @main_settings[:regular_price]
      expected_res = @item_settings[:regular_price]
    end

    if setting == 'promotional price'
      raise "Cannot find 'promotional_price' setting for item page!" unless @item_settings.has_key?(:promotional_price)
      raise "Cannot find 'promotional_price' setting for main page!" unless @main_settings.has_key?(:promotional_price)
      actual_res = @main_settings[:promotional_price]
      expected_res = @item_settings[:promotional_price]
    end

    if setting == 'color of regular price'
      raise "Cannot find 'color_regular_price' setting for item page!" unless @item_settings.has_key?(:color_regular_price)
      raise "Cannot find 'color_regular_price' setting for main page!" unless @main_settings.has_key?(:color_regular_price)
      actual_res = @main_settings[:color_regular_price]
      expected_res = @item_settings[:color_regular_price]
    end

    if setting == 'text-decoration of regular price'
      raise "Cannot find 'strike_regular_price' setting for item page!" unless @item_settings.has_key?(:strike_regular_price)
      raise "Cannot find 'strike_regular_price' setting for main page!" unless @main_settings.has_key?(:strike_regular_price)
      actual_res = @main_settings[:strike_regular_price]
      expected_res = @item_settings[:strike_regular_price]
    end

    if setting == 'color of promotional price'
      raise "Cannot find 'color_promotional_price' setting for item page!" unless @item_settings.has_key?(:color_promotional_price)
      raise "Cannot find 'color_promotional_price' setting for main page!" unless @main_settings.has_key?(:color_promotional_price)
      actual_res = @main_settings[:color_promotional_price]
      expected_res = @item_settings[:color_promotional_price]
    end

    if setting == 'font-weight of promotional price'
      raise "Cannot find 'weight_promotional_price' setting for item page!" unless @item_settings.has_key?(:weight_promotional_price)
      raise "Cannot find 'weight_promotional_price' setting for main page!" unless @main_settings.has_key?(:weight_promotional_price)
      actual_res = @main_settings[:weight_promotional_price]
      expected_res = @item_settings[:weight_promotional_price]
    end
    puts "#{setting.capitalize}:\nExpected = #{expected_res}\nActual = #{actual_res}"
    raise "Values of '#{setting}' does not match!\nExpected = #{expected_res}\nActual = #{actual_res}" unless expected_res == actual_res
  end
end

Then /^I create new account with following settings:$/ do |table|
  $ui.find_element(:css, '#box-account-login a').click
  settings = table.hashes
  settings.each do |setting|
    value = setting[:value]
    element = nil
    case setting[:setting]
      when 'tax_id'
        element = '#create-account input[name="tax_id"]'
      when 'company'
        element = '#create-account input[name="company"]'
      when 'first_name'
        element = '#create-account input[name="firstname"]'
      when 'last_name'
        element = '#create-account input[name="lastname"]'
      when 'address1'
        element = '#create-account input[name="address1"]'
      when 'address2'
        element = '#create-account input[name="address2"]'
      when 'postcode'
        element = '#create-account input[name="postcode"]'
      when 'city'
        element = '#create-account input[name="city"]'
      when 'country'
        element = '#create-account select[name="country_code"]'
      when 'zone'
        element = '#create-account select[name="zone_code"]'
      when 'email'
        @random_value = generate_random_value(5)
        value.gsub!('(generated_id)', @random_value)
        element = '#create-account input[name="email"]'
      when 'phone'
        element = '#create-account input[name="phone"]'
      when 'desired_password'
        element = '#create-account input[name="password"]'
      when 'confirm_password'
        element = '#create-account input[name="confirmed_password"]'
    end
    $ui.fill_field(:css, element, value)
  end
  $ui.find_element(:css, '#create-account button[name="create_account"]').click
end

Then /^I verify font sizes for the item on (main|item) page$/ do |page|
  if page == 'item'
    raise "Cannot find 'font_size_regular_price' setting for item page!" unless @item_settings.has_key?(:font_size_regular_price)
    raise "Cannot find 'font_size_promotional_price' setting for item page!" unless @item_settings.has_key?(:font_size_promotional_price)
    regular_size = @item_settings[:font_size_regular_price]
    promotional_size = @item_settings[:font_size_promotional_price]

  else
    raise "Cannot find 'font_size_regular_price' setting for main page!" unless @main_settings.has_key?(:font_size_regular_price)
    raise "Cannot find 'font_size_promotional_price' setting for main page!" unless @main_settings.has_key?(:font_size_promotional_price)
    regular_size = @main_settings[:font_size_regular_price]
    promotional_size = @main_settings[:font_size_promotional_price]
  end
  puts "Promotional font size = #{promotional_size}\nRegular font size = #{regular_size}"
  raise "Promotional size price #{promotional_size} is less then regular #{regular_size} on item page!" unless promotional_size > regular_size
end

Then /^I logout from the site$/ do
  $ui.find_element(:css, '#box-account > div > ul > li:nth-child(4) > a').click
end

Then /^I login on the site with following settings:$/ do |table|
  settings = table.hashes
  settings.each do |setting|
    value = setting[:value]
    value.gsub!('(generated_id)', @random_value)
    element = nil
    case setting[:setting]
      when 'email'
        element = '#box-account-login input[name="email"]'
      when 'password'
        element = '#box-account-login input[name="password"]'
    end
    $ui.fill_field(:css, element, value)
  end
  $ui.find_element(:css, '#box-account-login button[name="login"]').click
end

Then /^I navigate to "(.+)" menu item on the site$/ do |menu|
  menu_box = $ui.find_element(:css, '#box-apps-menu-wrapper')
  $ui.find_elements(menu_box, class: 'name').select {|el| el.text == menu}.first.click
end

Then /^I click on "(.+)"$/ do |button_name|
  $ui.find_elements($ui.find_element($locators[:body]), tag_name: 'a').select {|el| el.text == button_name}.first.click
end

Then /^I click on "(.+)" button$/ do |button_name|
  $ui.find_elements($ui.find_element($locators[:body]), tag_name: 'button').select {|el| el.text == button_name}.first.click
  res = $ui.element_exist?($locators[:select_box])
  if res
    $ui.fill_field($locators[:select_box], 'Small')
  end
end