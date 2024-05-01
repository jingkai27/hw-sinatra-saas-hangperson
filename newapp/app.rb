require 'sinatra'

set :bind, "0.0.0.0"
port = ENV["PORT"] || "8080"
set :port, port

class MyApp < Sinatra::Base
  get '/' do
    "<!DOCTYPE html><html><head></head><body><h1>Hello World</h1></body></html>"
  end
end