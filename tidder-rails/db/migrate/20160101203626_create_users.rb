class CreateUsers < ActiveRecord::Migration

  def change
    create_table :users do |t|
      t.text :name
      t.text :username
      t.text :description
      t.text :email
      t.text :password_digest
    end
  end

end
