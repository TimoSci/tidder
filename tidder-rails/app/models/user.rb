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

end
