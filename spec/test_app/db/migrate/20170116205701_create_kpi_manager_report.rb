class CreateKpiManagerReport < ActiveRecord::Migration # :nodoc:
  def change
    create_table :kpi_manager_reports do |t|
      t.string :name
      # TODO: handle recurrency
      # TODO: handle multiple recipients

      t.timestamps null: false
    end
  end
end
