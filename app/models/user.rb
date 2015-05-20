class User < ActiveRecord::Base
	validates :name, :presence => true
	validates :lastname, :presence => true
	# validates_presence_of :password_confirmation
	devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
	belongs_to :season
	belongs_to :area
	has_many :procedures
  has_many :examineds

	def self.residents
		User.where(role: "3")
	end

	def last_month_notes(since_month)
		self.procedures.where('created_at BETWEEN ? AND ? ',since_month.month.ago.beginning_of_month , since_month.month.ago.end_of_month)
	end


  def doctor_gender
    self.gender == '0' ? "Dr." : "Dra."
  end

  def fullname
    self.name + ' ' + self.lastname
  end


  def examined_notes_of(owner_id)

    Examined.where(user_id: self.id,owner_id: owner_id)
  end



end
