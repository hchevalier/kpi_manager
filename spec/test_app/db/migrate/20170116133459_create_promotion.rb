class CreatePromotion < ActiveRecord::Migration
  def change
    create_table :promotions do |t|
      t.integer :percentage
    end
  end
end
