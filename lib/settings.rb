#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'yaml'
require File.dirname(__FILE__)+'/syncfiler.rb'

class SyncFiler::Settings
	def initialize(path="~/.syncfiler.d")
		@file = File.expand_path path
	end

	def read(file="client.yaml")
		str = File.read(@file+"/#{file}")
		@settings = YAML.load str
	rescue => e
		return e
	end
	
	def exist?(path=@file)
		Dir.mkdir(path) unless Dir.exist? path
	end

	def write_setting_file(path, hash = {'default' => "SyncFiles", 
									 'max_file_size' => 10, 'port_no' => 9090} )
		p = @file + "/" + path
		h = hash
		fw = File.open(p,'w')
		fw.write YAML.dump h
		fw.close
	end
	
	def write_client(client, ch={'default' => "SyncFiles", 
										 'server_addr' => nil, 
										 'port_no' => 9090})
		write_setting_file(client , ch)
	end

	def write_server(server, sh={'default' => "SyncFiles", 
										 'port_no' => 9090}
										 )
		write_setting_file(server,sh)
	end
end
