#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require File.dirname(__FILE__)+'/test_helper.rb'

class TC_Settings < Test::Unit::TestCase
	def setup
		@settings = SyncFiler::Settings.new
	end

	def teardown
	end

	def test_exist?()
		assert !@settings.exist?, "NG"
	end

	def test_read
		assert @settings.read, "NG"
	end
end
