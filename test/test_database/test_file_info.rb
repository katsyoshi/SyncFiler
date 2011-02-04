# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/../test_helper.rb'

class TC_FileInfo < Test::Unit::TestCase
	def setup
		@db=SyncFiler::DB::FileInfo.new
		@db.connect_file_db
		@db.create_table
	end
	
	def teardown
		@db.drop_table "fileinfo" unless @db.is_connected?
		@db.disconnect_file_db
	end

	def test_is_connected?
		assert !@db.is_connected?, "NG"
		assert !@db.closed?, "NG"
	end

	def test_create_table
		assert @db.create_table, "NG"
	end
	
	def test_connect_file_db
		assert @db.connect_file_db, "NG"
	end
	
	def test_drop_table
		assert @db.drop_table, "NG"
	end

	# def test_write_table
	# 	assert @db.write_table, "NG"
	# end
	def test_disconnect_file_db
		@db.connect_file_db
		assert @db.disconnect_file_db, "NG"
	end
	def test_get_db_info
		assert @db.get_db_info, "NG"
	end

	def test_get_file_list
		assert @db.get_file_list, "NG"
	end
	
	def test_write_file_info
		tp = {:id => "2b5e8dbf35a784f26753527c60945e019227e029", 
			:name => "test", :path => './', :size => 2048, :block => 1, :host => 'self' }
		assert @db.write_file_info(tp), "NG"
	end	

	def test_search_db
		# p @db.search_db(:id)
		assert @db.search_db(:id), "NG"
	end
	
	def test_drop_table
		assert @db.drop_table("fileinfo"), "NG"
	end
end

