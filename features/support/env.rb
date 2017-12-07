$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'require_all'
require 'selenium-webdriver'

require_rel '../../lib'
$browser = ENV['BROWSER'] ? ENV['BROWSER'] : 'firefox'
$ui = UICommon.new

require 'env.rb'
require 'hooks.rb'