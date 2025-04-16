class SelfSleepRecordSerializer < ActiveModel::Serializer
    attributes :id, :clocked_in_at, :clocked_out_at, :sleep_duration

    def sleep_duration
        return nil unless object.clocked_out_at
        
        duration = object.clocked_out_at - object.clocked_in_at
        seconds = duration / 60
        return "#{seconds.round(2)} seconds" if seconds < 60 # in seconds

        minutes = duration / 1.minutes
        return "#{minutes.round(2)} minutes" if minutes < 60 # in minutes

        hours = duration / 1.hours # in hours
        return "#{hours.round(2)} hours" 
    end
end