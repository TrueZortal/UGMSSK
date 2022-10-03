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
    context 'when pathing to the site with an existing session' do
      subject {
        post('/login', params:{name: "test", uuid: SecureRandom.uuid})
        get('/login')
      }
      it { is_expected.to match(302) }
      it { is_expected.to redirect_to(root_path) }
    end

    context 'when pathing to the site without an existing session' do
      subject {
        get('/login')
      }
      it { is_expected.to match(200) }
    end
  end
end
