# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AboutMeController do
  describe 'routes' do
    it { is_expected.to route(:get, '/about_me').to(action: :index) }
  end

  describe 'GET #index' do
    before do
      get :index
    end

    it 'renders index page' do
      expect(response).to render_template(:index)
    end

    it 'returns 200 status code' do
      expect(response).to have_http_status(:ok)
    end
  end
end
