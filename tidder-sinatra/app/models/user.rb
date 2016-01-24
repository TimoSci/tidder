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

end
