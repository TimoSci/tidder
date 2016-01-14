class CreatePosts < ActiveRecord::Migration

  def change
    create_table :posts do |t|
      t.text :title
      t.text :body
      t.references :user, index: true
      t.references :topic, index: true
      t.references :predecessor, index: true
    end
  end

end
