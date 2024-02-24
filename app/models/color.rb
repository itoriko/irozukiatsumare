class Color < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_one_attached :image

  validates :name, presence: true, uniqueness: true
end
