#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'yaml'
require File.dirname(__FILE__)+'/syncfiler.rb'

module SyncFiler
class Settings
  include SyncFiler

  ## 設定ファイルを読み込む
  # file: 設定ファイル
  def self.read(file=SyncFiler::SETTINGS)
    path = File.expand_path file
    YAML.load(File.open(path).read)
  end

  ## 設定ファイルに書き込む
  # type: 書き込む種類，server, client, database
  # hash: 書き込む内容
  # path: 設定ファイル
  def self.write( type, hash, path=SyncFiler::SETTINGS )
    pt = File.expand_path(path)
    data = {}
    data = self.read(pt) if File.exist? pt
    data[type.to_s] = hash
    fw = File.open(pt, 'w')
    yml = YAML.dump data
    fw.write yml
    fw.close
    return data
  end

  ## 設定ファイルの存在確認
  # file: 設定ファイル
  def self.exist?(file=SyncFiler::SETTINGS)
    f = File.expand_path file
    path = File.dirname(f)
    Dir.mkdir path unless Dir.exist? path
    File.exist? f
  end
end
end
