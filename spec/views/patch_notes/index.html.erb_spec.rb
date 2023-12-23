# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'patch_notes/index' do
  before do
    render
  end

  it 'renders Patch Notes title' do
    expect(rendered).to have_text('Patch Notes')
  end

  it 'renders patch notes link' do
    expect(rendered).to have_text('v1.0.0')
  end
end
