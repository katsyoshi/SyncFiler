#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'yaml'
require 'pp'

class Settings
	:private 
	ext = File.expand_path( "~/settings.yaml" )
	str  = File.open(ext).read()      # 入力をすべて読み込む
	SETTINGS = YAML.load(str)   # パースする
	:pulic
	SETTINGS               
end
