require 'rails_helper'

RSpec.describe UsersController, type: :request do
    let(:user) { create(:user) } # create from FactoryBot
    let(:token) do # token for test logged user
      payload = { user_id: user.id, exp: 24.hours.from_now.to_i }
      JWT.encode(payload, JWT_SECRET_KEY)
    end
    let(:headers) do
      {
        "Authorization" => "Bearer #{token}",
        "Content-Type" => "application/json"
      }
    end
  
    describe "POST /users" do
      let(:valid_params) { { user: { name: "Test User 666" } } }
  
      it "creates a user" do
        post '/users', params: valid_params
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['name']).to eq("Test User 666")
      end
  
      it "returns error on invalid params" do
        post '/users', params: { user: { name: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  
    describe "POST /users/:id/follow" do
      let(:target_user) { create(:user) }
  
      context "when authenticated" do
        it "follows a user" do
          post "/users/#{target_user.id}/follow", headers: headers
          expect(response).to have_http_status(:created)
        end
  
        it "cannot follow self" do
          post "/users/#{user.id}/follow", headers: headers
          expect(response).to have_http_status(:unprocessable_entity)
        end
  
        it "cannot follow same user" do
          post "/users/#{target_user.id}/follow", headers: headers
          post "/users/#{target_user.id}/follow", headers: headers
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
  
      context "when unauthenticated" do
        it "returns unauthorized" do
          post "/users/#{target_user.id}/follow"
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  
    describe "DELETE /users/:id/unfollow" do
      let(:target_user) { create(:user) }
  
      before do
        post "/users/#{target_user.id}/follow", headers: headers
      end
  
      it "unfollows a user" do
        delete "/users/#{target_user.id}/unfollow", headers: headers
        expect(response).to have_http_status(:no_content)
      end
  
      it "returns error if not followed" do
        delete "/users/#{target_user.id}/unfollow", headers: headers
        delete "/users/#{target_user.id}/unfollow", headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  
end
