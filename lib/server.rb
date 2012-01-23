#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
# require File.dirname(__FILE__)+'/syncfiler.rb'
require 'msgpack/rpc'
require 'socket'
require 'digest/md5'
require 'digest/sha2'
module SyncFiler
class Server
  ## SyncFiler::Serverコンストラクタ
  # settings: 初期設定
  # file: 設定ファイル
  def initialize(settings={}, file=SyncFiler::SETTINGS)
    settings["default"] ||= SyncFiler::DEFAULT
    settings["port"] ||= SyncFiler::PORT
    settings["block"]||= SyncFiler::BLOCK
    settings["host"] ||= Socket.gethostname
    settings["vol"] ||= SyncFiler::VOL
    info = SyncFiler::Settings.write :server, settings, file
    @info = info[:server.to_s]
    @vol = settings[:vol.to_s]
  end

  # def shutdown(obj)
  #   obj = nil
  # end
  # alias :close :shutdown

  ## Server#vol
  # send server has block volume
  # サーバが管理するブロック情報を送る
  def send_server_vol
    @vol
  end
  alias :pull_vol :send_server_vol

  # server settings
  def send_server_info
    @info
  end
  alias :pull_server_info :send_server_info

  # db info
  def send_db_info
    @db_info
  end
  alias :pull_db_info :send_db_info

  #   # recieve file hash value
  #   client -> server
  def get_file_hash_value( msgpack )
    @hash = MessagePack.unpack msgpack
  end
  alias :get_file_info :get_file_hash_value
  alias :push_file_hash_value :get_file_hash_value

  ## FileSubmissionServer#send_div_file
  # send silialized div file
  # silializeされた分割ファイルを送信
  # 送る情報:Hash
  # hs[:file] = 読んだファイルの中身
  # hs[:size] = ファイルのサイズ
  # hs[:pos]  = 読んだファイルの場所
  # alias pull_file クライアントから見た動作名
  def send_file(name, pos, block=@vol[:block])
    # bc = name+"_%05d"%pos
    file = File.open(name,'rb')
    file.pos = pos * block
    size = file.size # / block
    fr = file.read(block)
    hs = {:file => fr, :size => size, :pos => pos,
      :name => name, :block => block }
    hs.to_msgpack
  end
  alias :pull_file :send_file

  ## FileSubmissionServer#recieve_div_file
  # recieve silialized div file
  # silializeされたファイルを保存
  # 使うときはThread使わないと遅い
  # alias push_file
  def recieve_file( msgpack, write=msgpack["name"] )
    f = MessagePack.unpack msgpack
    pos = f["pos"].to_i
    block = f["block"].to_i
    file = f["file"]
    hash = f["hash"]
    File.open(write, "w") unless File.exist? write
    fw = File.open(write, "r+b")
    fw.pos = block * pos
    fw.write( file )
    fw.close
    true
  end
  alias :push_file :recieve_file

  :private
  attr_reader :hash
  attr_reader :vol
  # def hash ; @hash end
  # def vol ;  @vol end
  ## ファイルの送受信が完了したかどうかのタスク
  # fname: file name
  # dtype: hash digest type
  def completed?( fname, dtype="md5" )
    hs = nil
    file = File.open(fname).read
    # hs = Digest::Base.hexdigest(file)
    hs = Digest::MD5.hexdigest(file) if dtype =~ /md5/i
    hs = Digest::SHA256.hexdigest(file) if dtype =~ /sha/i
    return hs == @hash[fname][dtype]
  end
  alias :is_completed :completed?
end
end
# svr = MessagePack::RPC::Server.new
# svr.listen '0.0.0.0', 9090, FileSubmissionServer.new
# svr.run
