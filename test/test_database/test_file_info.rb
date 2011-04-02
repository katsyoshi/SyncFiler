# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/../test_helper.rb'

class TC_FileInfo < Test::Unit::TestCase
  KB=1024*8
  BLOCK=8*KB
  @hs = {'path' => '~/.syncfiler.d/settings.yml'}
  def setup
    @db=SyncFiler::DB::FileInfo.new
    info=@db.get_db_info
    @path=info["path"]
    @db.connect_file_db @path
    @db.create_table 
  end
  
  def teardown
    @db.drop_table "fileinfo" unless @db.is_connected?
    @db.disconnect_file_db
  end
  
  def test_is_connected?
    assert !@db.is_connected?, "NG"
    assert !@db.closed?, "NG"
  end
  
  def test_create_table
    assert @db.create_table, "NG"
  end
  
  def test_connect_file_db
    assert @db.connect_file_db(@path), "NG"
  end
  
  def test_drop_table
    assert @db.drop_table, "NG"
  end
  
  def test_disconnect_file_db
    @db.connect_file_db @path
    assert @db.disconnect_file_db, "NG"
  end
  def test_get_db_info
    assert @db.get_db_info, "NG"
  end
  
  def test_get_file_list
    assert @db.get_file_list, "NG"
  end
  
  def test_write_file_info
    file = ARGV[0]
    tp = get_file_info( file )
    assert @db.write_file_info(tp), "NG"
  end	
  
  def test_search_db
    p @db.search_db(:id)
    assert @db.search_db(:id), "NG"
    assert @db.search_db(:name), "NG"
  end
  
  def test_drop_table
    assert @db.drop_table("fileinfo"), "NG"
  end
  
  def get_file_info( name, block = BLOCK )
    f = File.expand_path(name)
    hs = File.open(f,'rb').read
    hash = Digest::MD5.hexdigest(hs)
    size = File.size(f) / block
    host = `hostname -s`.chomp
    return {:name => name, :size => size, :path => f, :id => hash, 
      :block => block, :host => host}
	end
end

