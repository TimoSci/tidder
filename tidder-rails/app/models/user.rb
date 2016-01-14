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

  def scrypt_authenticate(password)
    scrypt_password = SCrypt::Password.create(password)
    self.authenticate(scrypt_password)
  end

  def scrypt_password=(password)
    scrypt_password = SCrypt::Password.create(password)
    self.password = scrypt_password
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
