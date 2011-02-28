#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/test_helper'
require 'digest/md5'
class TC_FileSubmissionServer < Test::Unit::TestCase
	def setup
		@srv = SyncFiler::FileSubmission::Server.new
		@file="file.dd"
	end
	
	def teardown 
		@srv.close
	end
	
	def test_send_file
		hs = Digest::MD5.hexdigest(File.open(@file,'rb').read)
		assert(@srv.send_file(@file, hs, 0), "NG")
	end
	
	def test_recieve_file
		s = Time.now
		size = File.stat(@file).size/@srv.vol[:block]
		hs = Digest::MD5.hexdigest(File.open(@file,'rb').read)
		th = Array.new
		(0..size).each do |x| 
			th << @srv.send_file(@file,hs,x)
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

	def test_x_is_completed?
		hs = { "rev.dd" => {:md5 => "7de65f8643f9de43423d8399e330672b"} }.to_msgpack
		@srv.get_file_hash_value(hs)
		assert(@srv.is_completed?("rev.dd"), "NG")
	end
end
