class Area < ActiveRecord::Base
	validates :description, :name, :user, presence: true
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
		residents.each  do |resident|
			resident.procedures.where('created_at BETWEEN ? AND ? ', since_month.month.ago.beginning_of_month , since_month.month.ago.end_of_month).each do |procedure|
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
		since_month = 1 if since_month.nil?
		procedures_count = 0
		residents.each do |resident|
			procedures_count += resident.procedures.where('created_at BETWEEN ? AND ? ', since_month.month.ago.beginning_of_month , since_month.month.ago.end_of_month).count
		end
		procedures_count
	end

	def best_resident
		procs = procedures.group('user_id').count
		user = User.find(procs.sort_by { |_,v| v}.last[0])
	end
end
