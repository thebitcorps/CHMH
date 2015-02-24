class Procedure < ActiveRecord::Base
  belongs_to :user
  belongs_to :surgery
  has_many :task_procedures
  validates :folio,:donedate  ,presence: true
  validates :minutes, numericality: {greater_than: 0}
  def last_month_notes
    Procedure.where('created_at BETWEEN ? AND ? ',1.month.ago.beginning_of_month , 1.month.ago.end_of_month)
  end
end
