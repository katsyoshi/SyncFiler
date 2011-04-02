#!/usr/bin/env ruby

require File.dirname(__FILE__)+'/database'

module SyncFiler
module DB
class NameInfo
  include SyncFiler::DB
  def initialize
    @config = SyncFiler::Settings.read
  end
  
end
end
end
