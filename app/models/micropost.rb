class Micropost < ApplicationRecord
  validates :content, presence: true, length: { maximum: 255 }
  
  belongs_to :user
end
