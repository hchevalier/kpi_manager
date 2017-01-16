class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :car
      t.references :user
      t.references :promotion
      t.float :paid_price

      t.timestamps null: false
    end
  end
end
