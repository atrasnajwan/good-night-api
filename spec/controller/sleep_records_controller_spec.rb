require 'rails_helper'

RSpec.describe SleepRecordsController, type: :controller do
  let(:user) { create(:user) } # create from FactoryBot
  let(:valid_attributes) { { sleep_record: { user_id: user.id, clocked_in_at: Time.now } } }

  describe 'POST #clock_in' do
    # user is not allowed to clock in again before clocking out
    context 'when the user already has an active sleep record' do
      before do
        # create sleep record that not clocked out yet
        create(:sleep_record, user: user, clocked_in_at: Time.now, clocked_out_at: nil)
      end

      it 'returns an error' do
        post :clock_in, params: valid_attributes # simulate http call

        expect(response).to have_http_status(:unprocessable_entity) # match http status code
        expect(JSON.parse(response.body)).to eq({ # match error message
          'message' => 'Already clocked in',
          'error' => 'You must clock out before clocking in again'
        })
      end
    end

    context "when the user doesn't have an active sleep record" do
      it 'creates a new sleep record and returns a success' do
        expect {
          post :clock_in, params: valid_attributes
        }.to change(SleepRecord, :count).by(1) # check if record is added by one

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to have_key('clocked_in_at') # check if clocked_in_at key is returned on the response
      end
    end
  end
end