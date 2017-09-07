FactoryGirl.define do
  factory :exchange do
    association :source, factory: :account, strategy: :cache
    association :destination, factory: :account2, strategy: :cache

    value_in 10
    value_out 20
    fee 1
    date Date.current
    kind "Buy"

    factory :last_month_exchange do
      value_in 120
      value_out 240
      date 1.month.ago
    end

    trait :confirmed do
      confirmed true
    end
  end
end