# -*- coding: utf-8 -*-
# -*- ruby -*-

#
# TODO: リダイレクト
#

require 'sinatra'
require 'net/http'

require 'open-uri'
require 'json'
require 'uri'

configure do
  set :protection, :except => :frame_options
end

get '/' do
  redirect "index.html"
end

get '/:name' do |name|
  redirect "/GyaTV/#{name}"
end

get '/:project/:name' do |project,name|
  texturl = URI.encode("https://scrapbox.io/api/pages/#{project}/#{name}/text")

  lines = []
  begin
    open(texturl){ |f|
      lines = f.read.split(/\n/)
    }
  rescue
  end
  lines.shift

  if lines.length == 0
    redirect "index.html"
  else
    @lines_json = lines.to_json
    erb :gyatv
  end
end
