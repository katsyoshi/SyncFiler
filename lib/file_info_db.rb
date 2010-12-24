# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/syncfiler.rb'
require 'active_record'
require 'sqlite3'

class SyncFiler::FileInfoDB < ActiveRecord::Base
	def self.load_configurations(conf="~/.syncfiler.d/database.yaml")
		conf = File.expand_path conf
		SyncFiler::Settings.write_db( config ) unless File.exist? conf
		self.configurations = SyncFiler::Settings.read(conf)
	end
end
