module KpiManager
  # Allow to manipulate recurrent reports
  class Report < ActiveRecord::Base
    has_many :kpis, class_name: 'KpiManager::Kpi'
    accepts_nested_attributes_for :kpis, allow_destroy: true

    enum send_frequency: %w(daily weekly monthly)
    FREQUENCIES = KpiManager::Report.send_frequencies.keys.to_a.freeze

    enum send_step: %w(days weeks months)
    STEPS = KpiManager::Report.send_steps.keys.to_a.freeze

    def generate(from, to, step)
      init_vars(from, to, step)

      @from = from
      while @from < @initial_to
        @to = @from + express_in_days(step)
        @to = @to > @initial_to ? @initial_to : @to
        @datacache.clear
        @period << I18n.localize(@from)
        @report << generate_period
        @from = @to
      end

      rr = KpiManager::ReportingResult.new(@report)
      rr.from = @initial_from
      rr.to = @initial_to
      rr
    end

    def express_in_days(step)
      case step
      when :daily
        1.day
      when :weekly
        1.week
      when :monthly
        1.month
      end
    end

    def compare(from, to, step)
      init_vars(from, to, step)
      self
    end

    def with(oth_from, oth_to, oth_step)
      raise NoDateRange, 'No date range set' unless @initial_from && @initial_to

      left = generate(@initial_from, @initial_to, @step).results
      # FIXME: params break @initial_from and @initial_to below
      right = generate(oth_from, oth_to, oth_step).results

      res = []
      left.each_with_index do |period, i|
        res << period.zip(right[i]).map do |left_period, right_period|
          [
            left_period[0],
            (right_period[1].to_f - left_period[1].to_f) / left_period[1].to_f * 100
          ]
        end
      end

      rr = KpiManager::ReportingResult.new(res)
      rr.from = oth_from - @initial_from
      rr.to = oth_to - @initial_to
      rr
    end

    private

    def init_vars(from, to, step)
      @initial_from = from
      @initial_to = to
      @step = step

      @datacache = {}
      @report = []
      @period = []
    end

    def generate_period
      step_report = []

      registered_kpis.each do |kpi_name, kpi_data|
        step_report << [
          kpi_data[:label],
          send(
            kpi_name,
            get_dataset(kpi_data[:dataset]),
            references(kpi_data[:options])
          )
        ]
      end

      step_report
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
