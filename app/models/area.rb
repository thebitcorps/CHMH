class Area < ActiveRecord::Base
	validates :name, :presence => true
	validates :description, :presence => true
	belongs_to :user
	has_many :users,  dependent: :nullify
	has_many :surgeries

	def find_area_residents
		User.where(role: '3',area_id: self.id)
	end

	def find_area_tutors
		User.where(role: '2',area_id: self.id)
	end

	def number_of_tutors
		find_area_tutors.count
	end

	def number_of_residents
		find_area_residents.count
	end

	def all_resident_notes_hours
		residents = find_area_residents
		count = 0
		residents.each  do |resident|
			count += resident.minutes if resident.minutes
		end
		count
	end

	def number_of_notes
		residents = find_area_residents
		count = 0
		residents.each  do |resident|
			count += resident.procedures.count
		end
		count
	end

	def logins_count
		users = User.where(area_id: self.id)
		count = 0
		users.each do |user|
			count += user.sign_in_count
		end
		count
	end

end
