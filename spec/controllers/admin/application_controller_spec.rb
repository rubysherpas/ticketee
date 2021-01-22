require "rails_helper"

RSpec.describe Admin::ApplicationController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in(user)
  end

  context "non-admin users" do
    it "are not able to access the index action" do
      get :index

      expect(response).to redirect_to "/"
      expect(flash[:alert]).to eq "You must be an admin to do that."
    end
  end
end
