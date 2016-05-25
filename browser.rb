module Browser
  class BrowserClass
    def initialize(browser_name,url=nil,options={})
      proxy_server = nil
      proxy_port = nil
      @browsertype = browser_name
      if options.include?("proxy_server".to_sym)
        proxy_server = options["proxy_server".to_sym]
      end
      if options.include?("proxy_port".to_sym)
        proxy_port = options["proxy_port".to_sym]
      end
      unless (proxy_server.nil? || proxy_port.nil?)
        system("sudo networksetup -setwebproxystate Wi-Fi on")
        system("sudo networksetup -setwebproxy Wi-Fi "+proxy_server+" "+proxy_port)
      end
      case browser_name
        when "firefox"
          @browsertype = "Firefox"
          system("/Applications/Firefox.app/Contents/MacOS/firefox --new-window "+url.to_s+" &")
        when "chrome"
          @browsertype = "Google Chrome"
          system("\"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome\" "+url.to_s+" &")
        else
          raise ArgumentError
      end
    end

    def stop
      system('osascript -e "tell application \"'+@browsertype+'\" to quit"')
      system("sudo networksetup -setwebproxystate Wi-Fi off")
    end

    def cleanup
      case @browsertype
        when "Firefox"
          cookie_path = IO.popen("find ~/Library/ -name cookies.sqlite").read.chomp
          if cookie_path != ""
            system("mv \""+cookie_path+"\" /tmp/")
          end
        when "Google Chrome"
          cookie_path = "/Users/Aravindh/Library/\"Application Support\"/Google/Chrome/Default/Cookies*"
          system("rm -f "+cookie_path)
      end
    end
    
  end
end

