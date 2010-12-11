# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/test_helper.rb'

class TC_FileDB < Test::Unit::TestCase
	DB="test.db"
	def setup
		@db = SyncFiler::FileDB.new DB # DB接続
	end
	def teardown
		@db.close # DB切断 
	end

	def test_get_list
		assert( @db.get_list("test"), "読み取れなかった" )
	end
	
	def test_write
		txt = "test.txt"
		ary = {:name => txt, :size => File.size(txt), 
			:date => File.ctime( txt ), :visible => 1}
		assert( @db.write( 'test', ary ), "書き込めない!" )
	end

	def test_create_table
		txt = "test"
		assert( @db.create_table( txt ), "作れんぞ" )
	end

	:private
	def test_destroy_table
		txt = "test"
		assert( @db.destroy_table( txt ), "こわせんぞ" )
	end
	
end

