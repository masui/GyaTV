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
  redirect "/index.html"
end

get '/:name' do |name|
  texturl = URI.encode("https://scrapbox.io/api/pages/GyaTV/#{name}/text")

  lines = []
  begin
    open(texturl){ |f|
      lines = f.read.split(/\n/)
    }
  rescue
  end
  lines.shift

  @lines_json = lines.to_json

  erb :gyatv
end
