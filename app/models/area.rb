class Area < ActiveRecord::Base
	validates :name, presence: true
	validates :description, presence: true
	belongs_to :user
	has_many :users,  dependent: :nullify
	has_many :surgeries, dependent: :destroy

	def residents
		User.interns.where(area: id)
		# User.where(role: '3',area_id: self.id)
	end

	def tutors
		User.tutors.where(area: id)
		# User.where(role: '2',area_id: self.id)
	end

	def number_of_tutors
		tutors.count
	end

	def number_of_residents
		residents.count
	end

	def all_resident_notes_hours
		count = 0
		residents.each do |resident|
			count += resident.minutes if resident.minutes
		end
		count
	end


	def montly_procedures_hash
		procedure_hash = Hash.new
		procedure_hash.default_proc = proc{ |hash, key| hash[key] = 0 }
		procedures.each do |procedure|
			procedure_hash[procedure.donedate.at_beginning_of_month] += 1
		end
		procedure_hash
	end

	def last_resident_notes_hours(since_month)
		count = 0
		area_residents.each  do |resident|
			resident.procedures.where('created_at BETWEEN ? AND ? ',since_month.month.ago.beginning_of_month , since_month.month.ago.end_of_month).each do |procedure|
				count += procedure.minutes
			end
		end
		count
	end

	def procedures
		procedures = []
		area_residents.each  do |resident|
			resident.procedures.each do |procedure|
				procedures << procedure
			end
		end
		procedures
	end

	def number_of_notes
		# count = 0
		residents.each.map { |resident, sum| sum += resident.procedures.count } 
		# do |resident|
		# 	count += resident.procedures.count
		# end
		# count
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
	  area_residents
		procedures_count = 0
		since_month = 1 	if since_month == nil
		area_residents.each do |user|
			procedures_count += user.procedures.where('created_at BETWEEN ? AND ? ',since_month.month.ago.beginning_of_month , since_month.month.ago.end_of_month).count
		end
		procedures_count
	end


	def resident_more_notes_monthly(since_monthly)
		Area.best_resident_monthly(area_residents,since_monthly)
	end

	def self.resident_more_notes_monthly(since_month)
		users = User.where(role: '3')
		user_with_more_notes = users.first
		users.each do |user|
			if user.procedures.where('created_at BETWEEN ? AND ? ',since_month.month.ago.beginning_of_month , since_month.month.ago.end_of_month).count > user_with_more_notes.procedures.where('created_at BETWEEN ? AND ? ',since_month.month.ago.beginning_of_month , since_month.month.ago.end_of_month).count
				user_with_more_notes = user
			end
		end
		user_with_more_notes
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
