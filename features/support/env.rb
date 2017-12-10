$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'require_all'
require 'selenium-webdriver'

require_rel '../../lib'
$ui = UICommon.new

require 'env.rb'
require 'hooks.rb'