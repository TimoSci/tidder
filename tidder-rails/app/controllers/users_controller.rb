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
        graph_observer = User.first
        @vertices = dg.vertices.map {|user| { name: user.name, group: 1, karma: user.relative_karma(graph_observer), global_karma: user.global_karma } }
        @edges = dg.edges.map do |edge|
          { source: (edge.source.id - 1),
            target: (edge.target.id - 1),
            value: 1 }
        end
        render :json => { vertices: @vertices, edges: @edges }
      }
    end
  end

  def d3_graph
    @dg = User.digraph
    @position_ids = @dg.map { |user| user.id }
  end

  def d3_graph_global_karma
    @dg = User.digraph
    @position_ids = @dg.map { |user| user.id }
  end

  def d3_graph_local_karma_first
    @dg = User.digraph
    @user = User.first
    @position_ids = @dg.map { |user| user.id }
  end

  def d3_graph_local_karma_last
    @dg = User.digraph
    @user = User.last
    @position_ids = @dg.map { |user| user.id }
  end

  def d3_graph_local_karma_gabriel
    @dg = User.digraph
    @user = User.find_by(name: "Gabriel")
    @position_ids = @dg.map { |user| user.id }
    render 'd3_graph_local_karma_last'
  end

  def d3_graph_sockpuppet
    @user = User.last
    User.create_sockpuppet_attack(12)
    @dg = User.digraph
    @position_ids = @dg.map { |user| user.id }
  end

  def clear_sockpuppet
    User.destroy_sockpuppet_attack
    head 200
  end
end
