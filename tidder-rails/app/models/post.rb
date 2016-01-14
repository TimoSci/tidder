class Post < ActiveRecord::Base

  include Peckable

  before_create :default_predecessor
  belongs_to :predecessor, class_name: self.to_s

  belongs_to :user
  belongs_to :topic

  has_many :comments

  private

  def default_predecessor
    self.predecessor = self.class.last
  end

end
