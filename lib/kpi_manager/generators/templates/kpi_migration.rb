class CreateKpiManagerKpi < ActiveRecord::Migration # :nodoc:
  def change
    create_table :kpi_manager_kpis do |t|
      t.string :slug
      t.integer :kpi_type
      t.string :unit
      t.references :report
    end
  end
end
