require 'rails_helper'

module MnoEnterprise
  describe ImpersonateController, type: :controller do
    render_views
    routes { MnoEnterprise::Engine.routes }

    # Stub model calls
    let(:user) { build(:user, :admin) }
    let(:user2) { build(:user) }
    before do
      api_stub_for(get: "/users/#{user.id}", response: from_api(user))
      api_stub_for(put: "/users/#{user.id}", response: from_api(user))
      api_stub_for(get: "/users/#{user2.id}", response: from_api(user2))
      api_stub_for(put: "/users/#{user2.id}", response: from_api(user2))

    end

    context "admin user" do
      before do
        sign_in user
      end

      describe "#create" do


        it do
          expect(controller.current_user.id).to eq(user.id)
          get :create, user_id: user2.id
          expect(controller.current_user.id).to eq(user2.id)
        end
      end

      describe "#destroy" do
        before do
          get :create, user_id: user2.id
        end

        it { expect(controller.current_user.id).to eq(user2.id) }

        subject { get :destroy }

        it { subject; expect(controller.current_user.id).to eq(user.id) }
      end
    end
  end

end