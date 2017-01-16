$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'kpi_manager/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'kpi_manager'
  s.version     = KpiManager::VERSION
  s.authors     = ['Hugo Chevalier']
  s.email       = ['drakhaine@gmail.com']
  s.homepage    = 'https://github.com/hchevalier/kpi_manager'
  s.date        = '2016-01-17'
  s.summary     = 'Create recurrent reports from KPIs.'
  s.description = <<-EOF
    KpiManager allows to create reports from a back-office.
    KPIs must be defined in the code before they're available in reports editor.
    On v1.0.0, it will be possible to schedule recurrent reporting by email
    and to create report-tied dashboards displaying widgets for each of your KPIs.
  EOF
  s.license     = 'MIT'

  s.files       = Dir[
                  '{app,config,db,lib}/**/*',
                  'MIT-LICENSE',
                  'Rakefile',
                  'README.rdoc'
                ]
  s.test_files  = Dir['spec/**/*.rb']

  s.add_dependency 'rails', '~> 4.2.7'
  # Database
  s.add_development_dependency 'sqlite3'
  # Tests
  s.add_development_dependency 'rake', '~> 12.0.0'
  s.add_development_dependency 'rspec', '~> 3.5'
  s.add_development_dependency 'rspec-rails', '~> 3.5'
  s.add_development_dependency 'rspec-mocks', '~> 3.5'
  s.add_development_dependency 'factory_girl_rails', '~> 4.8.0'
  s.add_development_dependency 'faker', '~> 1.7.0'
  # Test coverage
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'codeclimate-test-reporter', '~> 1.0.0'
  # Coding style
  s.add_development_dependency 'rubocop', '~> 0.46.0'
end
