class User < ActiveRecord::Base
    before_save { self.email = self.email.downcase }
    validates :name, presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
                      format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }
    validates :area, presence: true
    has_secure_password

    has_many :microposts

    has_many :following_relationships, class_name:  "Relationship",
                                       foreign_key: "follower_id",
                                       dependent:   :destroy
    has_many :following_users, through: :following_relationships, source: :followed

    has_many :follower_relationships, class_name:  "Relationship",
                                      foreign_key: "followed_id",
                                      dependent:   :destroy
    has_many :follower_users, through: :follower_relationships, source: :follower

    has_many :favorite_posts, class_name: "Favorite",
                              foreign_key: "user_id",
                              dependent: :destroy
    has_many :favorite_microposts, through: :favorite_posts, source: :post

    def follow(other_user)
        following_relationships.find_or_create_by(followed_id: other_user.id)
    end

    def unfollow(other_user)
        following_relationship = following_relationships.find_by(followed_id: other_user.id)
        following_relationship.destroy if following_relationship
    end

    def following?(other_user)
        following_users.include?(other_user)
    end

    def feed_items
        Micropost.where(user_id: following_user_ids + [self.id])
    end

    def favorite(post)
        favorite_posts.find_or_create_by(post_id: post.id)
    end

    def unfavorite(post)
        favorite_post = favorite_posts.find_by(post_id: post.id)
        favorite_post.destroy if favorite_post
    end

    def favorite?(post)
        favorite_microposts.include(post)
    end
end
