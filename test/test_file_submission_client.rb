#!/usr/bin/env ruby
require File.dirname(__FILE__)+'/test_helper.rb'

class TestClient < Test::Unit::TestCase
	def setup
		@cl = SyncFiler::FileSubmissionClient.new '192.168.168.66', 9090
	end

	def teardown
		@cl.connection_cut
	end

	def test_get_file_list
		assert( @cl.get_file_list, "NG" )
	end 

	def test_recieve_div_file
		assert( @cl.recieve_div_file( "test.html" ), "NG" )
	end
	
	def test_send_div_file
		assert( @cl.send_div_file( "test.html"), "NG" )
	end
	
	def test_get_file_info
		assert( @cl.get_db, "NG" )
	end

end
