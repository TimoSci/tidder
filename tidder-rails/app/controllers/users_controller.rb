class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    user.update(params[:user])
    redirect_to user_path(user)
  end

  def destroy
    user = User.find(params[:id])
    user.destroy_full
    redirect_to users_path
  end

  def d3
    respond_to do |format|
      format.html { }
      format.json {
        dg = User.digraph
        @vertices = dg.vertices.map {|user| { name: user.name, group: 1 } }
        @edges = dg.edges.map do |edge|
          { source: (edge.source.id - 1),
            target: (edge.target.id - 1),
            value: 1 }
        end
        render :json => { vertices: @vertices, edges: @edges }
      }
    end
  end

end
