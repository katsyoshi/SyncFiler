# -*- coding: utf-8 -*-
module SyncFiler
  DEFAULT="~/SyncFile"
  SETTINGS="~/.syncfiler.d/settings.yml"
  PORT=9090
  KB = 1024
  BLOCK = 8 * KB
  MB = KB * KB
  GB = MB * KB
  VOL={:kb => KB,:mb => MB,:gb => GB, :block => BLOCK}

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
