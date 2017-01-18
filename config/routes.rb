KpiManager::Engine.routes.draw do
  get '/reports/:id/export', to: 'reports#export', as: :generate_report
  resources :reports

  root 'reports#index'
end
