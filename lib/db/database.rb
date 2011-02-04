#!/usr/bin/env ruby
module SyncFiler
module DB
	require 'sqlite3'
	def create_database(db_name="~/.syncfiler.d/database.sqlite3", option={})
		path = File.expand_path db_name
		@db=SQLite3::Database.new path, option
	end
	alias :connect_database :create_database

	def disconnect_database
		@db.close
	end
	
	def drop_table(table_name)
		@db.execute( "drop table if exists #{table_name}" )
	end
end
end
