module Browser
  class BrowserClass
    def initialize(browser_name,url=nil,options={})
      @browsername = browser_name
      proxy_server = options[:proxy_server]
      proxy_port = options[:proxy_port]
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
        when "safari"
          @browsertype = "Safari"
          system("open -a /Applications/Safari.app/Contents/MacOS/Safari "+url.to_s)
        else
          raise ArgumentError
      end
    end

    def stop
      system('osascript -e "tell application \"'+@browsertype+'\" to quit"')
      pid = IO.popen("pidof "+@browsername).read().chomp
      if pid != ""
        system("kill -9 "+pid)
      end
      system("sudo networksetup -setwebproxystate Wi-Fi off")
    end

    def cleanup
      case @browsertype
        when "Firefox"
          system("rm -rf ~/Library/\"Application Support\"/Firefox/*")
          system("rm -rf ~/Library/Caches/Firefox/*")
          system("rm -rf ~/Library/Caches/Mozilla/updates/Applications/Firefox/*")
          system("rm -rf ~/Library/Caches/Mozilla/updates/Volumes/Firefox/*")
        when "Google Chrome"
          system("rm -rf ~/Applications/\"Chrome Apps.localize\"/*")
          system("rm -rf ~/Library/\"Application Support\"/Google/Chrome/*")
          system("rm -rf ~/Library/Caches/Google/Chrome/*")
        when "Safari"
          system("rm -rf ~/Library/Caches/Metadata/Safari/*")
          system("rm -rf ~/Library/\"Application Support\"/Spigot/Safari/*")
          system("rm -rf ~/Library/Caches/com.apple.Safari*")
          system("rm -rf ~/Library/Caches/com.apple.commerce.safari/*")
          system("rm -rf ~/Library/Safari/*")
          system("rm -rf ~/Library/\"Saved Application State\"/com.apple.Safari.savedState*")
          system("rm -rf ~/Library/WebKit/com.apple.Safari/*")
          system("rm -rf ~/Library/Cookies/*")
          system("rm -rf ~/Library/Preferences/com.apple.Safari*")
          system("rm -rf ~/Library/\"Internet Plug-ins\"/*")
      end
    end
  end
end

