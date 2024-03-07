class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  # フォローしている関連付け
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy

  # フォローされている関連付け
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  # フォローしているユーザーを取得
  has_many :followings, through: :active_relationships, source: :followed

  # フォロワーを取得
  has_many :followers, through: :passive_relationships, source: :follower

  has_one_attached :profile_image

  validates :user_name, length: { in: 2..20, allow_blank: true }, presence: true, uniqueness: true
  validates :user_name_kana, presence: true
  validates :introduction, length: { maximum: 50 }
  validates :occupation, presence: true
  validates :email, presence: true,uniqueness: true
  validates :password, presence: true,
                                 length: { minimum: 6 },
                                 format: {
                                   with: /\A[\w\-]+\z/,
                                   message: "パスワードは半角英数字・ハイフン(-)・アンダーバー(_)が使えます"
                                 },
                                 allow_nil: true

  GUEST_USER_EMAIL = "guest@example.com"
  GUEST_USER_POSSWORD = "guest_user1"
  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = GUEST_USER_POSSWORD
      user.user_name = "ゲストユーザー"
      user.user_name_kana = "ゆーざーねーむ"
      user.occupation = "会社員"
    end
  end

  def guest_user?
    email == GUEST_USER_EMAIL
  end

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_profile.png'
  end

   # 指定したユーザーをフォローする
  def follow(user)
    active_relationships.create(followed_id: user.id)
  end

  # 指定したユーザーのフォローを解除する
  def unfollow(user)
    active_relationships.find_by(followed_id: user.id).destroy
  end

  # 指定したユーザーをフォローしているかどうかを判定
  def following?(user)
    followings.include?(user)
  end

  def self.search_for(content, method)
    if method == 'perfect'
      User.where(user_name: content)
    elsif method == 'forward'
      User.where('user_name LIKE ?', content + '%')
    elsif method == 'backward'
      User.where('user_name LIKE ?', '%' + content)
    else
      User.where('user_name LIKE ?', '%' + content + '%')
    end
  end
end
