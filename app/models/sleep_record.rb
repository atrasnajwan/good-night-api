class SleepRecord < ActiveRecord::Base
    belongs_to :user

    validates :clocked_in_at, presence: true # validate on rails level
end