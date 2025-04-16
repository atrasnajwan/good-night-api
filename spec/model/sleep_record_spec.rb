RSpec.describe SleepRecord, type: :model do
    let(:user) { create(:user) } 
  
    describe 'callbacks' do
      it 'calculates sleep_duration correctly before save' do
        clocked_in_at = Time.parse("2025-04-16 22:00:00")
        clocked_out_at = Time.parse("2025-04-17 06:30:00")
  
        sleep_record = SleepRecord.new(user: user, clocked_in_at: clocked_in_at, clocked_out_at: clocked_out_at)
  
        # Save the record (will trigger the callback)
        sleep_record.save
  
        # Calculate the expected duration in hours
        expected_duration = ((clocked_out_at - clocked_in_at) / 1.hours).round(2)
        
        # check the value if match
        expect(sleep_record.reload.sleep_duration).to eq(expected_duration) # .reload to make sure it's updated
      end
    end
  end
  