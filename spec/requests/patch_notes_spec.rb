# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PatchNotes' do
  describe 'GET /index' do
    it 'returns http success' do
      get '/patch_notes/index'
      expect(response).to have_http_status(:success)
    end
  end
end
