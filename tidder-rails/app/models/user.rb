class User < ActiveRecord::Base

  include Sociable
  extend SociableClass

  has_many :friendships, foreign_key: "follower_id"
  has_many :followships, foreign_key: "friend_id", class_name: "Friendship"
  has_many :friends, through: :friendships
  has_many :followers, through: :followships

  has_secure_password

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

  def self.edge_weights_map
    Friendship.all.map do |friendship|
      [
        [
        friendship.follower,
        friendship.friend
        ],
        friendship.trust_level
      ]
    end.to_h
  end

  def dijkstra_shortest_path(target)
    dg = self.class.digraph
    ewm = self.class.edge_weights_map
    dg.dijkstra_shortest_path(ewm,self,target)
  end


  def self.save_dot_file(filename="network")
    File.open("#{filename}.dot","w") do |f|
      f.write dot_file
    end
    system "dot -Tsvg #{filename}.dot -o #{filename}.svg"
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
          line << user.id.to_s
          line << " -> "
          line << friend.id.to_s
          line << ";"
          out << line
          out << "\n"
        end
      end
    out << "}"
    out
  end

#============

  def scrypt_authenticate(password)
    scrypt_password = SCrypt::Password.create(password)
    self.authenticate(scrypt_password)
  end

  def scrypt_password=(password)
    scrypt_password = SCrypt::Password.create(password)
    self.password = scrypt_password
  end

end
