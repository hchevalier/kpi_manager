class Order < ActiveRecord::Base
  belongs_to :car
  belongs_to :user
  belongs_to :promotion
end
