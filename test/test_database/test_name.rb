#!/usr/bin/env ruby
require 'test/unit'
require File.dirname(__FILE__)+'/../test_helper.rb'

class TC_Name < Test::Unit::TestCase
	def setup
		@dns = SyncFiler::DB::NameInfo.new
	end

	def teardown
		@dns.disconnect_database if @dns.closed?
		@dns.close
	end

	def test_connect_database
		assert @dns.connect_database, "NG"
	end

	def test_create_table
		assert @dns.create_table, "NG"
	end

	def test_write_name_info
		name = "localhost"
		ip = "192.168.168.2"
		domain = "ds.cs.toyo.ac.jp"
		hs = {"name" => name, "addr" => ip, "domain" => domain }
		assert @dns.write_name_info( hs ), "NG" 
	end

	def test_drop_table
		assert @dns.drop_table( "nameinfo" ), "NG"
	end
end
