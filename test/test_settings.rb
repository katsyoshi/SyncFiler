#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/test_helper.rb'
require 'socket'
class TC_Settings < Test::Unit::TestCase
  def setup
    @c = {'dsrv' => ['localhost'], 'port_no' => 9090, 
      'name' => Socket.gethostname }
    @s = {'default' => 'SyncFiles', 'port_no' => 9090, 
      'name' => Socket.gethostname }
    @d = {'path' => '~/.syncfiler.d/file_info.db'}
    @file = './settings.yml'
  end
  
  def teardown
    # File.delete(@file) if File.exist?(@file)
  end
  
  def test_x_read
    h = SyncFiler::Settings.read(@file)
    assert_instance_of(Hash, h, "OK" )
  end
  
  def test_write_client
    assert SyncFiler::Settings.write_setting_file("client",@c,@file), 
    "cannot write client settings"
  end
  
  def test_write_server
    assert SyncFiler::Settings.write_setting_file("server",@s, @file), 
    "cannot write server settings"
  end
  
  def test_write_database
    assert SyncFiler::Settings.write_setting_file("database",@d, @file), 
    "cannot write database settings"
  end
  def test_exist?
    assert SyncFiler::Settings.exist?, "No Setting File"
  end
end
