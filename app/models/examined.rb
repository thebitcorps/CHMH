class Examined < ActiveRecord::Base

  belongs_to :user
  belongs_to :procedure

  def self.was_examined_by(user, procedure)
    where(user: user, procedure: procedure).empty? ? true : false
  end

end
