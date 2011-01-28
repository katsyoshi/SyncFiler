#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
# require File.dirname(__FILE__)+'/syncfiler.rb'
module SyncFiler
module FileSubmission
class Client
	def initialize( settings = "~/.syncfiler.d/client.yml" )
		dir = File.expand_path( settings )
		SyncFiler::Settings.write_client(dir) unless File.exist? dir
		@setting=SyncFiler::Settings.read dir
		# @client=nil
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
	
	def get_file_list() #  db_name )
		@client.call( :get_file_list)# db_name )
	end
	
	def recieve_div_file name
		@client.call( :send_div_file, name )
	end
	
	def send_div_file name
	end
end
end
end
