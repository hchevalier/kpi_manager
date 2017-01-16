module KpiManager
  class MigrationsGenerator < Rails::Generators::Base # :nodoc:
    source_root File.expand_path('../templates', __FILE__)

    def copy_files
      time = Time.zone.now.strftime('%Y%m%d%H%M')
      dashboard_mig = "db/migrate/#{time}00_create_kpi_manager_dashboard.rb"
      template 'dashboard_migration.rb', dashboard_mig
      report_mig = "db/migrate/#{time}01_create_kpi_manager_report.rb"
      template 'report_migration.rb', report_mig
      kpi_mig = "db/migrate/#{time}02_create_kpi_manager_kpi.rb"
      template 'kpi_migration.rb', kpi_mig
    end
  end
end
