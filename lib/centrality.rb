#!/usr/bin/env ruby
# brandes algorithm for betweenness centrality. http://www.cs.ucc.ie/~rb4/resources/Brandes.pdf
#require 'pry'

# neighbours = {
# 	0=>[6,7,8,9,11,12],
# 	1=>[2,3,4,5],
# 	2=>[3,4,5,1],
# 	3=>[1,2,6,4,5],
# 	4=>[5,1,2,3,6],
# 	5=>[1,2,3,4],
# 	6=>[4,3,7,0],
# 	7=>[6,8,10,12,0],
# 	8=>[9,11,0,7],
# 	9=>[10,11,12,0,8],
# 	10=>[11,7,9],
# 	11=>[12,0,8,9,10],
# 	12=>[0,7,9,11],
# }


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

  #TODO write a proper normalization algorithm rather than this clutch
	# def normalized_neighbours
	#   neighbours.map do |k,list|
  #     [
	# 		  k-1,
	# 			list.map{|n| n-1}
	# 		]
  #   end.to_h
  # end

	# def denormalized_keys(myhash)
	# 	myhash.map do |k,list|
	# 		[
	# 			k+1,
	# 			list
	# 		]
	# 	end.to_h
	# end

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

		# dot = File.open("test.dot","w")
		# dot.puts "graph {"
		# neighbours.each do |key,values|
		# 	values.each do |value|
		# 		dot.puts "#{key} -- #{value}" if key<value
		# 	end
		# end
		# dot.puts "}"
		# dot.close

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

 # g = Graph.new(neighbours)
 # binding.pry
 # puts g.betweenness_centrality
