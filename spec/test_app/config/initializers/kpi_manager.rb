# Datasets
KpiManager::Dataset.add(:subscribers) do |from, to|
  User.where(created_at: (from..to))
end

KpiManager::Dataset.add(:bills) do |from, to|
  Order.where(created_at: (from..to))
end

# KPIs
KpiManager::Kpi.add(:users_count, 'Subscribed users', dataset: :subscribers) do |dataset|
  dataset.count
end

KpiManager::Kpi.add(:total_earned, 'Total earned', dataset: :bills) do |dataset|
  dataset.to_a.inject(0) { |acc, elem| acc + elem.paid_price }
end

KpiManager::Kpi.add(:average_order, 'Average order', dataset: :bills, references: [:total_earned]) do |dataset, **refs|
  dataset.count.zero? ? 0 : refs[:total_earned] / dataset.count
end
