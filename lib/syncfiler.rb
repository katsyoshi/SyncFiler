# -*- coding: utf-8 -*-
module SyncFiler
  class Error < Exception
    class DB; end
    class Server; end
    class Client; end
    class Settings; end
  end
end

require File.join(File.dirname(__FILE__),'client')
require File.join(File.dirname(__FILE__),'server')
require File.join(File.dirname(__FILE__),'db','file_info')
require File.join(File.dirname(__FILE__),'settings' )
