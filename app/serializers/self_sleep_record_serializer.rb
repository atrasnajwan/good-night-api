class SelfSleepRecordSerializer < ActiveModel::Serializer
    attributes :id, :clocked_in_at, :clocked_out_at, :sleep_duration

    def sleep_duration
        return "#{object.sleep_duration} hours" if object.sleep_duration >= 1.00

        "#{object.sleep_duration * 60} minutes"
    end
end