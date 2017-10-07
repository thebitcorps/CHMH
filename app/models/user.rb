class User < ActiveRecord::Base
	validates :name, presence: true
	validates :lastname, presence: true
	devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
	belongs_to :season
  belongs_to :area
  has_many :managements
  has_many :managed_areas, through: :management
	has_many :procedures, dependent: :destroy
  has_many :examineds, dependent: :destroy

  enum access_level: [:inactive, :intern, :tutor, :head_of_area, :admin]
  enum sex: [:female, :male]

	def last_month_notes(since_month)
    procedures.where('created_at BETWEEN ? AND ? ', since_month.month.ago.beginning_of_month , since_month.month.ago.end_of_month)
	end

  scope :from_area, ->(area_id) { where(area_id: area_id) }
  scope :tutors_from_area, ->(area_id) { where(access_level: '2', area_id: area_id).order('name') }
  scope :tutors, -> { tutor.all.order('name') }
  # scope :head_area, -> { where(access_level: '3').order('name') }
  scope :interns, -> { where access_level: '1' }
  scope :residents, -> { where access_level: '1' }
  scope :interns_from_area, ->(area_id) { where role: '3', area_id: area_id }
  scope :active_interns_from_area, -> (area_id) { interns.where(season: Season.last, area_id: area_id).order('name') }
  scope :active_interns, -> { interns.where(season: Season.last).order('name') }
  scope :inactive_interns_from_area, ->(area_id) { interns_from_area(area_id).where.not(season: Season.last).order('name') }
  scope :inactive_interns, -> { interns.where.not(season: Season.last).order('name') }


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

  # def admin?
  #   role == 'Admin'
  # end

  # def intern?
  #   role == '3'
  # end

  # def tutor?
  #   role == '2'
  # end

  # def head_of_area?
  #   role == '1'
  # end

  def doctor_gender
    male? ? 'Dra.' : 'Dr.'
  end

  def fullname
    [name, lastname].join(" ")
  end

  def is_active?
    season == Season.last
  end

  def examined_notes_of(owner)
    examineds.where(owner: owner)
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
      'No ha ingresado'
    end
  end
end
