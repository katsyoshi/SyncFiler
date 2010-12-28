#!/usr/bin/env ruby
require 'active_record'
require File.dirname(__FILE__)+'/../syncfiler'

class SyncFiler::DB::FileInfoDB < ActiveRecord::Migration
	def self.up
		create_table :file_infos do |t|
			t.string :id, :name, :path
			t.int :size
			t.date :date
		end
	end
	
	def self.down
		drop_table :file_infos
	end
end
