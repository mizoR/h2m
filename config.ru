$:.unshift(File.dirname(__FILE__))
$:.unshift(File.dirname(__FILE__) + '/lib')

require "2ascii"
require "app"

run App
