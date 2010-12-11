#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require File.dirname(__FILE__)+'/syncfiler.rb'
require File.dirname(__FILE__)+'/settings.rb'
module SyncFiler
class FileSubmissionServer 
	KB = 1024
	MB = KB * KB
	GB = MB * KB
	MAX_SIZE = SyncFiler::Settings::SETTINGS['max_file_size']
	DEF_DIR = SyncFiler::Settings::SETTINGS['default']

	def initialize(port=9090)
		@read_files = Hash.new
	end
	
	## FileSubmissionServer#file_send 
	# silialize file pull
	# silializeされたファイルを送信
	def file_send(name)
		file = file_open_byte_stream( name )
		file.to_msgpack # silialize
	end

	## FileSubmissionServer#file_write
	# silialize file push
	# silializeされたファイルを保存
	def file_save(file, name="tmp")
		f = MessagePack.unpack file
		fw = File.open("#{DEF_DIR}/"+name,"wb")
		fw.write f
		fw.close
		nil 
	end
	
	def seek_file(file,pos)
		file.read(pos*MB)
		nil
	end

	def get_settings()
		Settings::SETTINGS
	end
	
	def get_file_list()
		Dir.entries DEF_DIR
	end
	
	:private
	def file_size(name)
		File.size name
	end

	def file_open(name)
		File.open(name,'rb')
	end
	
	def file_open_byte_stream(name,size=1)
		ary = Hash.new
		file = File.open name, 'rb'
		basename=File.basename name
		x = 0
		while get = file.read(size * MB)
			num = basename+"%05d"%x 
			ary[num] = get
			x += 1
		end
		file.close
		ary
	end
end
end
# svr = MessagePack::RPC::Server.new
# svr.listen '0.0.0.0', 9090, FileSubmissionServer.new
# svr.run
