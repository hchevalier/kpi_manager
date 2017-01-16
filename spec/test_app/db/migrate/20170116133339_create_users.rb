class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :firstname
      t.string :lastname
      t.string :email
      t.date :birthdate
      t.boolean :enabled, default: :true

      t.timestamps null: false
    end
  end
end
