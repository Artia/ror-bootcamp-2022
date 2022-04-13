class Task < ApplicationRecord
  belongs_to :project

  validates :title, presence: true, length: { maximum: 255 }
  validates :date_start, presence: true
  validates :date_end, presence: true
  validate :validate_dates

  def human_state
    byebug
    self.state ? 'Concluido' : 'Pendente'
  end 
  
  def TaskDeadLine
    self.date_end < Date.today && self.state == false ? 'Atrasado' : 'No Prazo'
  end

  private

  def validate_dates
    if self.date_start.present? && self.date_end.present? && self.date_start > self.date_end
      self.errors.add(:date_start, 'cannot be greater than the end date')
    end

  end  



end
