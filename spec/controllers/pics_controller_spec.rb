require 'rails_helper'

RSpec.describe PicsController, type: :controller do
  describe "pics#index action" do
    it "should successfully load the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "pics#new action" do

    it "should require users to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the new form" do
      user = FactoryGirl.create(:user)
      sign_in user

      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "pics#create action" do

    it "should require users to be logged in" do
      post :create, params: { pic: { message: 'Hello!' } }
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully create a new pic in the database" do
      user = FactoryGirl.create(:user)
      sign_in user

      post :create, params: { pic: { message: 'Hello!' } }
      expect(response).to redirect_to root_path

      pic = Pic.last
      expect(pic.message).to eq("Hello!")
      expect(pic.user).to eq(user)
    end

    it "should properly deal with validation errors" do
      user = FactoryGirl.create(:user)
      sign_in user

      post :create, params: { pic: { message: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Pic.count).to eq 0
    end
  end

end
