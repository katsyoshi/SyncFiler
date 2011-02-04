#!/usr/bin/env ruby
require 'test/unit'
require File.dirname(__FILE__)+'/../test_helper.rb'

class TC_Name < Test::Unit::TestCase
	def setup
		@dns = SyncFiler::DB::NameInfo.new
	end

	def teardown
		@dns.close
	end

	def test_create_table
		assert @dns.create_table, "NG"
	end

	def test_write_name_info
		assert @dns.write_name_info( hs ), "NG" 
	end

	def test_drop_table
		assert @dns.drop_table( "nameinfo" ), "NG"
	end
end
