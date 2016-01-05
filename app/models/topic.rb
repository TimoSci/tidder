class Topic < ActiveRecord::Base

  include Slug
  extend SlugClass

  include Parentable
  extend ParentableClass

  has_many :posts
  belongs_to :user

  belongs_to :parent, class_name: "Topic"
  has_many :children, class_name: "Topic", foreign_key: "parent_id"

  def owner
    user
  end

  ### Tree Methods

  def longname(separator=' > ')
    o = self
    out = [o.name]
    if not o.is_orphan?
      begin
        o = o.parent
        out << o.name
      end until o.is_orphan?
    end
    out.reverse!
    out.join(separator)
  end

end
