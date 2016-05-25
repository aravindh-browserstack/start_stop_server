module Browser
  class BrowserClass
    def initialize(browser_name,url=nil,options={})
      proxy_server = nil
      proxy_port = nil
      if options.include?("proxy_server".to_sym)
        proxy_server = options["proxy_server".to_sym]
      end
      if options.include?("proxy_port".to_sym)
        proxy_port = options["proxy_port".to_sym]
      end
      case browser_name
        when "firefox"
          print "********",proxy_server,proxy_port
          unless (proxy_server.nil? || proxy_port.nil?)
            system("sudo networksetup -setwebproxystate Wi-Fi on")
            system("sudo networksetup -setwebproxy Wi-Fi "+proxy_server+" "+proxy_port)
          end
          system("/Applications/Firefox.app/Contents/MacOS/firefox --new-window "+url.to_s+" &")
        else
          raise ArgumentError
        end
    end

    def stop
      system('osascript -e "tell application \"Firefox\" to quit"')
      system("sudo networksetup -setwebproxystate Wi-Fi off")
    end

    def cleanup
      cookie_path = IO.popen("find ~/Library/ -name cookies.sqlite").read.chomp
      if cookie_path != ""
        system("mv \""+cookie_path+"\" /tmp/")
      end
    end
    
  end
end

