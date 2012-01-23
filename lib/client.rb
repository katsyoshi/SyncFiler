#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
# require File.dirname(__FILE__)+'/syncfiler.rb'
module SyncFiler
class Client
  def initialize(client = {'default' => '~/SyncFiles',
                   'server_addr' => nil, 'port_no' => 9090, 'host'=> nil })
    @setting=SyncFiler::Settings.read
    if @settings['client'].nil?
      @settings['client'] = client
      SyncFiler::Settings.write_setting_file('client', client)
    end
  end

  def setting
    @setting
  end

  def client
    @client
  end

  def timeout=(time)
    @client.timeout=time
  end

  def connect_server
    addr = @setting["server_addr"]
    port = @setting["port_no"].to_i
    @client = MessagePack::RPC::Client.new(addr, port)
  end

  def close
    @client.close
  end
  alias :disconnect_server :close

  def get_server_info
    @client.call( :get_server_info )
  end
  alias :pull_server_info :get_server_info

  def get_file_info( file_name )
    @client.call( :get_file_info, file_name )
  end
  alias :pull_file_info :get_file_info

  def send_file_info( hash )
    @client.call( :get_file_hash_value, hash )
  end
  alias :push_file_info :send_file_info

  def get_file_list()
    @client.call( :get_file_list )
  end
  alias :pull_file_list :get_file_list

  def recieve_file( name, pos )
    @client.call( :send_file, name, pos )
  end
  alias :pull_file :recieve_file

  def send_file( name, pos )
    @client.call( :recieve_file, name, pos )
  end
  alias :push_file :send_file
end
end
