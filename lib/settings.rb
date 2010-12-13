#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'yaml'
require File.dirname(__FILE__)+'/syncfiler.rb'

class SyncFiler::Settings
	def initialize(path="~/.syncfiler.d")
		@file = File.expand_path path
	end
	
	def read()
		str = File.read(@file+'/settings.yaml')
		@settings = YAML.load str
	end
	
	def exist?(path="~/.syncfiler.d")
		exp = File.expand_path path
		Dir.mkdir(exp) unless Dir.exist? exp
		file = exp+'/settings.yaml'
		touch_file(file) unless File.exist? file
	end

	def touch_file(path, hash = {'default' => "SyncFiles", 
									 'max_file_size' => 10, 'port_no' => 9090} )
		h = hash
		fw = File.open(path,'w')
		fw.write YAML.dump h
		fw.close
	end
end
