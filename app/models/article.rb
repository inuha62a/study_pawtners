class Article < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  enum :category, {error_log: 0, ai_prompt: 1}
  enum :status, {draft: 0, published: 1}

  validates :title, presence: true
  has_one_attached :image
end
