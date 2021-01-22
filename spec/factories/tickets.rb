FactoryBot.define do
  factory :ticket do
    name { "Example ticket" }
    description { "An example ticket, nothing more" }
    association :author, factory: :user
  end
end
