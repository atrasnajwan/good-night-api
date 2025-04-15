class User < ActiveRecord::Base
    has_many :follower_relationships, foreign_key: :followed_id, class_name: 'Following' # to relation table/followings table
    has_many :followers, through: :follower_relationships, source: :follower # get users from the relations
  
    has_many :following_relationships, foreign_key: :follower_id, class_name: 'Following'
    has_many :followings, through: :following_relationships, source: :followed
end