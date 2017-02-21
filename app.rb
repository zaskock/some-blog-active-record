#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"
end
get '/newpost' do
	erb :new
end
get '/posts' do
	erb "Hello World!!!"
end

post '/newpost' do
	content=params[:postContent]
	erb "you typed #{content}"
end