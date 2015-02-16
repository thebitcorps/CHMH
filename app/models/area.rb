class Area < ActiveRecord::Base
	validates :name, :presence => true
	validates :description, :presence => true
	belongs_to :user
	has_many :users,  dependent: :nullify
	has_many :surgeries

	def area_residents
		User.where(role: '3',area_id: self.id)
	end

	def find_area_tutors
		User.where(role: '2',area_id: self.id)
	end

	def number_of_tutors
		find_area_tutors.count
	end

	def number_of_residents
		area_residents.count
	end

	def all_resident_notes_hours
		residents = area_residents
		count = 0
		residents.each  do |resident|
			count += resident.minutes if resident.minutes
		end
		count
	end

	def number_of_notes
		residents = area_residents
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


	def all_notes_last_month
		users  = area_residents
		procedures_count = 0
		users.each do |user|
			procedures_count += user.procedures.where('created_at BETWEEN ? AND ? ',1.month.ago.beginning_of_month , 1.month.ago.end_of_month).count
		end
		procedures_count
	end


	def self.resident_with_more_notes
		users = User.residents
		best_resident(users)
	end

	def resident_with_more_notes
		Area.best_resident(area_residents)
	end

	def self.best_resident(users)
		user_with_more_notes = users.first
		users.each do |user|
			if user.procedures.count > user_with_more_notes.procedures.count
				user_with_more_notes = user
			end
		end
		user_with_more_notes
	end


end
