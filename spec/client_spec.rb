#!/usr/bin/env ruby
require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper.rb')
require File.join(File.expand_path(File.dirname(__FILE__)), 'my_server.rb')
include MyServerTest

describe 'SyncFiler::Client test' do
  before(:each) do
    @svr, @client = start_server
  end

  after(:each) do
    @svr.stop
    @client.stop
  end

  it 'should return "ok" value ' do
    @client.call(:hello).should include("ok")
  end
end
