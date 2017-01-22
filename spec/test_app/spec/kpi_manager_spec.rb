require 'spec_helper'
require 'rails_helper'

RSpec.describe KpiManager::Report, :type => :model do
  before(:all) do
    car1 = create(:car, price: 1000.00)
    car2 = create(:car, price: 2000.00)

    user1 = create(:user, created_at: 10.minutes.ago)
    user2 = create(:user, created_at: 3.minutes.ago)
    old_user = create(:user, created_at: 35.days.ago)

    old_user.buy_car(car1, Promotion.create(percentage: 30))
    old_user.orders.last.update(created_at: 33.days.ago)

    user1.buy_car(car1)
    user2.buy_car(car2, Promotion.create(percentage: 10))
  end

  it 'generates a full report' do
    @report = KpiManager::Report.create(name: 'My first report')
    @report.kpis.create(slug: 'users_count')
    @report.kpis.create(slug: 'total_earned')
    @report.kpis.create(slug: 'average_order')
    @report.kpis.create(slug: 'promotion_used')
    @report.kpis.create(slug: 'average_promotion')

    expectancy = [
      ["Subscribed users", 2],
      ["Total earned", 2800.00],
      ["Average order", 1400.00],
      ["Promotion used", 1],
      ["Average promotion", 5]

    ]
    report = @report.generate(30.days.ago, Time.zone.now, :monthly)
    expect(report.period(0)).to eql(expectancy)
  end

  it 'generates a report for previous month' do
    @report = KpiManager::Report.create(name: 'My first report')
    @report.kpis.create(slug: 'users_count')

    expectancy = [
      ["Subscribed users", 1]
    ]
    report = @report.generate(60.days.ago, 31.days.ago, :monthly)
    expect(report.period(0)).to eql(expectancy)
  end

  it 'generates a report for current month' do
    @report = KpiManager::Report.create(name: 'My first report')
    @report.kpis.create(slug: 'users_count')

    expectancy = [
      ["Subscribed users", 2]
    ]
    report = @report.generate(30.days.ago, Time.zone.now, :monthly)
    expect(report.period(0)).to eql(expectancy)
  end

  context 'generating a diff' do
    it 'works with compare().with()' do
      @report = KpiManager::Report.create(name: 'My first report')
      @report.kpis.create(slug: 'users_count')
      @report.kpis.create(slug: 'total_earned')
      @report.kpis.create(slug: 'average_order')

      expectancy = [
        ["Subscribed users", 100.0],
        ["Total earned", 300.00],
        ["Average order", 100.00]
      ]
      report = @report.compare(60.days.ago, 31.days.ago, :monthly).with(30.days.ago, Time.zone.now, :monthly)
      expect(report.period(0)).to eql(expectancy)
    end

    it 'works when subtracting two report results' do
      @report = KpiManager::Report.create(name: 'My first report')
      @report.kpis.create(slug: 'promotion_used')
      @report.kpis.create(slug: 'average_promotion')

      expectancy = [
        ["Promotion used", 0.0],
        ["Average promotion", -83.33333333333334]
      ]
      report1 = @report.generate(60.days.ago, 31.days.ago, :monthly)
      report2 = @report.generate(30.days.ago, Time.zone.now, :monthly)
      expect((report1 - report2).period(0)).to eql(expectancy)
    end
  end
end
