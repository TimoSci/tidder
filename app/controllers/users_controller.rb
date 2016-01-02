class UsersController < ApplicationController

  get '/users' do
    erb :"/users/index"
  end

  get '/users/new' do
    erb :"/users/new"
  end

  post '/users' do
    @user = User.create(params)
    erb :"/users/show"
  end

  get '/users/:id' do
    @user = User.find(params[:id])
    erb :"/users/show"
  end

  post '/users/:id' do
    user = User.find(params[:id])
    user.update(params[:user])
    redirect "/users/#{params[:id]}"
  end

  get '/users/:id/edit' do
    @user = User.find(params[:id])
    erb :"/users/edit"
  end

  post '/users/:id/delete' do
    user = User.find(params[:id])
    user.destroy_full
    redirect "/users"
  end

end
