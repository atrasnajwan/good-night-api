class Following < ActiveRecord::Base
    belongs_to :follower, class_name: 'User'
    belongs_to :followed, class_name: 'User'

    validates :follower_id, :followed_id, presence: true # required attribute
    validates :follower_id, uniqueness: { scope: :followed_id } # must unique
end