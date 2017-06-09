class User < ActiveRecord::Base
	validates :name, presence: true
	validates :lastname, presence: true
	devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
	belongs_to :season
	belongs_to :area
	has_many :procedures, dependent: :destroy
  has_many :examineds, dependent: :destroy

  royce_roles %w[ administrator head_of_area tutor intern ]
  ROLES = {administrator: 'Administrador', head_of_area: 'Jefe de área', tutor: 'Tutor', intern: 'Interno'}


	def last_month_notes(since_month)
		procedures.where('created_at BETWEEN ? AND ? ', since_month.month.ago.beginning_of_month, since_month.month.ago.end_of_month)
	end

  scope :tutors_from_area, ->(area_id) {where(role: :tutor, area: area_id).order('name')}
  scope :interns_from_area, ->(area_id) {where role: '3',area_id: area_id}
  scope :active_interns_from_area, ->(area_id) {interns.where(season: Season.last, area: area_id).order('name')}
  scope :active_interns, -> {interns.where(season: Season.last).order('name')}
  scope :inactive_interns_from_area, ->(area_id) {interns_from_area(area_id).where.not(season_id: Season.last.id).order('name')}
  scope :inactive_interns, -> {interns.where.not(season_id: Season.last.id).order('name')}


  def month_procedure_count
    procedure_hash = Hash.new
    procedure_hash.default_proc = proc{ |hash, key| hash[key] = 0 }
    procedures.each do |procedure|
      procedure_hash[procedure.donedate.at_beginning_of_month] += 1
    end
    procedure_hash
  end

  def day_procedures_count
    procedures.group(:donedate).count
  end

  def doctor_gender
    self.gender == '0' ? "Dr." : "Dra."
  end

  def fullname
    [name, lastname].join
    # self.name + ' ' + self.lastname
  end

  def is_active?
    self.season == Season.last
  end


  def examined_notes_of(owner_id)
    Examined.where(user: id, owner: owner_id)
  end


  # def role_name
  #   if role == "Admin"
  #     'Administrador'
  #   elsif role == "1"
  #     'Jefe de área'
  #   elsif role == "2"
  #     'Tutor'
  #   elsif role == "3"
  #     'Interno'
  #   end
  # end


  def human_genre
    if gender == "0"
      'Masculino'
    else
      'Femenino'
    end
  end

  def last_login
    if last_sign_in_at
      # last_sign_in_at.strftime "%F %H:%M"
      I18n.l last_sign_in_at
    else
      'No ha ingresado'
    end
  end

  def login_count
    sign_in_count || 'No ha ingresado'
    # if sign_in_count
    #   sign_in_count
    # else
    #   "No ha ingresado"
    # end
  end

  ### Rob
  def role_name
    roles.first.try(:name)
  end

end
