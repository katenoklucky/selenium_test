#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'bundler/setup'
require 'find'
require 'trollop'
require 'yaml'
require 'fileutils'

$opts = Trollop.options do
  version 'Version: Runtest 1.0'
  opt :browser, 'Select the browser, can be firefox, chrome', default: 'firefox', type: String
  opt :pretty, 'Prints the feature as is - in colours.', default: true, short: 'n'
  opt :html, 'Generates a nice looking HTML report.', default: false, short: 'h'
  opt :json, 'Generates a JSON report.'
  opt :tags, '', default: ['~@skip'], short: 't'
  opt :config, 'Choose yaml config file', type: String, short: 'c'
  opt :profile, 'Cucumber profile name', type: String
  banner <<-EOS

Example:

   runtest.rb -r TestLab -p Smoke --profile TESTLAB --html --junit --json --testid TL --config axsml.yaml -d gen3_test_data.rb --tags ~@full ~@skip

  EOS
end

current_file_dir = Dir.pwd

Dir.chdir(File.dirname(__FILE__) + "/../features/#{$opts[:project]}")
current_dir = Dir.pwd

$opts[:profile] ||= $opts[:project]

# Form a cmd with parameters to run Cucumber
# We should go to a project's root directory to let Cucumber do its job
cl = "cd #{current_file_dir}/.. && bundle exec cucumber --no-source"

name_suffix = $opts[:testpath] ? $opts[:testpath].split(/\//).last : $opts[:project]

result_dir = current_file_dir + "/../results/#{$opts[:project]}"
report_name = result_dir + "/#{name_suffix}_report.html"
report_json = result_dir + "/#{name_suffix}_report.json"
report_junit = result_dir + "/#{name_suffix}"

FileUtils.mkdir_p result_dir unless File.exist?(result_dir)

cl = cl + ' ' + "\"#{current_dir}\""
# We use profile from cucumber.yml file to specify for Cucumber what to load
cl += " --profile #{$opts[:profile]}"
cl += ' --color'
cl += ' --guess'
cl += ' --expand' if $opts[:expand]
cl += ' --format pretty' if $opts[:pretty]
cl += " PROJECT=#{$opts[:project]}"
cl += " BROWSER=#{$opts[:browser]}"
cl += " LANGUAGE=#{$opts[:language]}" if $opts[:language]
cl += " VIDEO=#{$opts[:video]}" if $opts[:video]
cl += " WEBDRIVER=#{$opts[:driver]}"
cl += " TS=#{$opts[:testpath]}" if $opts[:testpath]
cl += " CONFIG=#{$opts[:config]}" if $opts[:config]
cl += " ENV=#{$opts[:env]}"
cl += " DEVICES=#{$opts[:devices]}"
cl += " DATA=#{$opts[:data]}" if $opts[:data]
cl += " TEST_ID=#{$opts[:testid]}" if $opts[:testid]
cl += " ESX=#{$opts[:esx_hosts]}" if $opts[:esx_hosts]
cl += " VCENTER=#{$opts[:vcenters]}" if $opts[:vcenters]
cl += " BROWSER=#{$opts[:browser]}" if $opts[:browser]
cl += " --format junit --out \"#{report_junit}\"" if $opts[:junit]
cl += " --format html --out \"#{report_name}\"" if $opts[:html]
cl += " --format json --out \"#{report_json}\"" if $opts[:json]
#puts "opts=#{$opts}"
$opts[:tags].each { |index| cl += " --tags #{index}" }

puts "CL = #{cl}"

system(cl)