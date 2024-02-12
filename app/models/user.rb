class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :user_name, length: { in: 2..20, allow_blank: true }, presence: true, uniqueness: true
  validates :user_name_kana, presence: true
  validates :introduction, length: { maximum: 50 }
  validates :birth_date, presence: true
  validates :occupation, presence: true
  validates :email, presence: true,uniqueness: true
  validates :encrypted_password, presence: true,
                                 length: { minimum: 8 },
                                 format: {
                                   with: /\A[a-zA-Z]+\z/,
                                   message: "パスワードは半角英数字・ハイフン(-)・アンダーバー(_)が使えます"
                                 },
                                 allow_nil: true
  has_secure_password

end
