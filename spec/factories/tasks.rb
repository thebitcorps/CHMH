# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task do
    name "MyString"
    description "MyString"
    surgery nil
  end
end
