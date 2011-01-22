#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'yaml'
# require File.dirname(__FILE__)+'/syncfiler.rb'

module SyncFiler
class Settings
	# def initialize(path="~/.syncfiler.d")
	# 	@file = File.expand_path path
	# end

	def self.read(file)
		@config = YAML.load( File.read(File.expand_path(file)) )
	rescue => e
		return e
	end
	
	def exist?(path=@file)
		Dir.mkdir(path) unless Dir.exist? path
	end

	def self.write_setting_file(path, hash = {'default' => "SyncFiles", 
																'max_file_size' => 10, 'port_no' => 9090} )
		p = File.expand_path(path)
		h = hash
		fw = File.open(p,'w')
		fw.write YAML.dump h
		fw.close
	end
	
	def self.write_client(client, ch={'default' => "SyncFiles", 
													'server_addr' => nil, 
													'port_no' => 9090})
		write_setting_file(client , ch)
	end
	
	def self.write_server(server, sh={'default' => "SyncFiles", 
													'port_no' => 9090} )
		write_setting_file(server,sh)
	end

	def self.write_db(database, 
										db={:adapter => 'sqlite3', 
											:database => '~/.syncfiler.d/file_info.db'} )
		db[:database] = File.expand_path db[:database]
		write_setting_file(database, db)
	end
	
end
end
