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
          result = $ui.find_element($locators[:setting_name]).text
          @main_settings[:name] = result
        end

        if setting == 'regular price'
          result = $ui.find_element($locators[:setting_regular_price]).text
          @main_settings[:regular_price] = result
        end

        if setting == 'promotional price'
          result = $ui.find_element($locators[:setting_promotional_price]).text
          @main_settings[:promotional_price] = result
        end

        if setting == 'color of regular price'
          price = $ui.find_element($locators[:setting_regular_price])
          color = get_element_style(price, 'color').match(/\((.*)\)/)[0].split(', ')
          color.map! {|el| el.gsub(/\D/, '')}
          color[0] == color[1] && color[0] == color[2] ? result = 'grey' : result = 'not grey'
          @main_settings[:color_regular_price] = result
        end

        if setting == 'text-decoration of regular price'
          price = $ui.find_element($locators[:setting_regular_price])
          get_element_style(price, 'text-decoration').include? 'line-through' ? result = 'line-through' : result = 'not line-through'
          @main_settings[:strike_regular_price] = result
        end

        if setting == 'font-size of regular price'
          price = $ui.find_element($locators[:setting_regular_price])
          result = get_element_style(price, 'font-size').gsub('px', '').to_f
          @main_settings[:font_size_regular_price] = result
        end

        if setting == 'color of promotional price'
          price = $ui.find_element($locators[:setting_promotional_price])
          color = get_element_style(price, 'color').match(/\((.*)\)/)[0].split(', ')
          color.map! {|el| el.gsub(/\D/, '')}
          result = 'red' if color[1] == color[2]
          @main_settings[:color_promotional_price] = result
        end

        if setting == 'font-weight of promotional price'
          price = $ui.find_element($locators[:setting_promotional_price])
          price.tag_name == 'strong' ? result = 'bold' : result = 'thin'
          @main_settings[:weight_promotional_price] = result
        end

        if setting == 'font-size of promotional price'
          price = $ui.find_element($locators[:setting_promotional_price])
          result = get_element_style(price, 'font-size').gsub('px', '').to_f
          @main_settings[:font_size_promotional_price] = result
        end

      when 'item'
        if setting == 'name'
          result = $ui.find_element($locators[:setting_item_name]).text
          @item_settings[:name] = result
        end

        if setting == 'regular price'
          result = $ui.find_element($locators[:setting_item_regular_price]).text
          @item_settings[:regular_price] = result
        end

        if setting == 'promotional price'
          result = $ui.find_element($locators[:setting_item_promotional_price]).text
          @item_settings[:promotional_price] = result
        end

        if setting == 'color of regular price'
          price = $ui.find_element($locators[:setting_item_regular_price])
          color = get_element_style(price, 'color').match(/\((.*)\)/)[0].split(', ')
          color.map! {|el| el.gsub(/\D/, '')}
          color[0] == color[1] && color[0] == color[2] ? result = 'grey' : result = 'not grey'
          @item_settings[:color_regular_price] = result
        end

        if setting == 'text-decoration of regular price'
          price = $ui.find_element($locators[:setting_item_regular_price])
          get_element_style(price, 'text-decoration').include? 'line-through' ? result = 'line-through' : result = 'not line-through'
          @item_settings[:strike_regular_price] = result
        end

        if setting == 'color of promotional price'
          price = $ui.find_element($locators[:setting_item_promotional_price])
          color = get_element_style(price, 'color').match(/\((.*)\)/)[0].split(', ')
          color.map! {|el| el.gsub(/\D/, '')}
          result = 'red' if color[1] == color[2]
          @item_settings[:color_promotional_price] = result
        end

        if setting == 'font-weight of promotional price'
          price = $ui.find_element($locators[:setting_item_promotional_price])

          price.tag_name == 'strong' ? result = 'bold' : result = 'thin'
          @item_settings[:weight_promotional_price] = result
        end

        if setting == 'font-size of regular price'
          price = $ui.find_element($locators[:setting_item_promotional_price])
          result = get_element_style(price, 'font-size').gsub('px', '').to_f
          @item_settings[:font_size_regular_price] = result
        end

        if setting == 'font-size of promotional price'
          price = $ui.find_element($locators[:setting_item_promotional_price])
          result = get_element_style(price, 'font-size').gsub('px', '').to_f
          @item_settings[:font_size_promotional_price] = result
        end
    end
    raise "Setting '#{setting}' does not get!" if result.nil?
    puts "Setting '#{setting}': #{result}"
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

Then /^I fill "(.+)" tab with the following settings:$/ do |tab_name, table|
  $ui.find_elements($ui.find_element($locators[:body]), tag_name: 'a').select {|el| el.text == tab_name}.first.click
  settings = table.hashes
  settings.each do |setting|
    value = setting[:value]
    case setting[:setting]
      when 'status'
        value == 'enabled' ? element = '#tab-general label:nth-child(3)' : element = '#tab-general label:nth-child(4)'
        $ui.find_element(:css, element).click
      when 'name'
        element = '#tab-general input[name="name[en]"]'
        $ui.fill_field(:css, element, value)
      when 'code'
        element = '#tab-general input[name="code"]'
        $ui.fill_field(:css, element, value)
      when 'categories'
        elements = []
        expected_values = value.split(',')
        expected_values.each do |expected_value|
          table = $ui.find_element(:css, '#tab-general table tr:nth-child(4) table')
          elements.push($ui.find_elements(table, tag_name: 'input').select {|el| el.attribute('data-name') == expected_value}.first)
          elements.each do |el|
            $ui.fill_field(el, 'check')
          end
        end
      when 'default_category'
        element = '#tab-general select[name="default_category_id"]'
        $ui.fill_field(:css, element, value)
      when 'product_groups'
        res_value = nil
        elements = []
        expected_values = value.split(',')
        expected_values.each do |expected_value|
          case expected_value
            when 'Female'
              res_value = '1-2'
            when 'Male'
              res_value = '1-1'
            when 'Unisex'
              res_value = '1-3'
          end
          table = $ui.find_element(:css, '#tab-general table tr:nth-child(7) table')
          elements.push($ui.find_elements(table, tag_name: 'input').select {|el| el.attribute('value') == res_value}.first)
          elements.each do |el|
            $ui.fill_field(el, 'check')
          end
        end
      when 'quantity'
        element = '#tab-general input[name="quantity"]'
        $ui.fill_field(:css, element, value)
      when 'quantity_unit'
        element = '#tab-general select[name="quantity_unit_id"]'
        $ui.fill_field(:css, element, value)
      when 'delivery_status'
        element = '#tab-general select[name="delivery_status_id"]'
        $ui.fill_field(:css, element, value)
      when 'sold_out_status'
        element = '#tab-general select[name="sold_out_status_id"]'
        $ui.fill_field(:css, element, value)
      when 'image_path'
        file_name = "#{File.absolute_path('images')}/#{value}"
        element = '#tab-general input[name="new_images[]"]'
        $ui.fill_field(:css, element, file_name)
      when 'date_valid_from'
        element = '#tab-general input[name="date_valid_from"]'
        $ui.fill_field(:css, element, value)
      when 'date_valid_to'
        element = '#tab-general input[name="date_valid_to"]'
        $ui.fill_field(:css, element, value)
      when 'manufacturer'
        element = '#tab-information select[name="manufacturer_id"]'
        $ui.fill_field(:css, element, value)
      when 'supplier'
        element = '#tab-information select[name="supplier_id"]'
        $ui.fill_field(:css, element, value)
      when 'keywords'
        element = '#tab-information input[name="keywords"]'
        $ui.fill_field(:css, element, value)
      when 'short_description'
        element = '#tab-information input[name="short_description[en]"]'
        $ui.fill_field(:css, element, value)
      when 'description'
        element = '#tab-information textarea[name="description[en]"]'
        $ui.fill_field(:css, element, value)
      when 'head_title'
        element = '#tab-information input[name="head_title[en]"]'
        $ui.fill_field(:css, element, value)
      when 'meta_description'
        element = '#tab-information input[name="meta_description[en]"]'
        $ui.fill_field(:css, element, value)
      when 'price'
        element = '#tab-prices input[name="purchase_price"]'
        $ui.fill_field(:css, element, value)
      when 'price_currency_code'
        element = '#tab-prices select[name="purchase_price_currency_code"]'
        $ui.fill_field(:css, element, value)
      when 'tax_class_id'
        element = '#table-prices select[name="tax_class_id"]'
        $ui.fill_field(:css, element, value)
      when 'gross_prices_usd'
        element = '#tab-prices input[name="gross_prices[USD]"]'
        $ui.fill_field(:css, element, value)
      when 'gross_prices_eur'
        element = '#tab-prices input[name="gross_prices[EUR]"]'
        $ui.fill_field(:css, element, value)
    end
  end

end

Then /^I get count of cart/ do
  @items_in_cart = $ui.find_element($locators[:count_of_cart]).text.to_i
end

Then /^I wait until count of cart was updated/ do
  item_count_before = @items_in_cart
  $ui.wait_for do
    actual_item_count = $ui.find_element($locators[:count_of_cart]).text.to_i
    item_count_before != actual_item_count
  end
end

Then /^I delete all items from cart$/ do
  $ui.wait_for do
    $ui.find_elements($ui.find_element($locators[:body]), tag_name: 'button').select {|el| el.text == 'Remove'}.first.click
    summary_wrapper = $ui.find_element($locators[:summary_wrapper])
    $ui.wait_for_element_not_exist(summary_wrapper)
    $ui.is_element_displayed?($locators[:summary_wrapper_em])
  end
end