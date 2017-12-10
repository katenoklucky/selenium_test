Then /^I close the browser via UI$/ do
  $ui.close_browser
end

Then /^I login under admin on site "(.+)" with title "(.+)"$/ do |url, title|
  $ui.go_to_url url
  $ui.find_element(:name, 'username').send_keys 'admin'
  $ui.find_element(:name, 'password').send_keys 'admin'
  $ui.find_element(:name, 'login').click
  $ui.wait_for_title(title)
end

Then /^I open site "(.+)" with title "(.+)"$/ do |url, title|
  $ui.go_to_url url
  $ui.wait_for_title title
end

Then /^I click on each menu and verify existing "(.+)" tag$/ do |tag|
  menu = $ui.find_element(:id, 'box-apps-menu')
  menus = $ui.find_elements(menu, tag_name: 'li')
  menus.each_with_index do |_el, menu_index|
    css_menu = "#box-apps-menu > li:nth-child(#{menu_index + 1})"
    menu_item = $ui.find_element(:css, css_menu)
    puts "Selected #{menu_item.text} menu"
    menu_item.click
    menu_item = $ui.find_element(:css, css_menu)
    sub_menus = $ui.find_elements(menu_item, tag_name: 'li')
    unless sub_menus.nil?
      sub_menus.each_with_index do |_el, sub_menu_index|
        css_sub_menu = "#{css_menu} > ul > li:nth-child(#{sub_menu_index + 1})"
        menu_item = $ui.find_element(:css, css_sub_menu)
        puts "Selected #{menu_item.text} sub-menu"
        menu_item.click
      end
    end
    result = $ui.element_exist?(:css, "#content > #{tag}")
    if result
      puts 'Success! Page has H1 tag.'
    else
      raise "ERROR: H1 does not exist for #{menu_item.text}!"
    end

  end
end

Then /^I verify all stickers on opened page$/ do
  page = $ui.find_element(:id, 'page')
  images = $ui.find_elements(page, class: 'image-wrapper')
  images.each do |el|
    result = $ui.find_elements(el, class: 'sticker').length
    raise "Image #{el.attribute('title')} does not have sticker!" if result == 0
    raise "Image #{el.attribute('title')} has more stickers than 1!" if result > 1
  end
end

Then /^I verify countries order is (ascending|descending)$/ do |order|
  countries_array = []
  table = $ui.find_element(:css, 'table')
  trs_count = $ui.find_elements(table, css: 'tr').length
  (2..trs_count-2).each do |tr_num|
    countries_array.push($ui.find_element(:css, "tr:nth-child(#{tr_num}) > td:nth-child(5)").text)
  end
  case order
    when 'ascending'
      result = ascending?(countries_array)
      raise 'Order is not ascending!' unless result
    when 'descending'
      result = descending?(countries_array)
      raise 'Order is not descending!' unless result
  end
end

Then /^I verify countries order is (ascending|descending) in not null zones$/ do |order|
  table = $ui.find_element(:css, 'table')
  trs_count = $ui.find_elements(table, css: 'tr').length
  (2..trs_count-2).each do |tr_num|
    zone = $ui.find_element(:css, "tr:nth-child(#{tr_num}) > td:nth-child(6)").text.to_i
    if zone > 0
      $ui.find_element(:css, "tr:nth-child(#{tr_num}) > td:nth-child(5) > a").click
      zones_array = []
      table = $ui.find_element(:id, 'table-zones')
      zones_trs_count = $ui.find_elements(table, css: 'tr').length
      (2..zones_trs_count-1).each do |tr_number|
        zones_array.push($ui.find_element(:css, "tr:nth-child(#{tr_number}) > td:nth-child(3)").text)
      end
      case order
        when 'ascending'
          result = ascending?(zones_array)
          raise 'Order is not ascending!' unless result
        when 'descending'
          result = descending?(zones_array)
          raise 'Order is not descending!' unless result
      end
      $ui.find_element(:name, 'cancel').click
    end
  end
end

Then /^I verify zones order is (ascending|descending) for each county$/ do |order|
  table = $ui.find_element(:css, 'table')
  country_trs_count = $ui.find_elements(table, css: 'tr').length
  (2..country_trs_count-2).each do |tr_num|
    $ui.find_element(:css, "tr:nth-child(#{tr_num}) > td:nth-child(3) > a").click
    zones_array = []
    table = $ui.find_element(:id, 'table-zones')
    zones_trs_count = $ui.find_elements(table, css: 'tr').length
    (2..zones_trs_count-1).each do |tr_number|
      zone_options = $ui.find_element(:css, "tr:nth-child(#{tr_number}) > td:nth-child(3) > select").find_elements(tag_name: 'option')
      zone_options.each { |option| zones_array.push(option.text) if option.attribute('selected') }
    end
    case order
      when 'ascending'
        result = ascending?(zones_array)
        raise 'Order is not ascending!' unless result
      when 'descending'
        result = descending?(zones_array)
        raise 'Order is not descending!' unless result
    end
    $ui.find_element(:name, 'cancel').click
  end
end

Then /^I get settings for the item on (main|item) page:$/ do |page, table|
  @main_settings = {} unless @main_settings
  @item_settings = {} unless @item_settings
  settings = table.raw
  settings.map do |el|
    setting = el[0]
    result = nil
    case page
      when 'main'
        if setting == 'name'
          result = $ui.find_element(:css, '#box-campaigns > div > ul > li > a.link > div.name').text
          @main_settings[:name] = result
        end

        if setting == 'regular price'
          result = $ui.find_element(:css, 'ul.listing-wrapper > li.product .regular-price').text
          @main_settings[:regular_price] = result
        end

        if setting == 'promotional price'
          result = $ui.find_element(:css, 'ul.listing-wrapper > li.product .campaign-price').text
          @main_settings[:promotional_price] = result
        end

        if setting == 'color of regular price'
          price = $ui.find_element(:css, 'ul.listing-wrapper > li.product .regular-price')
          color = get_element_style(price, 'color').match(/\((.*)\)/)[0].split(', ')
          color.map! {|el| el.gsub(/\D/, '')}
          color[0] == color[1] && color[0] == color[2] ? result = 'grey' : result = 'not grey'
          @main_settings[:color_regular_price] = result
        end

        if setting == 'text-decoration of regular price'
          price = $ui.find_element(:css, 'ul.listing-wrapper > li.product .regular-price')
          get_element_style(price, 'text-decoration').include? 'line-through' ? result = 'line-through' : result = 'not line-through'
          @main_settings[:strike_regular_price] = result
        end

        if setting == 'font-size of regular price'
          price = $ui.find_element(:css, 'ul.listing-wrapper > li.product .regular-price')
          result = get_element_style(price, 'font-size').gsub('px', '').to_f
          @main_settings[:font_size_regular_price] = result
        end

        if setting == 'color of promotional price'
          price = $ui.find_element(:css, 'ul.listing-wrapper > li.product .campaign-price')
          color = get_element_style(price, 'color').match(/\((.*)\)/)[0].split(', ')
          color.map! {|el| el.gsub(/\D/, '')}
          result = 'red' if color[1] == color[2]
          @main_settings[:color_promotional_price] = result
        end

        if setting == 'font-weight of promotional price'
          price = $ui.find_element(:css, 'ul.listing-wrapper > li.product .campaign-price')
          price.tag_name == 'strong' ? result = 'bold' : result = 'thin'
          @main_settings[:weight_promotional_price] = result
        end

        if setting == 'font-size of promotional price'
          price = $ui.find_element(:css, 'ul.listing-wrapper > li.product .campaign-price')
          result = get_element_style(price, 'font-size').gsub('px', '').to_f
          @main_settings[:font_size_promotional_price] = result
        end

      when 'item'
        if setting == 'name'
          result = $ui.find_element(:css, '#box-product .title').text
          @item_settings[:name] = result
        end

        if setting == 'regular price'
          result = $ui.find_element(:css, '#box-product .regular-price').text
          @item_settings[:regular_price] = result
        end

        if setting == 'promotional price'
          result = $ui.find_element(:css, '#box-product .campaign-price').text
          @item_settings[:promotional_price] = result
        end

        if setting == 'color of regular price'
          price = $ui.find_element(:css, '#box-product .regular-price')
          color = get_element_style(price, 'color').match(/\((.*)\)/)[0].split(', ')
          color.map! {|el| el.gsub(/\D/, '')}
          color[0] == color[1] && color[0] == color[2] ? result = 'grey' : result = 'not grey'
          @item_settings[:color_regular_price] = result
        end

        if setting == 'text-decoration of regular price'
          price = $ui.find_element(:css, '#box-product .regular-price')
          get_element_style(price, 'text-decoration').include? 'line-through' ? result = 'line-through' : result = 'not line-through'
          @item_settings[:strike_regular_price] = result
        end

        if setting == 'color of promotional price'
          price = $ui.find_element(:css, '#box-product .campaign-price')
          color = get_element_style(price, 'color').match(/\((.*)\)/)[0].split(', ')
          color.map! {|el| el.gsub(/\D/, '')}
          result = 'red' if color[1] == color[2]
          @item_settings[:color_promotional_price] = result
        end

        if setting == 'font-weight of promotional price'
          price = $ui.find_element(:css, '#box-product .campaign-price')

          price.tag_name == 'strong' ? result = 'bold' : result = 'thin'
          @item_settings[:weight_promotional_price] = result
        end

        if setting == 'font-size of regular price'
          price = $ui.find_element(:css, '#box-product .regular-price')
          result = get_element_style(price, 'font-size').gsub('px', '').to_f
          @item_settings[:font_size_regular_price] = result
        end

        if setting == 'font-size of promotional price'
          price = $ui.find_element(:css, '#box-product .campaign-price')
          result = get_element_style(price, 'font-size').gsub('px', '').to_f
          @item_settings[:font_size_promotional_price] = result
        end
    end
    raise "Setting '#{setting}' does not get!" if result.nil?
    puts "Setting '#{setting}': #{result}"
  end
end

Then /^I navigate to "Yellow Duck" item/ do
  el = $ui.find_element(:css, '#box-campaigns > div > ul > li > a.link')
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

Then /^I use "(.+)" browser$/ do |browser|
  $ui.set_profile(browser)
end