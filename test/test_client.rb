#!/usr/bin/env ruby
begin
require 'rubygems'
rescue LoadError
end
require 'test/unit'
$LOAD_PATH.unshift File.dirname(__FILE__)+'/../lib/'
require 'client.rb'

class TestClient < Test::Unit::TestCase
	def setup
		@cl = Client.new '192.168.168.66', 9090
	end

	def teardown
		@cl.connection_cut
	end

	def test_list
		assert( @cl.get_file_list, "NG" )
	end 

	def test_pull
		assert( @cl.pull( "test.html" ), "NG" )
	end
	
	def test_push
		assert( @cl.push( "test.html"), "NG" )
	end
	
	def test_get_db
		assert( @cl.get_db, "NG" )
	end

end
