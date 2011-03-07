#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/test_helper'
class TC_FileSubmissionServer < Test::Unit::TestCase
	def setup
		@srv = SyncFiler::FileSubmission::Server.new
		@file="file.dd"
	end
	
	def teardown 
		# @srv.close
	end
	
	def test_send_file
		assert(@srv.send_file(@file, 0), "NG")
	end

	def test_thread_recieve_return
		#file if File.open(@file).size > 10*1024*1024
		s = Time.now
		size = File.stat(@file).size/@srv.vol[:block]
		send = []
		size.times do |x| 
			send << Thread.new(x){|y| 
				msg = @srv.send_file(@file,y) 
				@srv.recieve_file(msg,"rev.dd")
			} 
		end
		send.each{|stack|	stack.join}
		diff = open(@file).readlines - open("rev.dd").readlines
		assert(diff.empty?, "NG")
	end
	
	def test_send_server_vol
		assert(@srv.send_server_vol, "NG")
	end

	def test_send_server_info
		assert(@srv.send_server_info, "NG")
	end
	
	def test_x_is_completed?
		hv = Digest::MD5.hexdigest(File.open(@file).read)
		hs = { @file => {:md5 => hv} }.to_msgpack
		assert(!@srv.get_file_hash_value(hs), "NG")
		assert(@srv.is_completed?(@file), "NG")
	end
end
