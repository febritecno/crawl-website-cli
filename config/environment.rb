# load ruby dependency
require 'httparty'
require 'nokogiri'
require "pry"
require 'require_all'
require 'sqlite3'

#load sqlite connection
require "./config/connector"

#load modules in a folder [ lib ]
require_all './lib/'
