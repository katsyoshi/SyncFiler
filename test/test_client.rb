#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/test_helper.rb'

class TC_SyncFilerClient < Test::Unit::TestCase
  def start_server server
    Thread.new{
      server = SyncFiler::Server.new({:default => "./ponponpain"})
      @svr = MessagePack::RPC::Server.new
      @srv.listen '0.0.0.0', 9090, server
    }
  end

  def setup
    client = { :default => './', :server_addr => 'localhost'}
    @cl = SyncFiler::Client.new client
    start_server(@server)
    @cl.connect_server
  end

  def teardown
    @cl.disconnect_server
    @srv.close
  end

  def test_get_file_list
    p @cl
    fl = @cl.get_file_list
    assert( fl, "cannot get file lists" )
  end

  def test_recieve_file
    assert( @cl.recieve_file("rev.dd"), "cannot recieve file" )
  end

  def test_send_file
    assert( @cl.send_file("test.dd"), "cannot send file" )
    assert( @cl.send_file("test_client.rb"), "cannot send file" )
  end

  def test_get_file_info
    assert( @cl.get_file_info, "cannot get file info")
  end

  def test_get_server_info
    assert( @cl.get_server_info, "cannot get server info" )
  end
end
