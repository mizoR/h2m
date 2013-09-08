# -*- coding: utf-8 -*-
require 'bundler/setup'
require 'sinatra/base'
require 'slim'
require 'reverse_markdown'

class App < Sinatra::Base
  get '/' do
    slim :index
  end

  post '/' do
    @html = params[:html].gsub("\r\n", "\n")
    @markdown = ReverseMarkdown.parse @html, :github_style_code_blocks => true
    slim :index
  end

  post '/html2markdown' do
    request.body.rewind
    html = request.body.read
    ReverseMarkdown.parse html, :github_style_code_blocks => true
  end

  post '/csv2ascii' do
    request.body.rewind
    csv = request.body.read
    table = CSV.parse(csv, :col_sep => ',', :headers => true)
    table.to_ascii
  end

  post '/tsv2ascii' do
    request.body.rewind
    tsv = request.body.read
    table = CSV.parse(tsv, :col_sep => "\t", :headers => true)
    table.to_ascii
  end
end

