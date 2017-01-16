module KpiManager
  # Allow scope-like behavior, KPIs use datasets to compute data from
  class Dataset
    def self.add(name, &block)
      b = block
      KpiManager::Report.class_eval do
        define_method(name) do |from, to|
          b.call(from, to)
        end
      end
    end
  end
end
