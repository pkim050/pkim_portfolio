# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe PatchNotesController do
  describe 'routes' do
    it { is_expected.to route(:get, '/patch_notes').to(action: :index) }
    it { is_expected.to route(:get, 'patch_notes/:name').to(action: :patch_note, name: ':name') }
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

  describe 'GET #patch_note' do
    context 'when page does not exist' do
      it 'renders 404 routing error' do
        expect { get 'patch_note', params: { name: 'v1.0.10' } }.to raise_error(
          ActionController::RoutingError, 'Page Not Found'
        )
      end
    end

    context 'when page does exist' do
      before do
        params = { name: 'v1.0.0' }
        get 'patch_note', params:
      end

      it 'renders the correct patch page' do
        expect(response).to render_template('v1_0_0')
      end

      it 'returns 200 status code' do
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
