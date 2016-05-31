require './browser'
include Browser
require 'securerandom'

module Server
  class ServerClass
    def initialize
    end

    def start(browser,url,opts)
      @browser_instance = BrowserClass.new(browser,url,opts)
    end

    def stop()
      @browser_instance.stop
    end

    def cleanup()
        @browser_instance.cleanup
    end
  
  end
end
