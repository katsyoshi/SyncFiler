#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/test_helper.rb'

class TC_FileSubmissionClient < Test::Unit::TestCase
	# class Server
	
	def setup
		# if !@srv
		@srv = MessagePack::RPC::Server.new 
		@srv.listen( '0.0.0.0', 9090, SyncFiler::FileSubmission::Server.new )
		# end
		@th = Thread.start do
			@srv.run
			@srv.close
		end
		@cl = SyncFiler::FileSubmission::Client.new 
		@cl.connect_server
		p @cl.client
	end
	
	# def setup
	# 	start_server
	# end

	def teardown
		# @th.join
		# @svr.close
		# p @srv
		@cl.close
		@cl = nil
		@srv = nil
		# @srv.stop
		# @cl.disconnect_server
	end
	
	def test_connect_server
		# assert( @cl.connect_server, "NG" )
	end

	def test_disconnect_server
		# p @cl
		# assert( @cl.disconnect_server, "NG" )
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
		# name = "test.db"
		# assert( @cl.get_file_info(name), "NG" )
	end

	def test_get_server_info
		assert( @cl.get_server_info, "NG" )
	end
end
