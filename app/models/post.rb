class Post < ApplicationRecord
  belongs_to :user
  belongs_to :color

  has_one_attached :image

  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  validates :title,presence:true
  validates :content,presence:true,length:{maximum:200}

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  def favorited_by?(user)
    favorites.exists?(user_id: user)
  end

  def self.search_for(content, method)
    if method == 'perfect'
      Post.where(title: content)
    elsif method == 'forward'
      Post.where('name LIKE ?', content + '%')
    elsif method == 'backward'
      Post.where('name LIKE ?', '%' + content)
    else
      Post.where('name LIKE ?', '%' + content + '%')
    end
  end
end
