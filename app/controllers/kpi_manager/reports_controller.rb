module KpiManager
  class ReportsController < KpiManager::ApplicationController # :nodoc:
    def index
      @reports = Report.all
    end

    def show
      @report = Report.find(params[:id])
    end

    def new
      @report = Report.new
    end

    def create
      @report = Report.new(permited_params)
      @report.send_at = Date.today.beginning_of_day + @report.send_hour.hours
      @report.send_at += 24.hours if @report.send_at < Time.zone.now
      if @report.save
        redirect_to reports_path
      else
        render :new
      end
    end

    def edit
      @report = Report.find(params[:id])
    end

    def update
      @report = Report.find(params[:id])
      @report.send_at = Date.today.beginning_of_day + @report.send_hour.hours
      @report.send_at += 24.hours if @report.send_at < Time.zone.now
      if @report.update(permited_params)
        redirect_to reports_path
      else
        render :edit
      end
    end

    def export
      @report = Report.find(params[:id])
      res = @report.generate(params[:from], params[:to])
      require 'csv'
      csv_string = CSV.generate do |csv|
        res.results.each do |kpi|
          csv << kpi
        end
      end
      send_data csv_string, filename: 'report.csv'
    end

    private

    def permited_params
      params.require(:report).permit(
        :name,
        :send_hour,
        :send_frequency,
        :send_step,
        :recipients,
        kpis_attributes: [:id, :slug, :kpi_type, :unit, :_destroy]
      )
    end
  end
end
