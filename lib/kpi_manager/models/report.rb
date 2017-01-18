module KpiManager
  # Allow to manipulate recurrent reports
  class Report < ActiveRecord::Base
    has_many :kpis, class_name: 'KpiManager::Kpi'
    accepts_nested_attributes_for :kpis, allow_destroy: true

    after_initialize :initialize_instance_vars

    enum send_frequency: %w(daily weekly monthly)
    FREQUENCIES = KpiManager::Report.send_frequencies.keys.to_a.freeze

    enum send_step: %w(days weeks months)
    STEPS = KpiManager::Report.send_steps.keys.to_a.freeze

    def generate(from, to = nil)
      @from = from
      @to = to || Time.zone.now
      @report = []

      @datacache.clear

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

      rr = KpiManager::ReportingResult.new(@report)
      rr.from = @from
      rr.to = @to
      rr
    end

    def compare(from, to)
      @from = from
      @to = to
      self
    end

    def with(oth_from, oth_to)
      raise RuntimeError, 'No date range set' unless @from && @to

      left = self.generate(@from, @to).results
      right = self.generate(oth_from, oth_to).results

      res = left.zip(right).map do |left, right|
        [
          left[0],
          (right[1].to_f - left[1].to_f) / left[1].to_f * 100
        ]
      end

      rr = KpiManager::ReportingResult.new(res)
      rr.from = oth_from - @from
      rr.to = oth_to - @to
      rr
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
      all_kpis = KpiManager::Kpi.list
      authorized = kpis.pluck(:slug).map(&:to_sym)
      all_kpis.select { |kpi_name, _kpi_data| authorized.include?(kpi_name) }
    end
  end
end
