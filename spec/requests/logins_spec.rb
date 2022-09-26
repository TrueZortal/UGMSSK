require 'rails_helper'

RSpec.describe "Logins", type: :request do
  describe "POST /login" do
    context 'when logging in with valid parameters' do
      subject { post('/login', params:{name: "test", uuid: SecureRandom.uuid}) }
      it { is_expected.to match(302) }
      it { is_expected.to redirect_to(root_path) }
    end

    context 'when trying to log in without valid parameters' do
      subject { post('/login', params:{ uuid: SecureRandom.uuid }) }
      it { is_expected.to match(302) }
      it { is_expected.to redirect_to(login_path) }
    end
  end

  describe "GET /login" do
    pending "test if users that have a valid session are logged in successfully when coming in"
  end
end
