class User < ActiveRecord::Base
	validates :name, :presence => true
	validates :lastname, :presence => true
	# validates_presence_of :password_confirmation
	devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
	belongs_to :season
	belongs_to :area
	has_many :procedures, dependent: :destroy
  has_many :examineds, dependent: :destroy

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


  def role_name
    if role == "Admin"
      'Administrador'
    elsif role == "1"
      'Jefe de área'
    elsif role == "2"
      'Tutor'
    elsif role == "3"
      'Interno'
    end
  end


  def human_genre
    if gender == "0"
      'Masculino'
    else
      'Femenino'
    end
  end

  def last_login
    if last_sign_in_at
      last_sign_in_at.strftime "%F %H:%M"
    else
      'No ha ingresado'
    end
  end

  def login_count
    if sign_in_count
      sign_in_count
    else
      "No ha ingresad"
    end
  end

end
