class CreateKpiManagerReport < ActiveRecord::Migration # :nodoc:
  def change
    create_table :kpi_manager_reports do |t|
      t.string :name
      t.integer :send_hour
      t.integer :send_frequency
      t.integer :send_step
      t.datetime :send_at
      t.text :recipients

      t.timestamps null: false
    end
  end
end
