#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/test_helper.rb'
require 'socket'
class TC_Settings < Test::Unit::TestCase
	def setup
		@c = {'server' => 'localhost', 'port_no' => 9090, 
			'host' => Socket.gethostname }
		@s = {'default' => 'SyncFiles', 'port_no' => 9090, 
			'host' => Socket.gethostname }
		@d = {'database' => '~/.syncfiler.d/file_info.db'}
		@file = './settings.yml'
	end

	def teardown
		File.delete(@file) if File.exist?(@file)
	end

	def test_read
		SyncFiler::Settings.write_setting_file "client", @c, @file
		SyncFiler::Settings.write_setting_file "server", @s, @file
		SyncFiler::Settings.write_setting_file "database", @d, @file
		assert_instance_of(Hash, SyncFiler::Settings.read(@file), "OK" )
	end

	def test_write_client
		assert !SyncFiler::Settings.write_setting_file("client",@c,@file), "NG"
	end

	def test_write_server
		assert !SyncFiler::Settings.write_setting_file("server",@s, @file), "NG"
	end
	
	def test_write_database
		assert !SyncFiler::Settings.write_setting_file("database",@d, @file), "NG"
	end
end
