#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'spec'
$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), '..','..','lib')))
require 'syncfiler'

describe 'SyncFiler::DB test' do
  before(:each)do
    @svr, @client = start_server
  end

  after(:each)do
    @svr.stop
    @client.stop
  end
end

