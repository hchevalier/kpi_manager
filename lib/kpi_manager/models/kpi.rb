module KpiManager
  # Represent a KPI bound to a specific report
  class Kpi < ActiveRecord::Base
    belongs_to :report, class_name: 'KpiManager::Report'

    @@kpis = {}

    def self.add(name, label, options = nil, &block)
      options ||= {}
      dataset = options[:dataset]
      b = block
      raise 'No dataset to work against' unless dataset
      KpiManager::Report.class_eval do
        define_method(name) do |dataset_p, **refs|
          b.call(dataset_p, refs)
        end
      end
      @@kpis[name] = { dataset: dataset, label: label, options: options }
    end
  end
end
