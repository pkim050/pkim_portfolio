# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PagesController do
  describe 'routes' do
    it { is_expected.to route(:get, '/').to(action: :home) }
    it { is_expected.to route(:get, '/about').to(action: :about) }
    it { is_expected.to route(:get, '/projects').to(action: :projects) }
    it { is_expected.to route(:get, '/upload_resume').to(action: :upload_resume_page) }
    it { is_expected.to route(:post, '/upload_resume').to(action: :upload_resume) }
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

  describe 'GET #about' do
    before do
      get :about
    end

    it 'renders About Me page' do
      expect(response).to render_template(:about)
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

  describe 'GET #upload_resume' do
    before do
      get :upload_resume_page
    end

    it 'renders Upload Resume page' do
      expect(response).to render_template(:upload_resume_page)
    end

    it 'returns 200 status code' do
      expect(response).to have_http_status(:ok)
    end
  end

  # describe 'POST #upload_resume' do
  #   before do
  #     post :upload_resume
  #   end

  #   it 'returns 302 status code' do
  #     expect(response).to have_http_status(:found)
  #   end
  # end
end
