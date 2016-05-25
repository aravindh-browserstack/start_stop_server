require 'sinatra'
require './server'
require 'json'

include Server

server = ServerClass.new

post '/browsers' do
  content_type :json
  request.body.rewind
  data = JSON.parse request.body.read
  if data.include?("browser") == false
    halt 400, "Browser type not found"
  end
  begin
    proxy_server = nil
    proxy_port = nil
    if data.include?("proxy_server")
      proxy_server = data["proxy_server"]
    end
    if data.include?("proxy_port")
      proxy_port = data["proxy_port"]
    end
    if proxy_port != nil && proxy_server == nil
      halt 404, "both proxy server & port are needed"
    end
    if proxy_port == nil && proxy_server != nil
      halt 404, "both proxy server & port are needed"
    end
    opts = {}
    if proxy_server && proxy_port
      opts = {"proxy_server":proxy_server,"proxy_port": proxy_port}
    end
    server.start(data["browser"],data["url"],opts)
    {status: "success"}.to_json
  rescue ArgumentError
    halt 404, "Browser type not found"
  end   
end


delete '/browsers' do
  content_type :json
  server.stop
  {status:"success"}.to_json
end


put '/browsers' do
  content_type :json
  request.body.rewind
  data = JSON.parse request.body.read
  operation = data['operation']
  case operation
    when 'cleanup'
      server.stop
      server.cleanup
   end
   {status: "success"}.to_json
end
