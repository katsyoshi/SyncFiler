#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/test_helper.rb'

class TC_FileSubmissionClient < Test::Unit::TestCase
	# class Server
	
	# def start
	# 	@srv = MessagePack::RPC::Server.new 
	# 	@srv.listen( '0.0.0.0', 9090, SyncFiler::FileSubmission::Server.new )
	# 	# end
	# 	Thread.start do
	# 		@srv.run
	# 		@srv.close
	# 	end
	# 	@cl = SyncFiler::FileSubmission::Client.new 
	# 	@cl.connect_server
	# end
	
	# def set_server
	# 	@srv = MessagePack::RPC::Server.new
	# 	@srv.listen( '0.0.0.0', 9090, SyncFiler::FileSubmission::Server.new )
	# 	Thread.start do
	# 		@srv.run
	# 		@srv.close
	# 	end
	# end
	
	def setup
		# if !@srv
		@cl = SyncFiler::FileSubmission::Client.new
		@cl.connect_server
	end
	
	# def test_0000
	# 	set_server
	# end
	
	# def setup
	# 	start_server
	# end

	def teardown
		# @th.join
		# @svr.close
		# p @srv
		# @cl.close
		# @cl = nil
		# @srv = nil
		@cl.disconnect_server
		# @cl.close
	end
	
	# def test_connect_server
	# 	# assert( @cl.connect_server, "NG" )
	# end

	# def test_disconnect_server
	# 	# p @cl
	# 	# assert( @cl.disconnect_server, "NG" )
	# end

	def test_get_file_list
		fl = @cl.get_file_list
		assert( fl, "NG" )
		# @cl.close
		# @srv.stop
	end 

	def test_recieve_file
		assert( @cl.recieve_file( "test.html" ), "NG" )
		p @cl
		# @cl.close
		# @srv.stop
	end
	
	def test_send_file
		assert( @cl.send_file( "test.html"), "NG" )
		p @cl
		# @cl.close
		# @srv.stop
	end
	
	def test_get_file_info
		# name = "test.db"
		p @cl
		# assert( @cl.get_file_info(name), "NG" )
	end

	def test_get_server_info
		assert( @cl.get_server_info, "NG" )
		p @cl
	end
end
