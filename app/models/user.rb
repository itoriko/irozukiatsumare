class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :user_name, length: { in: 2..20, allow_blank: true }, presence: true, uniqueness: true
  validates :user_name_kana, presence: true
  validates :introduction, length: { maximum: 50 }
  # validates :birth_date
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

end
