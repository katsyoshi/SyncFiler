#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/test_helper'

class TC_FileSubmissionServer < Test::Unit::TestCase
	def setup
		@srv = SyncFiler::FileSubmission::Server.new
		@file="file.dd"
	end
	
	def teardown 
		@srv.close
	end
	
	def test_send_file
		assert(@srv.send_file(@file, 0), "NG")
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

	def test_send_server_info
		assert(@srv.send_server_info, "NG")
	end
end
