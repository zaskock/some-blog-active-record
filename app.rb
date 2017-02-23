#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

get '/' do
	@results=@db.execute 'select * from posts order by Id desc'
	erb :index
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
	@db.execute 'CREATE TABLE if not exists "posts" ("id" INTEGER PRIMARY KEY AUTOINCREMENT,"created_date" TIMESTAMP,"content" TEXT)'
	@db.execute 'CREATE TABLE if not exists "comments" ("id" INTEGER PRIMARY KEY AUTOINCREMENT,"created_date" TIMESTAMP,"content" TEXT, post_id Integer)'
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
	@db.execute 'Insert into "posts"(content, created_date) values (?, datetime())', [content]
	redirect to '/'
end

get '/post/:post_id' do
	post_id=params[:post_id]
	result=@db.execute 'select * from posts where id=?', [post_id]
	@post=result[0]
	erb :post
end
post '/post/:post_id' do
	post_id=params[:post_id]
	content=params[:postContent]
	#result=@db.execute 'select * from posts where id=?', [post_id]
	#@post=result[0]
	@db.execute 'Insert into "comments"(content, created_date, post_id) values (?, datetime(), ?)', [content, post_id]
	redirect to ('/post/'+post_id)
end