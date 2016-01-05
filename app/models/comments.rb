class Comment < ActiveRecord::Base

  include Parentable
  extend ParentableClass

  belongs_to :user
  belongs_to :post

  belongs_to :parent, class_name: self.to_s
  has_many :children, class_name: self.to_s, foreign_key: "parent_id"

  def name
    text
  end

end
