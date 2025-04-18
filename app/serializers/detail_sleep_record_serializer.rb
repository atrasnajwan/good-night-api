class DetailSleepRecordSerializer < ActiveModel::Serializer
    attributes :id, :clocked_in_at, :clocked_out_at, :sleep_duration
    belongs_to :user, serializer: UserSerializer

    def sleep_duration
        "#{object.sleep_duration} hours"
    end
end