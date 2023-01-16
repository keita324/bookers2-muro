class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  ## has_many :active_relationships(relationshipsがフォローする側なのか、される側なのか名付ける)
  ## class_name:  "Relationship" (Relationshipのモデルを使ってると宣言)
  ## foreign_key: "follower_id"(followerd_idを外部キーとして引っ張ってきてる)
  has_many :active_relationships, class_name:  "Relationship",foreign_key: "following_id",dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "follower_id",dependent: :destroy

  ## has_many :following (この名前はなんでもいい、なのでsついてない)
  ## through: :active_relationships,(上で書いたやつ使う)
  ## source: :followed (自分がフォローしてる人を探す時、それは他のユーザーのフォロワーから自分を探して見つけ出しているため、followedになる)
  has_many :followings, through: :active_relationships, source: :follower
  has_many :followers, through: :passive_relationships, source: :following


  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }

  def follow(user_id)
    active_relationships.create(follower_id: user_id)
  end

  def unfollow(user_id)
    active_relationships.find_by(follower_id: user_id).destroy
  end

  def following?(user)
    followings.include?(user)
  end



  def get_profile_image(weight, height)
    unless self.profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    self.profile_image.variant(resize_to_fill: [weight,height]).processed
  end
end
