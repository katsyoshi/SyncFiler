#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
# require File.dirname(__FILE__)+'/syncfiler.rb'
require 'msgpack-rpc'
require 'socket'
require 'digest/md5'
require 'digest/sha2'
module SyncFiler
module FileSubmission
class Server
	KB = 1024
	BLOCK = 8 * KB
	MB = KB * KB
	GB = MB * KB
	
	def initialize(port=9090, block=BLOCK)
		vol={:kb => KB,:mb => MB,:mb => GB, :block => block}
		hs = {'default' => "SyncFiles", 'port_no' => port, 'block_size' => block, 'host' => Socket.gethostname, 'vol' => vol }
		conf = SyncFiler::Settings.write_setting_file "server", hs
		@conf = conf["server"]
		@vol = vol
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
		hs = {:file => fr, :size => size, :pos => pos, :name => name, :block => block, :hash => fhash }
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
		hash = f["hash"]
		File.open(write, "w") unless File.exist? write
		fw = File.open(write, "r+b")
		fw.pos = block * pos
		fw.write( file )
		fw.close
		nil
	end

	def get_file_hash_value( msgpack )
		f = MessagePack.unpack msgpack
		@hash = f
		nil 
	end

	:private
	def vol
		@vol
	end

	## ファイルの送受信が完了したかどうかのタスク
	# fname: file name
	# dtype: hash digest type
	# @hash[fname][
	def is_completed?( fname, dtype="md5" ) 
		hs = nil 
		hs = Digest::MD5.hexdigest(File.open(fname).read) if dtype == "md5"
		hs = Digest::SHA256.hexdigest(File.open(fname).read) if dtype =~ /sha/
		return hs == @hash[fname][dtype]
	end
end
end 
end
# svr = MessagePack::RPC::Server.new
# svr.listen '0.0.0.0', 9090, FileSubmissionServer.new
# svr.run
