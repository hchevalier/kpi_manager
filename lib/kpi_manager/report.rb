module KpiManager
  # Allow to manipulate recurrent reports
  class Report < ActiveRecord::Base
    has_many :kpis, class_name: 'KpiManager::Kpi'

    after_initialize :initialize_instance_vars

    def generate(from, to = nil)
      @from = from
      @to = to || Time.zone.now
      @report = []

      registered_kpis.each do |kpi_name, kpi_data|
        @report << [
          kpi_data[:label],
          send(
            kpi_name,
            get_dataset(kpi_data[:dataset]),
            references(kpi_data[:options])
          )
        ]
      end

      @report
    end

    private

    def initialize_instance_vars(_attributes = {}, options = {})
      @options = options
      @datacache = {}
    end

    def references(kpi_options)
      refs = {}
      kpi_options[:references] ||= []
      kpi_options[:references].each do |kpi_name|
        kpi = registered_kpis[kpi_name]
        refs[kpi_name] = send(
          kpi_name,
          get_dataset(kpi[:dataset]),
          references(kpi[:options])
        )
      end
      refs
    end

    def get_dataset(name)
      @datacache[name] ||= send(name, @from, @to)
    end

    def registered_kpis
      all_kpis = KpiManager::Kpi.class_variable_get(:@@kpis)
      authorized = kpis.pluck(:slug).map(&:to_sym)
      all_kpis.select { |kpi_name, _kpi_data| authorized.include?(kpi_name) }
    end
  end
end
