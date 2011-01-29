#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
# require File.dirname(__FILE__)+'/syncfiler.rb'
module SyncFiler
module FileSubmission
class Client
	def initialize( settings = "~/.syncfiler.d/client.yml" )
		d = File.expand_path( settings )
		SyncFiler::Settings.write_client(d) unless File.exist? d
		@setting=SyncFiler::Settings.read(d)
		# @client=nil
	end
	
	def setting
		@setting
	end
	
	def client
		@client
	end
	
	def timeout=(time)
		@client.timeout=time
	end
		
	def connect_server
		addr = @setting["server_addr"]
		port = @setting["port_no"].to_i
		@client = MessagePack::RPC::Client.new(addr, port)
	end
	
	def close
		@client.close
	end
	alias :disconnect_server :close 

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
