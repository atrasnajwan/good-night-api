class SleepRecord < ActiveRecord::Base
    belongs_to :user

    validates :clocked_in_at, presence: true # validate on rails level

    # callback before saving to db if clocked_out_at column changed
    before_save :calculate_sleep_duration, if: :clocked_out_at_changed?

    private

    def calculate_sleep_duration
        return if clocked_in_at.nil? || clocked_out_at.nil?
        
        # set sleep_records.sleep_duration value
        self.sleep_duration = ((clocked_out_at - clocked_in_at) / 1.hour).round(2) # in hours
    end
end