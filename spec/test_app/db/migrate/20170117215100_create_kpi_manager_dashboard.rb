class CreateKpiManagerDashboard < ActiveRecord::Migration # :nodoc:
  def change
    create_table :kpi_manager_dashboards do |t|
      t.string :name
      t.string :slug

      t.timestamps null: false
    end
  end
end
