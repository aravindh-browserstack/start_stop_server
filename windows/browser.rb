require 'win32ole'
module Browser
  class BrowserClass
    def initialize(browser_name,url=nil,options={})
      @browsername = browser_name
      proxy_server = options[:proxy_server]
      proxy_port = options[:proxy_port]
      unless (proxy_server.nil? || proxy_port.nil?)
        system(%Q|START reg add "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f|)
        system(%Q|START reg add "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings" /v ProxyServer /t REG_SZ /d |+proxy_server+":"+proxy_port+%Q| /f|)
        # Add exception for localhost; without which this server API will be inaccessible
        system(%Q|START reg add "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings" /v ProxyOverride /t REG_SZ /d "localhost;" /f|)
        
      end
      case browser_name
        when "firefox"
          @browsertype = "firefox.exe"
          system(windows_path(%Q|START "" "C:/Program Files (x86)/Mozilla Firefox/firefox.exe" "|+url.to_s+%Q|"|))
        when "chrome"
          @browsertype = "chrome.exe"
          system(windows_path(%Q|START "" "C:/Program Files (x86)/Google/Chrome/Application/chrome.exe" "|+url.to_s+%Q|"|))
        when "ie"
          @browsertype = "iexplore.exe"
          system(windows_path(%Q|START "" "C:/Program Files/Internet Explorer/iexplore.exe" "|+url.to_s+%Q|"|))
        else
          raise ArgumentError
      end
    end

    def windows_path(p)
      p.gsub("/","\\")
    end
    
    def stop
      system(%Q|taskkill /F /IM |+@browsertype)
      system(%Q|START reg add "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f|)

    end

    def cleanup 
      case @browsername
        when "firefox"
          root_path = ENV["localappdata"]
          cmd = %Q| cmd /C del /s /q "|+root_path+windows_path(%Q|/Mozilla/Firefox/Profiles/*.*"|)
          system(cmd)
          root_path = ENV["appdata"]
          cmd = %Q| cmd /C del /s /q "|+root_path+windows_path(%Q|/Mozilla/Firefox/Profiles/*.*"|)
          system(cmd)
        when "chrome"
          root_path = ENV["localappdata"]
          cmd = %Q| cmd /C del /s /q "|+root_path+windows_path(%Q|/Google/Chrome/User Data/Default/*.*"|)
          puts cmd
          system(cmd)
        when "ie"
          root_path = ENV["localappdata"]
          cmd = %Q| cmd /C del /s /q "|+root_path+windows_path(%Q|/Microsoft/Windows/INetCache/*.*"|)
          system(cmd)
          cmd = %Q| cmd /C del /s /q "|+root_path+windows_path(%Q|/Microsoft/Windows/INetCookies/*.*"|)
          system(cmd)
          cmd = %Q| cmd /C del /s /q "|+root_path+windows_path(%Q|/Microsoft/Internet Explorer/*.*"|)
          system(cmd)
          cmd = %Q| cmd /C del /s /q "|+root_path+windows_path(%Q|/Microsoft/Windows/Temporary Internet Files/*.*"|)
      end
    end
  end
end

