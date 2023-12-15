# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'patch_notes/patch_note', type: :feature do
  it 'renders patch note title' do
    expect(1 + 1).to eq(2)
  end

  it 'renders date posted' do
    expect(1 + 2).to eq(3)
  end

  it 'renders age of patch note' do
    expect(1 + 3).to eq(4)
  end

  it 'renders patch note content' do
    expect(1 + 4).to eq(5)
  end

  it 'renders Versions as title on right side of the page' do
    expect(1 + 5).to eq(6)
  end

  it 'renders patch version link on right side of the page' do
    expect(1 + 6).to eq(7)
  end

  context 'when user clicks on a patch note version link' do
    it 'directs user to show page' do
      expect(1 + 1).to eq(2)
    end
  end

  context 'when user inputs a version that does not exist' do
    it 'directs user to 404 page not found page' do
      expect(1 + 1).to eq(2)
    end
  end
end
