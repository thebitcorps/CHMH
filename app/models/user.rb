class User < ActiveRecord::Base
	validates :name, :lastname, :email, presence: true
	devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
	belongs_to :season
	belongs_to :area
	has_many :procedures, dependent: :destroy
  has_many :examineds, dependent: :destroy

  royce_roles %w[ administrator head_of_area tutor intern ]
  ROLES = {'administrator' => 'Administrador', 'head_of_area' => 'Jefe de área', 'tutor' => 'Tutor', 'intern' => 'Interno'}


	def last_month_notes(since_month)
		procedures.where('created_at BETWEEN ? AND ? ', since_month.month.ago.beginning_of_month, since_month.month.ago.end_of_month)
	end

  # scope :tutors_from_area, ->(area_id) {where(role: :tutor, area: area_id).order('name')}
  # scope :interns_from_area, ->(area_id) {where role: '3',area_id: area_id}
  # scope :active_interns_from_area, ->(area_id) {interns.where(season: Season.last, area: area_id).order('name')}
  scope :active_interns, -> {interns.where(season: Season.last).order('name')}
  # scope :inactive_interns_from_area, ->(area_id) {interns_from_area(area_id).where.not(season_id: Season.last.id).order('name')}
  # scope :inactive_interns, -> {interns.where.not(season: Season.last).order('name')}


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

  def fullname
    [name, lastname].join(" ")
  end

  def is_active?
    season == Season.last
  end


  def examined_notes_of(owner_id)
    Examined.where(user: id, owner: owner_id)
  end

  def last_login
    last_sign_in_at
  end

  def login_count
    sign_in_count || 'No ha ingresado'
  end

  def role_name
    roles.first.try(:name)
  end

  def self.with_monthly_record(params_month)
    month = params_month.to_i
    start_date = month.month.ago.beginning_of_month
    end_date = month.month.ago.end_of_month
    record_set = Procedure.where('created_at BETWEEN ? AND ?', start_date, end_date).group('user_id').count
    uid, record = record_set.sort_by { |_,v| v}.last
    [user = find(uid), record]
  end

end
