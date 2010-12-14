#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/syncfiler.rb'

class SyncFiler::FileSubmissionClient
	def initialize( addr, port=9090)
		@client=MessagePack::RPC::Client.new(addr, port)
	end

	def recieve_div_file name
	end
	
	def send_div_file name
		x = 0
	end
end
