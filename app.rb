#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, "sqlite3:some-blog-a-r.db"

class Post < ActiveRecord::Base
	has_many :comments, dependent: :destroy
	validates :author, presence: true, length: {minimum: 3}
	validates :content, presence: true, length: {minimum: 55}
end

class Comment < ActiveRecord::Base
	belongs_to :post
	validates :author, presence: true, length: {minimum: 3}
	validates :content, presence: true, length: {minimum: 19}
end

get '/' do
	erb :index
end

before do
	@dataposted=Post.new
	@posts = Post.order('created_at DESC')
#	@comments = Comment.all
	@comment = Comment.new
end

get '/newpost' do
	erb :new
end

get '/comments' do
	erb :comments
end

post '/newpost' do
@dataposted=Post.new params[:post]

	if @dataposted.save
		redirect to '/'
	else
		@error = "An error occurred, the record has not been saved to database! </br>Details: "+@dataposted.errors.full_messages.first
		erb :new
	end

end

get '/post/:post_id' do
	@post= Post.find (params[:post_id])
	@comments= @post.comments

	erb :post
end

post '/post/:post_id' do
	postid=params[:post_id]
	@post= Post.find (postid)
	@comments= @post.comments

	@comment=Comment.new params[:comment]

	if @comment.save
		redirect to ('/post/'+postid)
	else
		@error = "An error occurred, the record has not been saved to database! </br>Details: "+@comment.errors.full_messages.first
		erb :post
	end
end