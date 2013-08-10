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
    @html = params[:html]
    @markdown = ReverseMarkdown.parse @html, :github_style_code_blocks => true
    slim :index
  end
end

