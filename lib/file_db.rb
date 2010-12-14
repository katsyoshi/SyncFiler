# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/syncfiler.rb'
require 'sqlite3'
class SyncFiler::FileDB 
	def initialize( db_name=String )
		@db = SQLite3::Database.new( db_name )
	end

	def create_table( tbl_name = String)
		@tbl_name = tbl_name
		# id integer primary key, 
		ct ="create table if not exists #{tbl_name} ( 
name varchar, 
size bigint, 
date varchar, 
visible varchar )"
		@db.execute ct
	end

	def drop_table(tbl_name=String)
		drop = "drop table #{tbl_name}"
		@db.execute drop
	end

	def get_file_info( file=String )
		h = {:name => file, :size => File.size( file ), 
			:date => File.ctime(file), :visible => File.stat(file).readable? }
	end
	
	def write( tbl_name, hs=Hash.new )
		# 罠:配列ならOK
		exe = "insert into #{tbl_name} values(?,?,?,?)"
		@db.execute( exe, [ hs[:name].to_s, hs[:size].to_s,
												hs[:date].to_s, hs[:visible].to_s ] )
	end
	
	def get_list(tbl_name)
		list = Array.new
		@db.execute("select * from #{tbl_name}").each{|rows|
			list << rows
		}
		list
	end	
	
	def close
		@db.close
	end

end
