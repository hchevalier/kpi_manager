require 'spec_helper'
require 'rails_helper'

RSpec.describe KpiManager::Report, :type => :model do
  it 'generates a report' do
    p206 = Car.create(brand: 'Peugot', model: '206', price: 9890.90)
    zoe = Car.create(brand: 'Renault', model: 'Zoé', price: 12500)

    hugo = User.create(
      firstname: 'Hugo',
      lastname: 'Chevalier',
      email: 'email@gmail.com',
      birthdate: Date.parse('1989-05-01')
    )

    drakhaine = User.create(
      firstname: 'Drakhaine',
      lastname: 'Arakhnide',
      email: 'email@gmail.com',
      birthdate: Date.parse('1989-04-24')
    )

    hugo.buy_car(p206)
    drakhaine.buy_car(zoe, Promotion.create(percentage: 10))

    report = KpiManager::Report.create(name: 'My first report')
    report.kpis.create(slug: 'users_count')
    report.kpis.create(slug: 'total_earned')
    report.kpis.create(slug: 'average_order')
    expectancy = [
      ["Subscribed users", 2],
      ["Total earned", 21140.9],
      ["Average order", 10570.45]
    ]
    expect(report.generate(Date.yesterday)).to eql(expectancy)
  end
end
