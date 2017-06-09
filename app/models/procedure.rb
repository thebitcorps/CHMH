class Procedure < ActiveRecord::Base
  # :folio,:donedate,:minutes,:notes,:user_id,:surgery_id  
  belongs_to :user
  belongs_to :surgery
  has_many :task_procedures
  has_many :examineds, dependent: :destroy
  validates :folio,:donedate  ,presence: true
  validates :minutes, numericality: {greater_than: 0}
  validate :donedate_less_than_today
  validate :donedate_less_this_month


  scope :from_user,  -> (user_id){
      where(user_id: user_id).order('surgery_id DESC')
  }

  def last_month_notes
    Procedure.where('created_at BETWEEN ? AND ? ',1.month.ago.beginning_of_month , 1.month.ago.end_of_month)
  end

  def donedate_less_than_today
    errors.add(:donedate, 'La fecha no puede ser despues de hoy') if donedate > Date.today
  end

  def donedate_less_this_month
    errors.add(:donedate, 'Solo se pueden registrar fechas dentro de los pasados 15 dias. ') if (Date.today - donedate).to_i > 15
  end

  def create_procedure_tasks(task_ids)
    return unless task_ids
    for task_id in task_ids
      task_procedures << TaskProcedure.new(task_id: task_id.to_i)
    end
  end

  def examineds_color
    examineds.count == 0 ?  "label-info" : "label-success"
  end


  # def self.examined_procedures(user_id)
  #   Procedure.where(user: user_id).order('surgery_id DESC').to_a.each do |procedure|
  #     if procedure.examamineds.exist?(user_id: current_user,procedure: procedure.id)
  #
  #     end
  #
  # end

end
