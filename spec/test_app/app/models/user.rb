class User < ActiveRecord::Base
  has_many :orders
  has_many :cars, through: :orders

  scope :active, -> { where(enabled: true) }

  def buy_car(car, promotion = nil)
    order = orders.new(
      car: car,
      promotion: promotion
    )
    order.paid_price = promotion ? promotion.calculate_from(car.price) : car.price
    order.save
  end
end
