require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  describe "comments#create action" do

    it "should allow users to create comments on pics" do
      pic = FactoryGirl.create(:pic)

      user = FactoryGirl.create(:user)
      sign_in user

      post :create, params: { pic_id: pic.id, comment: { message: 'I love that plant!' } }

      expect(response).to redirect_to root_path
      expect(pic.comments.length).to eq 1
      expect(pic.comments.message.first).to eq "I love that plant!"

    end

    it "should require a user to be logged in to comment on a pic" do
      pic = FactoryGirl.create(:pic)

      post :create, params: { pic_id: pic.id, comment: { message: 'Awesome plant pic!' } }

      expect(response).to redirect_to new_user_session_path

    end

    it "should return http status of not found if the pic isn't found" do
      user = FactoryGirl.create(:user)
      sign_in user
      post :create, params: { pic_id: "PLANTS", comment: { message: 'Plants.' } }
      expect(response).to have_http_status(:not_found)

    end

  end

end
