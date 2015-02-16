class User < ActiveRecord::Base
	validates :name, :presence => true
	validates :lastname, :presence => true
	# validates_presence_of :password_confirmation
	devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
	belongs_to :season
	belongs_to :area
	has_many :procedures

	def self.residents
		User.where(role: "3")
	end

end
