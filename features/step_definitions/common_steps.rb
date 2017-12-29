Then /^I close the browser via UI$/ do
  $ui.close_browser
end

Then /^I open site "(.+)" with title "(.+)"$/ do |url, title|
  $ui.go_to_url url
  $ui.wait_for_title title
end

Then /^I use "(.+)" browser$/ do |browser|
  $ui.set_profile(browser)
end