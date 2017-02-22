#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"
end

def db_init
	@db= SQLite3::Database.new 'forum.db'
	@db.results_as_hash=true
end

before do
	db_init
end

configure do
	db_init
	@db.execute 'CREATE TABLE if not exists "posts" ("id" INTEGER PRIMARY KEY AUTOINCREMENT,"created_date" DATE,"content" TEXT)'
end

get '/newpost' do
	erb :new
end
get '/posts' do
	erb "Hello World!!!"
end

post '/newpost' do
	content=params[:postContent]
	if content.length<1
		@error="Type something, please!"
		return erb :new
	end
	erb "you typed #{content}"
end