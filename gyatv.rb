# -*- coding: utf-8 -*-
# -*- ruby -*-

#
# TODO: リダイレクト
#

# LetsEncryptのROOT証明書の期限が切れたら古いOSからアクセスできなくなって困った
# https://beyondjapan.com/blog/2021/10/letsencrypt-dst-root-ca-x3-expiration/
# 2021/10/1からこういう問題が発生した模様
# 直し方がわからないのでcurlでしのいでみる
#
# 面倒なのでHerokuにしてみた
# open-uriが何故か動かないのでcurlを使ってる
# (Herokuでもcurl使えるのね...)
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
  display 'GyaTV', name
end

get '/:project/:name' do |project,name|
  display project, name
end

def display(project,name)
  texturl = URI.encode("https://scrapbox.io/api/pages/#{project}/#{name}/text")

  lines = []
  begin
    #open(texturl){ |f|
    #  lines = f.read.split(/\n/)
    #}
    lines = `curl #{texturl}`.split(/\n/) # Herokuでもこれを使ってみる
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
