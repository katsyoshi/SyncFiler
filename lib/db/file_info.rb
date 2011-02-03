#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
# require File.dirname(__FILE__)+'/../syncfiler'
# require 'rails'
# require 'active_record'
require File.dirname(__FILE__)+'/database'
class SyncFiler::DB::FileInfo
	# include SyncFiler::DB
	def initialize(settings="~/.syncfiler.d/database.yaml")
		epath=File.expand_path settings
		@info=SyncFiler::Settings.read epath
	end
	def connect_file_db( path="~/.syncfiler.d/file_info.db", option={} )
		ex_path = File.expand_path( path )
		@db=create_table(ex_path, option)
	end
	def get_db_info
		@info
	end
	def is_connected?
		@db.closed?
	end
	alias :closed? :is_connected?

	def get_file_list
		search_db( :name )
	end

	## create_table
	# make database table
	def create_table
		ct=<<SQL
CREATE TABLE IF NOT EXISTS fileinfo(
id TEXT PRIYMARY KEY,
name CHAR,
path CHAR,
size INTEGER,
block INTEGER,
host CHAR
);
SQL
		@db.execute ct
	end
	def drop_table
		dt="drop table if exists fileinfo"
		@db.execute dt
	end
	def search_db( keywords )
		sw=<<SEARCH
select #{keywords} from fileinfo;
SEARCH
		@db.execute sw
	end

	## write_file_info
	# write file info in database
	# row = {:id => md5 values, :name => file name, :path => file path,
	#        :block => block size, :host => host name }
	def write_file_info( row )
		wfi=<<WRITE
insert into fileinfo values ( 
:id, :name, :path, :size, :block, :host)
WRITE
		@db.execute( wfi, row )
	end
	def disconnect_file_db
		@db.close
	end
end
# end
# end
