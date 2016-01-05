class TopicsController < ApplicationController

helpers do

  def tree_tags(object,&block)  # creates a tree of nested html tags

    get_tree_inner = lambda { |object|
      yield object,:start
      yield object,nil
      if object.has_children?
         object.children.each do |c|
            get_tree_inner.call(c)
         end
      end
      yield object,:end
    }

    get_tree_inner.call(object)
end

end



  get '/topics' do
    erb :"topics/index"
  end

  get '/topics/new' do
    erb :"topics/new"
  end


  post '/topics' do
    Topic.create(params)
    erb :"/topics/index"
  end

  get '/topics/:slug' do
    @topic = Topic.find_by_slug(params[:slug])
    @topics = @topic.self_and_descendants
    @posts = []
    @topics.each do |topic|
      @posts |= topic.posts
    end
    erb :"topics/show"
  end

  get '/topics/:slug/edit' do
    @topic = Topic.find_by_slug(params[:slug])
    erb :"/topics/edit"
  end

  post '/topics/:slug' do
    topic = Topic.find_by_slug(params[:slug])
    topic.update(params[:topic])
    redirect "/topics/#{topic.slug}"
  end

  get '/topics/:slug/new_subtopic' do
    @parent = Topic.find_by_slug(params[:slug])
    Topic.create(params[:topic])
    erb :"/topics/new"
  end

  delete '/topics/:slug' do
    topic = Topic.find_by_slug(params[:slug])
    topic.reassign_children
    root_topic = Topic.find_or_create_by(name:"ROOT")
    topic.posts.each {|post| post.topic = root_topic}
    topic.destroy
    redirect "/topics"
  end

end
