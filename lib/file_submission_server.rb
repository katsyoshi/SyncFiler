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
	
	def initialize(port=9090, block=BLOCK,settings="~/.syncfiler.d/server.yml")
		d = File.expand_path(settings)
		hs = {'default' => "SyncFiles", 'port_no' => port}
		SyncFiler::Settings.write_server(d,hs) unless File.exist? d
		# @db_settings=SyncFiler::DB::FileInfo::load_configurations
		@db=SyncFiler::DB::FileInfoDB.new
		@db_info = @db.get_db_info
		@conf=SyncFiler::Settings.read(d)
		@vol={:kb => KB,:mb => MB,:mb => GB, :block => block}
	end

	def close
		nil
	end
	
	def db_up
		@db.connect_file_db
		@db.create_table
	end
	
	def db_down
		@db.drop_table
		@db.disconnect_file_db
	end
	# val
	def send_server_vol
		@vol
	end

	# server settings
	def send_server_conf
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

	def connect_file_db
		@db.connect_file_db
	end
	
	def create_table
		@db.create_table
	end

	def write_table(file)
		@db.write_file_info
	end

	def drop_table
		# SyncFiler::DB::FileInfo.down
		SyncFiler::DB::FileInfoDB.down
	end
end
end 
end
# svr = MessagePack::RPC::Server.new
# svr.listen '0.0.0.0', 9090, FileSubmissionServer.new
# svr.run
