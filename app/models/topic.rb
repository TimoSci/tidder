class Topic < ActiveRecord::Base

  has_many :posts
  belongs_to :user
  belongs_to :parent, class_name: "Topic"
  has_many :children, class_name: "Topic", foreign_key: "parent_id"

  def owner
    user
  end

end
