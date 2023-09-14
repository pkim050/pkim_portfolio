# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  context 'when user is created' do
    let(:user_test) { described_class.create(email: 'test@gmail.com') }

    it 'is valid' do
      expect(user_test.email).to eq('test@gmail.com')
    end
  end
end
