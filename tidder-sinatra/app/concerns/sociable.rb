module Sociable

  def betweenness_centrality
    self.class.centrality_list[self.id]
  end

  def destroy_full
    self.friends.destroy_all
    self.followers.destroy_all
    self.destroy
  end

end


module SociableClass

  def dot_file
    all
  end

  def graph
    g = all.map do |user|
      [ user.id,
        user.friends.map(&:id)
      ]
    end.to_h
    Graph.new(g)
  end

  def centrality_list
    graph.betweenness_centrality
  end

end
