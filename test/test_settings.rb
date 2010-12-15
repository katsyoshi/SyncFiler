#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/test_helper.rb'

class TC_Settings < Test::Unit::TestCase
	def setup
		@settings = SyncFiler::Settings.new
	end

	def test_exist?()
		assert_nil @settings.exist?, "ぢレク鳥がない"
	end

	def test_read
		assert_instance_of(Hash, @settings.read("client.yaml"), "COK" )
		assert_instance_of(Hash, @settings.read("server.yaml"), "SOK" )
	end

	def test_write_client
		assert !@settings.write_client("client.yaml"), "NG"
	end

	def test_write_server
		assert !@settings.write_server("server.yaml"), "NG"
	end
end
