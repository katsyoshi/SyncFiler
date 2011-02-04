#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'yaml'
module SyncFiler
class Settings 
	def self.read(file="~/.syncfiler.d/settings.yml")
		path = File.expand_path(file)
		config = YAML.load( File.read(File.expand_path(path)) )
	rescue => e
		write_setting_file( nil, {} )
		return e
	else
		return config
	end
	
	def self.write_setting_file( type, hash,
															 path='~/.syncfiler.d/settings.yml' )
		pt = File.expand_path(path)
		data = Hash.new
		data = read(pt) if File.exist? pt
		data[ type ] = hash unless data[type]
		fw = File.open(pt, 'w')
		fw.write YAML.dump data
		fw.write "\n"
		fw.close
	end
end
end
