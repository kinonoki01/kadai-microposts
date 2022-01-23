class Micropost < ApplicationRecord
  validates :content, presence: true, length: { maximum: 255 }
  
  belongs_to :user
  
  # 投稿お気に入り機能
  has_many :favorites, dependent: :destroy
end
