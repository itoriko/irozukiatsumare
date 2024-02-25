class Color < ApplicationRecord
  has_many :posts, dependent: :destroy

  has_one_attached :color_image

  validates :name, presence: true, uniqueness: true

  def get_color_image
    (color_image.attached?) ? color_image : 'no_color_image.png'
  end
end
