#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
# require File.dirname(__FILE__)+'/../syncfiler'
# require 'rails'
# require 'active_record'
require 'sqlite3'
module SyncFiler
module DB
class FileInfoDB 
	def initialize(settings="~/.syncfiler.d/database.yaml")
		epath=File.expand_path settings
		@info=SyncFiler::Settings.read epath
	end
	def connect_file_db( path="~/.syncfiler.d/file_info.db", option={} )
		ex_path = File.expand_path( path )
		@db=SQLite3::Database.new(ex_path,option)
	end
	def get_db_info
		@info
	end
	def get_file_list
		search_db( :name )
	end
	def create_table
		ct=<<SQL
CREATE TABLE IF NOT EXISTS fileinfo(
id TEXT PRIYMARY KEY,
name CHAR,
path CHAR,
size INTEGER,
block INTEGER
);
SQL
		@db.execute ct
	end
	def drop_table
	end
	def search_db( keywords )
		sw=<<SEARCH
select #{keywords} from fileinfo;
SEARCH
		@db.execute sw
	end
	def write_file_info( row )
		p row
		wfi=<<WRITE
insert into fileinfo values ( 
#{row[:id].to_s},
#{row[:name]},
#{row[:path]},
#{row[:size]},
#{row[:block]});
WRITE
		@db.execute wfi 
	end
	def disconnect_file_db
		@db.close
	end
end
end
end
