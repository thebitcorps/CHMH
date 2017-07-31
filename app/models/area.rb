class Area < ActiveRecord::Base
	validates :name, :description, presence: true
	has_many :managements
	has_many :managers, through: :managements, class_name: 'User'
	has_many :users,  dependent: :nullify
	has_many :surgeries, dependent: :destroy

	def residents
		users.interns
	end

	def tutors
		users.tutors
	end

	def all_resident_notes_hours
		residents.sum(:minutes)
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
		residents.each  do |resident|
			resident.procedures.where('created_at BETWEEN ? AND ? ',since_month.month.ago.beginning_of_month , since_month.month.ago.end_of_month).each do |procedure|
				count += procedure.minutes
			end
		end
		count
	end

	def procedures
		Procedure.where(user: users.interns)
	end

	def number_of_notes
		users.interns.joins(:procedures).count
	end

	def logins_count
		users.sum(:sign_in_count)
	end


	def all_notes_last_month(since_month = 1)
		Procedure.where('created_at BETWEEN ? AND ?', since_month.month.ago.beginning_of_month , since_month.month.ago.end_of_month).where(user: users.interns).count
	end


	def resident_more_notes_monthly(since_monthly)
		Area.best_resident_monthly(residents,since_monthly)
	end

	def self.resident_more_notes_monthly(since_month)
		# n = User.residents.joins(:procedures).group('users.id').count + sort
		# n.sort_by { |_key, value| value }.last
		# User.find(n[0])

		usrs = User.residents
		user_with_more_notes = usrs.first
		usrs.each do |user|
			if user.procedures.where('created_at BETWEEN ? AND ? ',since_month.month.ago.beginning_of_month , since_month.month.ago.end_of_month).count > user_with_more_notes.procedures.where('created_at BETWEEN ? AND ? ', since_month.month.ago.beginning_of_month, since_month.month.ago.end_of_month).count
				user_with_more_notes = user
			end
		end
		user_with_more_notes
	end


	def self.resident_with_more_notes
		best_resident(User.residents)
	end

	def resident_with_more_notes
		Area.best_resident(residents)
	end

	def self.best_resident_monthly(users, since_month)
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
