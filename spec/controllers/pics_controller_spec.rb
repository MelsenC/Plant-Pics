require 'rails_helper'

RSpec.describe PicsController, type: :controller do
  describe "pics#index action" do
    it "should successfully load the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "pics#new action" do
    it "should successfully show the new form" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "pics#create action" do
    it "should successfully create a new pic in the database" do
      post :create, params: { pic: { message: 'Hello!' } }
      expect(response).to redirect_to root_path

      pic = Pic.last
      expect(pic.message).to eq("Hello!")
    end
  end

end
