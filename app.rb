#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, "sqlite3:some-blog-a-r.db"

class Post < ActiveRecord::Base
end

class Comment < ActiveRecord::Base
end


get '/' do
	erb :index
end

def db_init
	@db= SQLite3::Database.new 'forum.db'
	@db.results_as_hash=true
end

before do
	@posts = Post.all
	@comments = Comment.all
end

get '/newpost' do
	erb :new
end

post '/newpost' do
	@content=params[:postContent]
	@author=params[:author]

	if @author.length<1
		@error="Enter your name, please!"
		return erb :new
	end
	if @content.length<1
		@error="Type something, please!"
		return erb :new
	end

	@db.execute 'Insert into "posts"(content, author, created_date) values (?, ?, datetime())', [@content, @author]
	redirect to '/'
end

get '/post/:post_id' do
	post_id=params[:post_id]
	result=@db.execute 'select * from posts where id=?', [post_id]
	@comments=@db.execute 'select * from comments where post_id=? order by Id', [post_id]
	@post=result[0]

	erb :post
end

post '/post/:post_id' do
	post_id=params[:post_id]
	@author=params[:author]
	@content=params[:postContent]
	#result=@db.execute 'select * from posts where id=?', [post_id]
	#@post=result[0]
	if @author.length<1
		#@error="Enter your name, please!"
		redirect to ('/post/'+post_id)
	end
	if @content.length<1
		#@error="Type something, please!"
		redirect to ('/post/'+post_id)
	end
@db.execute 'Insert into "comments"(author, content, created_date, post_id) values (?, ?, datetime(), ?)', [@author, @content, post_id]
	redirect to ('/post/'+post_id)
end