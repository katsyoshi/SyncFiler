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
    File.delete(@file) if File.exist?(@file)
  end

  def test_read
    SyncFiler::Settings.write(:server, @s, @file)
    SyncFiler::Settings.write(:client, @c, @file)
    h = SyncFiler::Settings.read(@file)
    assert_instance_of(Hash, h, "OK" )
  end

  def test_write_client
    client = SyncFiler::Settings.read(@file) if File.exist? @file
    assert( SyncFiler::Settings.write("client",@c,@file),
            "cannot write client settings" )
  end

  def test_write_server
    server = SyncFiler::Settings.read(@file) if File.exist? @file
    # if !server[:server]
    assert( SyncFiler::Settings.write("server",@s, @file),
            "cannot write server settings")
  end

  def test_write_database
    database = SyncFiler::Settings.read(@file) if File.exist? @file
    assert( SyncFiler::Settings.write("database",@d, @file),
            "cannot write database settings")
  end
  def test_exist?
    assert SyncFiler::Settings.exist?, "No Setting File"
  end
end
