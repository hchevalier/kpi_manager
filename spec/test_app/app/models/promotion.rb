class Promotion < ActiveRecord::Base
  def calculate_from(base_price)
    base_price - (base_price / 100 * percentage)
  end
end
