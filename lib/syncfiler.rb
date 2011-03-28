# -*- coding: utf-8 -*-
module SyncFiler
	# require 'rubygems'
	# require 'msgpack/rpc'
	module FileSubmission
	end
	module DB
		# require 'active_record'
		# require 'sqlite3'
		#		def create_db(db='~/.syncfiler.d/info.db')
		# d = File.expand_path db
		# SQLite3::Database.new(d) unless File.exist? d
		#		end
	end
	class Error < Exception
		class DB
		end
		class FileSubmission
		end 
		class Settings
		end
	end
end

require File.join(File.dirname(__FILE__),'file_submission_client')
require File.join(File.dirname(__FILE__),'file_submission_server')
require File.join(File.dirname(__FILE__),'db','file_info')
# require File.join(File.dirname(__FILE__),'db','file_info_db')
require File.join(File.dirname(__FILE__),'settings' )
