# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :procedure do
    donedate "2014-06-15"
    starttime "2014-06-15 14:04:15"
    endtime "2014-06-15 14:04:15"
    notes "MyText"
    user nil
    surgery nil
    task ""
  end
end
