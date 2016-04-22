class Micropost < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  has_many :favorited_user, class_name: "Favorite",
                            foreign_key: "post_id",
                            dependent: :destroy
end
