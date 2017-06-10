class Area < ActiveRecord::Base
	validates :name, presence: true
	validates :description, presence: true
	belongs_to :user
	has_many :users,  dependent: :nullify
	has_many :procedures, through: :users
	has_many :surgeries, dependent: :destroy

	def residents
		User.interns.where(area: id)
	end

	def tutors
		User.tutors.where(area: id)
	end

	def number_of_tutors
		tutors.count
	end

	def number_of_residents
		residents.count
	end

	def all_resident_notes_hours
		count = residents.inject(0) { |sum, res| sum += res.minutes || 0 }
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

	def number_of_notes
		procedures.select { |x| x.notes.present? }.count
	end

	def logins_count
		users = User.where(area: id)
		count = users.inject(0) { |sum, usr| sum += usr.sign_in_count }
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
