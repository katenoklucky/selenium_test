Then /^I login under admin on site "(.+)" with title "(.+)"$/ do |url, title|
  $ui.go_to_url url
  $ui.find_element($locators[:login_username]).send_keys $login_data[:login]
  $ui.find_element($locators[:login_password]).send_keys $login_data[:password]
  $ui.find_element($locators[:login]).click
  $ui.wait_for_title(title)
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

Then /^I verify "(.+)" items exists in catalog by path:$/ do |item_name, table|
  table.raw.each do |item_path|
    path = item_path[0].split('/')
    path.each do |folder_name|
      table = $ui.find_element(:css, '#content .dataTable')
      $ui.find_elements(table, tag_name: 'a').select {|el| el.text == folder_name}.first.click
    end
    result = nil
    table = $ui.find_element(:css, '#content .dataTable')
    elements = $ui.find_elements(table, tag_name: 'a')
    elements.each do |el|
      el.text == item_name
      result = true
      break
    end
    raise "Cannot find #{item_name} by path '#{item_path}'!" unless result
  end
end

Then /^I click on Edit for "(.+)" country$/ do |country_name|
  table = $ui.find_element($locators[:table])
  country_trs_count = $ui.find_elements(table, css: 'tr').length
  (2..country_trs_count-2).each do |tr_num|
    name = $ui.find_element(:css, "tr:nth-child(#{tr_num}) > td:nth-child(5) > a").text
    if name == country_name
      $ui.find_element(:css, "tr:nth-child(#{tr_num}) > td:nth-child(7) > a").click
      break
    end
  end
end

Then /^I open all windows$/ do
  links = $ui.find_elements($ui.find_element($locators[:body]), css: '.fa-external-link')
  links.each do |link|
    $ui.remember_window
    link.click
    $ui.go_to_new_window
    $ui.wait_for_title_exist
    puts "Opened page with title '#{$ui.get_title}'"
    $ui.close_window
    $ui.return_to_window
  end
end

Then /^I open each folder$/ do
  table = $ui.find_element(:css, '#content .dataTable')
  items_count = $ui.find_elements(table, tag_name: 'td').length
  (0..items_count).each do |i|
    table = $ui.find_element(:css, '#content .dataTable')
    item = $ui.find_elements(table, tag_name: 'td')[i]
    fa_length = $ui.find_elements(item, class: 'fa-folder').length
    if fa_length > 0
      a_length = $ui.find_elements(item, tag_name: 'a').length
      if a_length > 0
        text = $ui.find_elements(item, tag_name: 'a').first.text
        $ui.find_elements(item, tag_name: 'a').first.click
        puts "Clicked on #{text}"
      end
    end
  end
end

Then /^I open each item and verify logs$/ do
  result = []
  table = $ui.find_element(:css, '#content .dataTable')
  items_count = $ui.find_elements(table, tag_name: 'td').length
  (0..items_count).each do |i|
    table = $ui.find_element(:css, '#content .dataTable')
    item = $ui.find_elements(table, tag_name: 'td')[i]
    if item
      img_length = $ui.find_elements(item, tag_name: 'img').length
      if img_length > 0
        a_length = $ui.find_elements(item, tag_name: 'a').length
        if a_length > 0
          page_name = $ui.find_elements(item, tag_name: 'a').first.text
          $ui.find_elements(item, tag_name: 'a').first.click
          puts "Opened item: #{page_name}"
          logs = $ui.get_browser_logs
          if logs.length > 0
            hash = {}
            hash[page_name] = []
            logs.each do |el|
              hash[page_name] << el
            end
            result << hash
          end
          $ui.find_elements($ui.find_element($locators[:body]), tag_name: 'button').select {|element| element.text == 'Cancel'}.first.click
        end
      end
    end
  end
  if result.empty?
    puts 'All pages do not have any errors'
  else
    result.each do |el|
      el.each do |k, v|
        puts "Page '#{k}' has errors:\n"
        v.each { |element| puts element}
      end
    end
  end
end