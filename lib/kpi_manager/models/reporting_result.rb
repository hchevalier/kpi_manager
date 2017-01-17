module KpiManager
  class ReportingResult
    attr_accessor :results, :from, :to

    def initialize(table)
      @results = table
    end

    def -(other)
      left = self.results
      right = other.results
      res = left.zip(right).map do |left, right|
        [
          left[0],
          (right[1].to_f - left[1].to_f) / left[1].to_f * 100
        ]
      end
      rr = KpiManager::ReportingResult.new(res)
      rr.from = other.from - self.from
      rr.to = other.to - self.to
      rr
    end
  end
end
