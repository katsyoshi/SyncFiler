#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
# require File.dirname(__FILE__)+'/syncfiler.rb'
require 'msgpack-rpc'
module SyncFiler
module FileSubmission
class Server
	KB = 1024
	BLOCK = 8 * KB
	MB = KB * KB
	GB = MB * KB
	
	def initialize(port=9090, block=BLOCK)
		@conf=SyncFiler::Settings.read
	rescue e 
		hs = {'default' => "SyncFiles", 'port_no' => port, 
			'host' => Socket.gethostname}
		SyncFiler::Settings.write_setting_file("server",hs)
		@conf=SyncFiler::Settings.read
	ensure
		# @db=SyncFiler::DB::FileInfoDB.new
		# @db_info = @db.get_db_info
		@vol={:kb => KB,:mb => MB,:mb => GB, :block => block}
	end

	def close
		nil
	end
	
	# val
	def send_server_vol
		@vol
	end

	# server settings
	def send_server_info
		@conf
	end

	# db info 
	def send_db_info
		@db_info
	end
	
	## FileSubmissionServer#send_div_file
	# send silialized div file
	# silializeされた分割ファイルを送信
	# 送る情報:Hash
	# hs[:file] = 読んだファイルの中身
	# hs[:size] = ファイルのサイズ
	# hs[:pos]  = 読んだファイルの場所 
	def send_file(name, pos, block=@vol[:block])
		# bc = name+"_%05d"%pos
		file = File.open(name,'rb')
		file.pos = pos * block
		size = file.size # / block
		fr = file.read(block)
		hs = {:file => fr, :size => size, :pos => pos, :name => name, :block => block}
		hs.to_msgpack
	end
	
	## FileSubmissionServer#recieve_div_file
	# recieve silialized div file 
	# silializeされたファイルを保存
	# 使うときはThread使わないと遅い
	def recieve_file( msgpack, write=msgpack["name"] )
		f = MessagePack.unpack msgpack
		pos = f["pos"].to_i
		block = f["block"].to_i
		file = f["file"]
		File.open(write, "w") unless File.exist? write
		fw = File.open(write, "r+b")
		fw.pos = block * pos
		fw.write( file )
		fw.close
		nil
	end

	:private
	def vol
		@vol
	end
end
end 
end
# svr = MessagePack::RPC::Server.new
# svr.listen '0.0.0.0', 9090, FileSubmissionServer.new
# svr.run
