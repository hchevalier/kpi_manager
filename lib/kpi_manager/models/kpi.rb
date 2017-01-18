module KpiManager
  # Represent a KPI bound to a specific report
  class Kpi < ActiveRecord::Base
    belongs_to :report, class_name: 'KpiManager::Report'

    enum kpi_type: {
      type_counter: 0,
      type_average: 1,
      type_percentage: 2,
      type_curve: 3
    }
    TYPES = KpiManager::Kpi.kpi_types.keys.to_a.map { |k| [k.remove('type_'), k] }.freeze

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

    def self.list
      class_variable_get(:@@kpis)
    end
  end
end
