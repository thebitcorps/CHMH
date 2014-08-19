# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task_procedure do
    procedure nil
    task_belongs_to "MyString"
  end
end
