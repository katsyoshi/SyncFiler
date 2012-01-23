#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/test_helper'
class TC_FileSubmissionServer < Test::Unit::TestCase
  def setup
    @srv = SyncFiler::Server.new({}, './settings.yml')
    @file="file.dd"
  end

  def teardown
    @srv = nil
  end

  def test_send_file
    assert(@srv.send_file(@file, 0), "send block file")
  end

  def test_recieve_file
    s = Time.now
    size = File.stat(@file).size/@srv.vol[:block]
    (0..size).each do |x|
      msg = @srv.send_file(@file,x)
      @srv.recieve_file(msg,"rev.dd")
    end
    diff = open(@file).readlines - open("rev.dd").readlines
    assert(diff.empty?, "cannot recieved rev.dd")
  end

  def test_send_server_vol
    assert(@srv.send_server_vol, "cannot send server vol! why?")
  end

  def test_send_server_info
    info = @srv.send_server_info
    assert(info, "cannot send server info! why?")
  end

  def test_xfile_is_completed?
    md5 = Digest::MD5.hexdigest(File.open(@file).read)
    hs = { @file => {:md5 => md5} }.to_msgpack
    assert(@srv.get_file_hash_value(hs), "NG")
    assert(@srv.completed?(@file), "NG")
    assert(@srv.is_completed(@file), "NG")
    sha = Digest::SHA256.hexdigest(File.open(@file).read)
    hs = { @file => {:sha => sha} }.to_msgpack
    @srv.get_file_hash_value hs
    assert(@srv.hash, "NG")
    assert(@srv.completed?(@file,'sha'), "NG")
  end
end
