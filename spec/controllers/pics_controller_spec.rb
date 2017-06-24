require 'rails_helper'

RSpec.describe PicsController, type: :controller do

  describe "pics#destroy action" do 
    it "shouldn't let a user who didn't create the pic to destroy it" do
      pic = FactoryGirl.create(:pic)
      user = FactoryGirl.create(:user)
      sign_in user
      delete :destroy, params: { id: pic.id }
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthenticated users destroy a pic" do
      pic = FactoryGirl.create(:pic)
      delete :destroy, params: { id: pic.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow a user to destroy pics" do
      pic = FactoryGirl.create(:pic)
      sign_in pic.user
      delete :destroy, params: { id: pic.id }
      expect(response).to redirect_to root_path
      pic = Pic.find_by_id(pic.id)
      expect(pic).to eq nil

    end

    it "should return a 404 message if we cannot find a pic with the id that is specified" do
      user = FactoryGirl.create(:user)
      sign_in user
      delete :destroy, params: { id: 'SPACEDUCK'}
      expect(response).to have_http_status(:not_found)

    end

  end

  describe "pics#update action" do
    it "shouldn't let a user who didn't create the pic update the pic" do
      pic = FactoryGirl.create(:pic)
      user = FactoryGirl.create(:user)
      sign_in user
      patch :update, params: { id: pic.id, pic: { message: 'Wahoo!' } }
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthenticated users create a pic" do
      pic = FactoryGirl.create(:pic)
      patch :update, params: { id: pic.id, pic: { message: 'Hello!' } }
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow users to successfully update pics" do
      pic = FactoryGirl.create(:pic, message: "Initial Value")
      sign_in pic.user
      patch :update, params: { id: pic.id, pic: { message: 'Changed' } }
      expect(response).to redirect_to root_path
      pic.reload
      expect(pic.message).to eq "Changed"

    end

    it "should have http 404 error if the pic cannot be found" do
      user = FactoryGirl.create(:user)
      sign_in user
      patch :update, params: { id: "YOLO", pic: { message: 'Changed' } }
      expect(response).to have_http_status(:not_found)
    end

    it "should render the edit form with an http status of unprocessable_entity" do
      pic = FactoryGirl.create(:pic, message: "Initial Value")
      sign_in pic.user
      patch :update, params: { id: pic.id, pic: { message: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      pic.reload
      expect(pic.message).to eq "Initial Value"
    end

  end

  describe "pics#edit action" do
    it "shouldn't let a user who didn't create the pic edit the pic" do
      pic = FactoryGirl.create(:pic)
      user = FactoryGirl.create(:user)
      sign_in user
      get :edit, params: { id: pic.id }
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthenticated users edit a pic" do
      pic = FactoryGirl.create(:pic)
      get :edit, params: { id: pic.id }
      expect(response).to redirect_to new_user_session_path

    end

    it "should successfully show the edit form if the pic is found" do
      pic = FactoryGirl.create(:pic)
      sign_in pic.user
      get :edit, params: { id: pic.id }
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if the pic is not found" do
      user = FactoryGirl.create(:user)
      sign_in user
      get :edit, params: { id: 'SOMETHING'}
      expect(response).to have_http_status(:not_found)
    end

  end

  describe "pics#show action" do
    it "should successfully show the page if the pic is found" do
      pic = FactoryGirl.create(:pic)
      get :show, params: { id: pic.id }
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if the pic is not found" do
      get :show, params: { id: 'TACOCAT' }
      expect(response).to have_http_status(:not_found)
    end

  end

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

      post :create, params: {
        pic: {
          message: 'Hello!',
          picture: fixture_file_upload("/picture.png", 'image/png')
        } 
      }
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
