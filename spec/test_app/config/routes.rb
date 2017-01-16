Rails.application.routes.draw do
  mount KpiManager::Engine => '/kpi_manager'
end
