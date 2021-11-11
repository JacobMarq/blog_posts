require 'rails_helper'

RSpec.describe V1::PingController do
  describe 'GET #ping_api' do
    context 'when server is active' do
      before do
        get :ping_api
      end

      it 'returns success message true' do
        expect(JSON.parse(response.body)['success']).to eql(true)
      end
      
      it 'returns active status code' do
        expect(response.status).to eql(200)
      end
    end
  end
end
