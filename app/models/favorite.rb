class Favorite < ActiveRecord::Base
  belongs_to :user, class_name: "User"
  belongs_to :post, class_name: "Micropost"
end
