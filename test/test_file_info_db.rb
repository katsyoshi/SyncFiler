# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/test_helper.rb'

class TC_FileInfo < Test::Unit::TestCase
	def setup
		@db=SyncFiler::FileSubmissionServer.new
		@db.connect_file_db
	end
	
	def teardown
	end

	def test_create_table
		# @db.connect_file_db
		assert @db.create_table, "NG"
	end
	
	def test_connect_file_db
		assert @db.connect_file_db, "NG"
	end
	
	def test_drop_table
		assert @db.drop_table, "NG"
	end

	def test_write_table
		assert @db.write_table, "NG"
	end
	def test_get_db_info
		assert @db.get_db_info, "NG"
	end

	def test_get_file_list
		assert @db.get_file_list, "NG"
	end
	
	def test_write_file_info
		dbup
		assert @db.write_file_info, "NG"
	end	

	def test_search_db
		assert @db.search_db, "NG"
	end

	def test_drop_table
		assert @db.drop_table, "NG"
	end
end

