require_relative 'sociable'

module Sociable

  def friends_of_friends
     self.friends.inject([]){ |memo,friend| memo |= friend.friends }
  end

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


  class Graph

  	attr_accessor :neighbours, :mapping

  	def initialize(neighbours)
  		@neighbours = neighbours
  		@mapping = neighbours.map{|k,v| [k,k]}.to_h
      remove_dangling
      normalize_neighbours
  		symmetrize_neighbours
  	end

  	def symmetrize_neighbours
  		out = {}
  		neighbours.each do |key,list|
  			list.each do |friend|
  				out[friend] ||= []
  				out[friend] |= [key]
  			end
  			out[key] ||= []
  			out[key] |= list
  		end
  		@neighbours = out
  	end

  	def remove_dangling
  		out = neighbours.map do |key,list|
  			[
  				key,
  				list.select{|x| neighbours.keys.include? x}
  			]
  		end.to_h
  		@neighbours = out
  	end

  	def normalize_neighbours
  		out= {}
  		neighbours.keys.sort.each_with_index do |key,i|
  			@mapping[key] = i
  		end
  		neighbours.each do |key,list|
  			out[mapping[key]] = list.map{|n| mapping[n]}
  		end
  		@neighbours = out
  	end


    def map_back(myhash)
  		m = mapping.invert
  		myhash.map{|k,v| [m[k] , v ]}.to_h
  	end

  	def betweenness_centrality


  		neighbours.each do |key,values|
  			values.each do |value|
  				raise "#{key},#{value}" unless neighbours[value].include? key
  			end
  		end

  		num_nodes = neighbours.keys.size


  		cb = [0] * num_nodes
  		num_nodes.times do |s|
  			cs = []
  			cp = (0...num_nodes).collect { [] }
  			sigma = [0] * num_nodes
  			sigma[s] = 1
  			d = [-1] * num_nodes
  			d[s] = 0
  			cq = []
  			cq << s # enqueue
  			while !cq.empty?
  				v = cq.shift
  				cs.unshift v
  				neighbours[v].each do |w|
  					if d[w] < 0
  						cq << w
  						d[w] = d[v] + 1
  					end
  					if d[w] = d[v] + 1
  						sigma[w] += sigma[v]
  						cp[w] << v
  					end
  				end
  			end
  			delta = [0] * num_nodes
  			cs.each do |w|
  				cp[w].each do |v|
  					delta[v] += (sigma[v].to_f / sigma[w]) * (1+delta[w])
  					cb[w] += delta[w] if w != s
  				end
  			end
  		end

  		out = {}
  		cb.each_with_index do |n,idx|
  			out[idx] = n
  		end

  		return map_back(out)

  	end

  end





end
