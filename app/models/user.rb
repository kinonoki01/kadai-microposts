class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                  format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                  uniqueness: { case_sensitive: false }
  
  has_secure_password
  has_many :microposts

  # follow, follower
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverse_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverse_of_relationship, source: :user
  
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end
  
  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end
  
  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
  
  # 投稿お気に入り機能
  has_many :favorites, foreign_key: 'user_id'
  has_many :favorite_microposts, through: :favorites, source: :micropost  #既に同名micopostsとの関係があるため別名
  
  def favorite(micropost)
    unless self.favorite_microposts.exists?(id: micropost.id)
      self.favorites.find_or_create_by(micropost_id: micropost.id)
    end
  end
  
  def unfavorite(micropost)
    favorite = self.favorites.find_by(micropost_id: micropost.id)
    favorite.destroy if favorite
  end
  
  def likes?(micropost)
    self.favorite_microposts.include?(micropost)
  end
end
