#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'msgpack/rpc'
require './settings.rb'
require 'zlib'
class FileSubmissionClient
	def initialize( addr, port=9090)
		@client=MessagePack::RPC::Client.new(addr, port)
	end

	def comp_pull(name)
		rpcclient = @client.call :comp_file_pull, name
		mp = MessagePack.unpack rpcclient
		f = Zlib::Inflate.inflate mp
		save = File.basename(file)
		fw = File.open( save, "wb")
		fw.write f
	end 

	def comp_send_file(name)
		disk = Zlib::Deflate.deflate(File.read(name))
		disk.to_msgpack
		c.call(:comp_file_push, disk,name)
	end

	def connection_cut
		@client.close
	end
end

