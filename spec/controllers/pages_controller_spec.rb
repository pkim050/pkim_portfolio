# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PagesController do
  describe 'routes' do
    it { is_expected.to route(:get, '/').to(action: :home) }
    it { is_expected.to route(:get, '/about_me').to(action: :about_me) }
    it { is_expected.to route(:get, '/projects').to(action: :projects) }
  end

  describe 'GET #home' do
    before do
      get :home
    end

    it 'renders home page' do
      expect(response).to render_template(:home)
    end

    it 'returns 200 status code' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #about_me' do
    before do
      get :about_me
    end

    it 'renders About Me page' do
      expect(response).to render_template(:about_me)
    end

    it 'returns 200 status code' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #projects' do
    before do
      get :projects
    end

    it 'renders Projects page' do
      expect(response).to render_template(:projects)
    end

    it 'returns 200 status code' do
      expect(response).to have_http_status(:ok)
    end
  end
end
