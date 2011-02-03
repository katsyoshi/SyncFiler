#!/usr/bin/env ruby
module SyncFiler
module DB
	require 'sqlite3'
	def create_database(db_name, option={})
		@db=SQLite3::Database.new db_name, option
	end
	def create_table()
	end
	def write_db()
	end
	def drop_table(table_name)
		@db.execute( 'drop #{table_name}' )
	end
end
end
