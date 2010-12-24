#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/syncfiler.rb'
# require 'zlib'

class SyncFiler::FileSubmissionServer
	KB = 1024
	BLOCK = 8 * KB
	MB = KB * KB
	GB = MB * KB
	
	def initialize(port=9090, block=BLOCK,settings="~/.syncfiler.d/server.yaml")
		d = File.expand_path(settings)
		hs = {'default' => "SyncFiles", 'port_no' => port}
		SyncFiler::Settings.write_server(d,hs) unless File.exist? d
		@db_settings=SyncFiler::FileInfoDB::load_configurations
		@conf=SyncFiler::Settings.read( d )
		@vol={:kb => KB,:mb => MB,:mb => GB, :block => block}
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
	def send_file(name, pos, block=BLOCK)
		# bc = name+"_%05d"%pos
		file = File.open(name,'rb')
		file.pos = pos * block
		size = file.size / block
		fr = file.read(block)
		hs = {:file => fr, :size => size, :pos => pos, :name => name, :block => block}
		hs.to_msgpack
	end
	
	## FileSubmissionServer#recieve_div_file
	# recieve silialized div file 
	# silializeされたファイルを保存
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

	def send_file_hash(name)
		File.open
	end

	:private
	def vol
		@vol
	end
	
	def db_up
		@db=SyncFiler::FileInfoDB.establish_connection(@db_settings)
	end
	
	def get_settings()
		s = SyncFiler::Settings.new
		s.exist?
		@settings = s.read
	end
	
	def mkdb(dbsettings="~/.syncfiler.d/file_info.db")
		db=SyncFiler::FileInfoDB::Base.load_configurations(dbsettings)
	end
	
	def get_file_list(tbl_name, hash={}, db_name="~/.syncfiler.d/file_info.db")
		dbn = File.expand_path( db_name )
		db = SyncFiler::FileInfoDB::Base.load_configurations if hash == {}
		list = db.get_file_list(tbl_name)
		db.close
		list
	end
	
	def get_file_info(name)
		File.stat name
	end
end
# svr = MessagePack::RPC::Server.new
# svr.listen '0.0.0.0', 9090, FileSubmissionServer.new
# svr.run
