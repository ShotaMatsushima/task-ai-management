FactoryBot.define do
  factory :project do
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    technical_context { { tech_stack: { backend: 'Rails' } } }
  end
end