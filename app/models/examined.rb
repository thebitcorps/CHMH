class Examined < ActiveRecord::Base

  belongs_to :user
  belongs_to :procedure

  def self.was_examined_by(user_id,procedure_id)
    Examined.where(user_id: user_id,procedure_id: procedure_id).empty? ? true : false
  end

  def by?

  end
end
