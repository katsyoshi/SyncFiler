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
		send = []
		size.times do |x| 
			if (x+1) % 1000 == 0
				print x+1
			elsif ( x+1 ) % 100 == 0
					print "."
			end
			send << Thread.new(x){|y| 
				@srv.send_file(@file,y) 
			} 
		end
		
		send.each do |x|
			msg = x.join.value
			@srv.recieve_file(msg,"rev.dd")
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
