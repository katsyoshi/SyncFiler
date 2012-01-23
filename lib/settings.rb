#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'yaml'
require File.dirname(__FILE__)+'/syncfiler.rb'

# module SyncFiler
class SyncFiler::Settings 
  include SyncFiler
  def self.read(file="~/.syncfiler.d/settings.yml" )
    path = File.expand_path file
    config = YAML.load(File.open(path).read)
  end
  
  def self.write_setting_file( type, hash,
                               path='~/.syncfiler.d/settings.yml' )
    pt = File.expand_path(path)
    data = Hash.new
    fw = File.open(pt, 'w')
    yml = YAML.dump data
    fw.write yml
    fw.close
    return data
  end

  def self.exist?(file="~/.syncfiler.d/settings.yml")
    f = File.expand_path file
    path = File.dirname(f)
    Dir.mkdir path unless Dir.exist? path
    File.exist? f
  end
end

