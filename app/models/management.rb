class Management < ActiveRecord::Base
  belongs_to :area
  belongs_to :manager, class_name: 'User'
end
