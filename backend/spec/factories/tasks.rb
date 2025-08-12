FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    due_date { Faker::Date.forward(days: 30) }
    status { Task.statuses.keys.sample }
  end
end
