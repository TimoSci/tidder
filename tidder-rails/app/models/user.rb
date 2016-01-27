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

  def self.clear_memo
    @@digraph = nil
    @@edge_weights_map = nil
    @@paths = nil
  end

  clear_memo

  def self.digraph
    return @@digraph if @@digraph #memoization
    digraph!
  end

  def self.digraph!
    dg = RGL::DirectedAdjacencyGraph[]
    self.all.each do |user|
      dg.add_vertex(user)
      user.friends.each do |friend|
        dg.add_edge(user,friend)
      end
    end
    @@digraph = dg
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
    return @@edge_weights_map if @@edge_weights_map # memoization
    edge_weights_map!
  end

  def self.edge_weights_map!
    @@edge_weights_map = Friendship.all.map do |friendship|
      [
        [
        friendship.follower,
        friendship.friend
        ],
        friendship.trust_level
      ]
    end.to_h
  end

  def self.implicit_edge_weights_map(memo_size=0)
    lambda{|pair|
            #TODO add memoization hash here (basically an explicit edge weights map of a subset of frienships)
            f = Friendship.find_by(follower:pair[0],friend:pair[1]).try(:trust_level)
          }
  end

  def self.edge_capacities_map
    self.edge_weights_map.map{|k,v|
      [k,1/(v.to_f)]
    }.to_h
  end

  def maximum_flow(sink)
    #TODO remove double-relationships for this to work
    dg = self.class.digraph
    ewm = self.class.edge_weights_map
    dg.maximum_flow(ewm,self,sink)
  end

  def dijkstra_shortest_path(target,type=:explicit)
    case type
    when :explicit
      dg = self.class.digraph
      ewm = self.class.edge_weights_map
    when :implicit
      dg = self.class.implicit_digraph
      ewm = self.class.implicit_edge_weights_map
    end
    dg.dijkstra_shortest_path(ewm,self,target)
  end

  def betweenness_centrality
    total = 0
    @@paths ||= {}  #memoization
    self.class.find_each do |source|
      self.class.find_each do |target|
        path = @@paths[[source,target]] ||= source.dijkstra_shortest_path(target)
        total += 1 if path.include?(self)
      end
    end
    total
  end

  def self.centrality_list
    out = ""
    self.find_each do |user|
      out << user.id.to_s + ": " + user.betweenness_centrality.to_s
      out << "\n"
    end
    out
  end

  def distance(target)
    path = self.dijkstra_shortest_path(target)
    return (1.0/0) if not path
    ewm = self.class.edge_weights_map
    dist = 0
    path.each_cons(2) do |pair|
      dist += ewm[pair]
    end
    dist
  end

  def global_karma
    followships.inject(0){|memo,f| memo + f.trust_level}
  end

  def relative_karma(observer)
    # Returns the relative karma of self from the point of view of the observer
    followships.inject(0){ |memo,f|
      weight = observer.distance(self)
      memo + f.trust_level*(1.0/weight)
    }
  end

  #====

  def self.create_sockpuppet_attack(n)
    swarm = []
    # create swarm
    n.times do |i|
      name = "sockpuppet"+i.to_s
      new_user = self.create(name:name,password:"xxx",password_confirmation:"xxx")
      swarm.each do |user|
        Friendship.create(follower:new_user,friend:user,trust_level:1)
        Friendship.create(follower:user,friend:new_user,trust_level:1)
      end
      swarm << new_user
    end
    # make random connections from existing users
    users = User.where("NAME not like '%sockpuppet%'")
    2.times do
      user = users.sample
      friend = swarm.sample
      Friendship.create(follower:user,friend:friend,trust_level:1)
      Friendship.create(follower:friend,friend:user,trust_level:1)
    end
    clear_memo
  end

  def self.destroy_sockpuppet_attack
    Friendship.find_each do |friendship|
      if friendship.follower.name =~ /sockpuppet/
        friendship.destroy
      end
    end
    User.where("NAME like '%sockpuppet%'").destroy_all
    clear_memo
  end



  #====

  def self.save_dot_file(filename="network")
    File.open("#{filename}.dot","w") do |f|
      f.write dot_file
    end
    system "dot -Tsvg #{filename}.dot -o #{filename}.svg"
  end

  def self.dot_file(method=:name)
    out = ""
    out << "digraph"
    out << " {"
    out << "\n"
      all.each do |user|
        user.friends.each do |friend|
          line = ""
          line << "  "
          line << user.send(method).to_s
          line << " -> "
          line << friend.send(method).to_s
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
