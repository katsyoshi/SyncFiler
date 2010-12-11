require File.dirname(__FILE__)+'/syncfiler.rb'
require 'sqlite3'
class SyncFiler::FileDB
	def initialize( db_name )
		@db = SQLite3::Database.new( db_name )
	end

	def create_table( tbl_name )
		@tbl_name = tbl_name
		ct ="create table #{tbl_name} ( name varchar(255), size bigint, date varchar(255), visible int )"
		@db.execute ct
	end

	def destroy_table(tbl_name)
		drop = "drop table #{tbl_name}"
		@db.execute drop
	end

	def write( tbl_name, setup=Hash.new )
		w = "insert into #{tbl_name} values( :name, :size, :date, :visible )"
		@db.execute( w )
	end
	
	def get_list(tbl_name)
		gl="select * from #{tbl_name}"
		@db.execute( gl )
		# 		@db.execute( gl )
	end
	def close
		@db.close
	end

end
