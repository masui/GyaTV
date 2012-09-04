# -*- coding: utf-8 -*-
# -*- ruby -*-

#
# TODO: リダイレクト
#

require 'rubygems'
require 'sinatra'
require 'net/http'
require 'gyazz'

get '/' do
  redirect "/index.html"
end

get '/gunosy/:name' do |name|
  # url = URI.parse('http://gunosy.com/#{name}')
#  Net::HTTP.version_1_2
#  USER_AGENT= "
  headers = {
    'Referer' => 'http://pitecan.com',
    'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:9.0.1) Gecko/20100101 Firefox/9.0.1'
  }
  res = Net::HTTP.start("gunosy.com", 80) { |http|
    http.get("/#{name}",headers)
  }
#  File.open("/tmp/log","w"){ |f|
#    f.print res.body
#  }
  urls = []
  s = res.body
  while s.sub!(/<a href="http:\&\#47;\&\#47;(\S+)" target="_blank"><span class="favicon">/,'') do
  end
  while s.sub!(/<a href="http:\&\#47;\&\#47;(\S+)" target="_blank">/,'') do
    url = "http://" + $1
    url.gsub!(/\&\#47;/,'/')
    urls << url unless urls.member?(url)
  end
  #res.body

  gyazz = Gyazz.new("GyaTV")
  gyazztext = urls.join("\n")
  gyazz.set(name,gyazztext)

#  File.open("/tmp/lll","w"){ |f|
#    f.print urls
#  }

  urls.join("<br>")

  @name = name
  erb :gyatv
end

get '/:name' do |name|
  @name = name
  erb :gyatv
end
