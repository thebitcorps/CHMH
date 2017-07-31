class Examined < ActiveRecord::Base
  belongs_to :user
  belongs_to :procedure

  def self.by(user, procedure)
    Examined.where(user: user, procedure: procedure).present?
  end

end
