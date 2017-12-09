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