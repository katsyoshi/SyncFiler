#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'msgpack/rpc'
require 'zlib'
require "./settings.rb"

class FileSubmissionServer
	MB= 1024*1024
	MAX_SIZE = Settings::SETTINGS['max_file_size']
	DEF_DIR = Settings::SETTINGS['default']

	# pull pull pull pull
	def comp_file_pull(name)
		if file_size( name ) > (MAX_SIZE*MB)
			raise "File size is over #{MAX_SIZE} MB"
		end
		file = Zlib::Deflate.deflate( file_open( name ), Zlib::BEST_COMPRESSION )
		file.to_msgpack # silialize
	end
	
	# Pushファイル送信の圧縮版
	def comp_file_push(file, name="tmp")
		f = MessagePack.unpack file
		f = Zlib::Inflate.Inflate(f)
		fw = File.open("#{DEF_DIR}/"+name,"wb")
		fw.write f
		fw.close
		nil 
	end
	
	# Pushファイル送信の無圧縮版
	def file_push( file, name="tmp" )
		f = MessagePack.unpack file
		fw = File.open("${DEDF_DIR}/"+name,"wb")
		fw.write f
		fw.close
		nil
	end
	
	# Pull無圧縮だけどいるのかこれ？
	def file_pull(name)
		file = file_open(name)
		file.to_msgpack # silialize
	end

	def get_settings()
		Settings::SETTINGS
	end
	
	def get_para
	end
	
	:private
	def file_size(name)
		File.size name
	end

	def file_open(name)
		File.open(name,'rb').read
	end
end
svr = MessagePack::RPC::Server.new
svr.listen '0.0.0.0', 9090, FileSubmissionServer.new
svr.run
