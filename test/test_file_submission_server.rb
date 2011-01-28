#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/test_helper'

class TC_FileSubmissionServer < Test::Unit::TestCase
	SEND_FILE="file.dd"
	def setup
		@srv = SyncFiler::FileSubmission::Server.new
		@file=SEND_FILE
	end
	
	def teardown 
		@srv.close
	end
	
	def test_send_file
		s = Time.now
		assert(@srv.send_file(@file, 0), "NG")
		puts (Time.now - s).to_s + "s"
	end
	
	def test_recieve_file
		s = Time.now
		size = File.stat(@file).size/@srv.vol[:block]
		th = Array.new
		(0..size).each do |x| 
			th << @srv.send_file(@file,x)
		end
		th.each do |x|
			@srv.recieve_file(x, "rev.dd")
		end
		diff = open(@file).readlines - open("rev.dd").readlines
		assert(diff.empty?, "NG")
		puts (Time.now - s ).to_s + "s"
	end
	
	def test_send_server_vol
		assert(@srv.send_server_vol, "NG")
	end

	def test_send_server_conf
		assert(@srv.send_server_conf, "NG")
	end
	
	def test_db_up
		assert(@srv.db_up, "NG")
	end

	def test_send_server_conf
		assert(@srv.send_server_conf, "NG")
	end

	def test_db_inf
		assert(@srv.send_db_info, "NG")
	end

	# def test_get_settings
	# 	assert( @srv.get_settings, "NG" )
	# end

	# def test_get_file_list
	# 	assert( @srv.get_file_list, "NG" )
	# end

	# def test_get_file_info
	# 	assert( @srv.get_file_info("test.txt"), "NG" )
	# end

	# def test_send_div_file
	# 	f = File.open"test.txt",'rb'
	# 	assert( @srv.send_div_file("test.txt",f,0), "NG" )
	# 	f.close
	# end
	# def test_recieve_div_file
	# 	mb = SyncFiler::FileSubmissionServer::MB
	# 	f = File.read("test.txt",mb).to_msgpack
	# 	assert( !@srv.recieve_div_file("test.txt", f, 'tmp'), "NG" )
	# end
	# def test_get_file_list
	# 	p @srv.get_file_list("test")
	# 	assert @srv.get_file_list("test"), "NG"
	# end
end
