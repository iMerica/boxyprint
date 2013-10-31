$:.unshift File.dirname(__FILE__)
require 'app'
reqiore 'rack'

run BoxyPrint::App
