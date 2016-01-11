class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.references :follower, index: true
      t.references :friend, index: true
      t.integer :trust_level
    end
  end
end
