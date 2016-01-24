class PostsController < ApplicationController

  get '/posts' do
    erb :"posts/index"
  end

  get '/posts/:id' do
    @post = Post.find(params[:id])
    erb :"posts/show"
  end

  post '/posts/users/:user_id' do
    @user = User.find(params[:user_id])
    post = Post.new(params[:post])
    post.user = @user
    post.save
    redirect "users/#{@user.id}"
  end

  post '/posts/:id/delete' do
    post = Post.find(params[:id])
    @user = post.user
    post.destroy
    redirect "users/#{@user.id}"
  end


end
