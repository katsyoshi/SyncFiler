#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/test_helper'

class TC_FileSubmissionServer < Test::Unit::TestCase
	def setup
		@srv = SyncFiler::FileSubmissionServer.new
	end
	
 	# def teardown 
	# 	@srv.close
	# end
	
	def test_get_settings
		assert( @srv.get_settings, "NG" )
	end

	def test_get_file_list
		assert( @srv.get_file_list, "NG" )
	end

	def test_get_file_info
		assert( @srv.get_file_info("test.txt"), "NG" )
	end

	def test_send_div_file
		f = File.open"test.txt",'rb'
		assert( @srv.send_div_file("test.txt",f,0), "NG" )
		f.close
	end
	def test_recieve_div_file
		mb = SyncFiler::FileSubmissionServer::MB
		f = File.read("test.txt",mb).to_msgpack
		assert( !@srv.recieve_div_file("test.txt", f, 'tmp'), "NG" )
	end
end
