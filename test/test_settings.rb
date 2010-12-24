#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/test_helper.rb'

class TC_Settings < Test::Unit::TestCase
	def setup
		@c = "client.yaml"
		@s = "server.yaml"
		@d = "database.yaml"
	end

	def teardown
		File.delete(@c) if File.exist?(@c)
		File.delete(@s) if File.exist?(@s)
		File.delete(@d) if File.exist?(@d)
	end

	# def test_exist?()
	# 	assert_nil @settings.exist?, "ぢレク鳥がない"
	# end

	def test_read
		SyncFiler::Settings.write_db @c
		SyncFiler::Settings.write_db @s
		SyncFiler::Settings.write_db @d
		assert_instance_of(Hash, SyncFiler::Settings.read(@c), "COK" )
		assert_instance_of(Hash, SyncFiler::Settings.read(@s), "SOK" )
		assert_instance_of(Hash, SyncFiler::Settings.read(@d), "DOK" )
	end

	def test_write_client
		assert !SyncFiler::Settings.write_client(@c), "NG"
	end

	def test_write_server
		assert !SyncFiler::Settings.write_server(@s), "NG"
	end
	
	def test_write_database
		assert !SyncFiler::Settings.write_db(@d), "NG"
	end
end
