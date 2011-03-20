#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/test_helper.rb'

class TC_FileSubmissionClient < Test::Unit::TestCase
	
	def setup
		@cl = SyncFiler::FileSubmission::Client.new
		@cl.connect_server
	end

	def teardown
		@cl.disconnect_server
	end
	
	def test_get_file_list
		fl = @cl.get_file_list
		assert( fl, "NG" )
	end 

	def test_recieve_file
		assert( @cl.recieve_file( "test.html" ), "NG" )
		p @cl
	end
	
	def test_send_file
		assert( @cl.send_file( "test.html"), "NG" )
		p @cl
	end
	
	def test_get_file_info
		p @cl
	end

	def test_get_server_info
		assert( @cl.get_server_info, "NG" )
		p @cl
	end
end
