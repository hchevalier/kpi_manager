class CreateKpiManagerKpi < ActiveRecord::Migration # :nodoc:
  def change
    create_table :kpi_manager_kpis do |t|
      t.string :slug
      t.references :report
    end
  end
end
