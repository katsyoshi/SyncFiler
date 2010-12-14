#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/syncfiler.rb'

class SyncFiler::FileSubmissionServer
	KB = 1024
	MB = KB * KB
	GB = MB * KB
	# MAX_SIZE = SyncFiler::Settings::SETTINGS['max_file_size']
	# DEF_DIR = SyncFiler::Settings::SETTINGS['default']

	def initialize(addr='0.0.0.0', port=9090)
		@svr = {:addr => addr, :port => port}
	end

	## FileSubmissionServer#send_div_file
	# send silialized div file
	# silializeされた分割ファイルを送信
	def send_div_file(name, file, count, bs = MB)
		c = "%05d"%count
		bn = File.basename( name )
		bn = bn+c if File.size(name) > MB
		hs = {bn => file.read(bs)}
		hs.to_msgpack
	end
	
	## FileSubmissionServer#recieve_div_file
	# recieve silialized div file 
	# silializeされたファイルを保存
	def recieve_div_file( name, file, write=name )
		f = MessagePack.unpack file
		fw = File.open(write, "wb")
		fw.write f
		fw.close
		nil
	end
	
	def get_settings()
		s = SyncFiler::Settings.new
		s.exist?
		@settings = s.read
	end
	
	def get_file_list()
		db = SyncFiler::FileDB.new
	end
	
	def get_file_info(name)
		File.stat name
	end
end
# svr = MessagePack::RPC::Server.new
# svr.listen '0.0.0.0', 9090, FileSubmissionServer.new
# svr.run
