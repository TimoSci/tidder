# require 'rgl/adjacency'
# require 'rgl/dot'
# require 'rgl/implicit'

class User < ActiveRecord::Base

  extend SociableClass
  include Sociable

  has_many :friendships, foreign_key: "follower_id"
  has_many :followships, foreign_key: "friend_id", class_name: "Friendship"
  has_many :friends, through: :friendships
  has_many :followers, through: :followships

  has_many :posts
  has_many :topics
  has_many :comments

  def to_s
    self.name
  end


  def self.digraph
    dg = RGL::DirectedAdjacencyGraph[]
    self.find_each do |user| # unlike #all, #find_each is an Enumerator that doesn't load the entire set of users into memory
      dg.add_vertex(user)
      user.friends.each do |friend|
        dg.add_edge(user,friend)
      end
    end
    dg
  end

  def self.implicit_digraph
    RGL::ImplicitGraph.new { |g|
       g.vertex_iterator { |b|
         User.find_each(&b)
       }
       g.adjacent_iterator { |x, b|
         x.friends.each(&b)
       }
       g.directed = true
    }
  end



  def self.save_dot_file(filename)
    File.open("#{filename}.dot","w") do |f|
      f.write dot_file
    end
  end

  def self.dot_file
    out = ""
    out << "digraph"
    out << " {"
    out << "\n"
      all.each do |user|
        user.friends.each do |friend|
          line = ""
          line << "  "
          line << user.name.to_s
          line << " -> "
          line << friend.name.to_s
          line << ";"
          out << line
          out << "\n"
        end
      end
    out << "}"
    out
  end

 end
