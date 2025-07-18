class StudyRecord < ApplicationRecord
  belongs_to :user
  has_many :learning_studies, dependent: :destroy
  has_many :learning_items, through: :learning_studies
  has_many :comments, dependent: :destroy

  def store_contents_names
    self.contents_names = contents.map(&:name).join("\n")
  end

  validates :date, presence: true

  private

  def set_default_date  # 日付が空白だったら自動で今日にする(保険)
    self.date ||= Date.current
  end
end
