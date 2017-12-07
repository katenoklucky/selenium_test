Then /^I close the browser via UI$/ do
  $ui.close_browser
end

Then /^I login under admin$/ do
  $ui.go_to_url 'http://localhost/litecart/admin'
  $ui.find_element(:name, 'username').send_keys 'admin'
  $ui.find_element(:name, 'password').send_keys 'admin'
  $ui.find_element(:name, 'login').click
  $ui.wait_for_title('My Store')
end

Then /^I open site$/ do
  $ui.go_to_url 'http://litecart.stqa.ru/index.php/en/'
  $ui.wait_for_title('Online Store | My Store')
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