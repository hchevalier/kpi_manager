module KpiManager
  class ReportingResult # :nodoc:
    attr_accessor :results, :from, :to

    def initialize(table)
      @results = table
    end

    def period(i)
      @results[i]
    end

    def -(other)
      left = results
      right = other.results

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
      rr.from = other.from - from
      rr.to = other.to - to
      rr
    end
  end
end
