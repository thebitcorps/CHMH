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


	def all_notes_last_month(since_month)
		users  = area_residents
		procedures_count = 0
		since_month = 1 	if since_month == nil
		users.each do |user|
			procedures_count += user.procedures.where('created_at BETWEEN ? AND ? ',since_month.month.ago.beginning_of_month , since_month.month.ago.end_of_month).count
		end
		procedures_count
	end


	def resident_with_more_notes_monthly(since_monthly)
		Area.best_resident_monthly(area_residents,since_monthly)
	end


	def self.resident_with_more_notes
		best_resident(User.residents)
	end

	def resident_with_more_notes
		Area.best_resident(area_residents)
	end

	def self.best_resident_monthly(users,since_month)
		user_with_more_notes = users.first
		users.each do |user|
			if user.procedures.where('created_at BETWEEN ? AND ? ',since_month.month.ago.beginning_of_month , since_month.month.ago.end_of_month).count > user_with_more_notes.procedures.where('created_at BETWEEN ? AND ? ',since_month.month.ago.beginning_of_month , since_month.month.ago.end_of_month).count
				user_with_more_notes = user
			end
		end
		user_with_more_notes
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
