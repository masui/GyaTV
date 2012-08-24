# -*- coding: utf-8 -*-
# -*- ruby -*-

#
# TODO: リダイレクト
#

require 'rubygems'
require 'sinatra'

get '/:name' do |name|
  @name = name
  erb :gyatv
end
