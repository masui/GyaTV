# -*- coding: utf-8 -*-
# -*- ruby -*-

require 'rubygems'
require 'sinatra'

get '/:name' do |name|
  @name = name
  erb :gyatv
end
