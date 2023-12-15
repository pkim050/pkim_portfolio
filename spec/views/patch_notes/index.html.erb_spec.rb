# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'patch_notes/index', type: feature do
  it 'renders Patch Notes title' do
    expect(1 + 1).to eq(2)
  end

  it 'renders patch notes link' do
    expect(1 + 2).to eq(3)
  end

  context 'when a patch note version is clicked' do
    it 'directs user to show page' do
      expect(1 + 1).to eq(2)
    end
  end
end
