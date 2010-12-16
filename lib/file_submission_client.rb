#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/syncfiler.rb'

class SyncFiler::FileSubmissionClient
	def initialize()
		dir = File.expand_path( "~/.syncfiler.d/client.yaml" )
		c = SyncFiler::Settings.new 
		c.write_client unless File.exist? dir
		@setting=c.read
		@client=nil
	end

	def connect_server
		addr = @setting["server_addr"]
		port = @setting["port_no"].to_i
		@clinet = MessagePack::RPC::Client.new(addr, port)
	end
	
	def disconnect_server
		@client.close
	end
	
	def get_file_info( file_name )
		@client.call( :get_file_info, file_name )
	end

	def get_file_list( db_name )
		@client.call( :get_file_list, db_name )
	end

	def recieve_div_file name
		@client.call( :send_div_file, name )
	end
	
	def send_div_file name
	end
end
