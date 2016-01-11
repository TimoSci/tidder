class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.text :name
      t.text :about
      t.references :user, index: true
      t.references :parent, index: true
    end
  end
end
