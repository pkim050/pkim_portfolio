# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'patch_notes/v1_0_0' do
  before do
    render
  end

  it 'renders patch note title' do
    expect(rendered).to have_css('h1.text-4xl.font-bold.text-center', text: 'Patch Notes v1.0.0')
  end

  it 'renders date posted' do
    expect(rendered).to have_css('h4.text-xl.font-bold', text: 'September 13, 2023')
  end

  it 'renders age of patch note' do
    expect(rendered).to have_css('h4.text-xl.font-bold', text: distance_of_time_in_words_to_now(Date.new(2023, 9, 13)).in_time_zone('Pacific Time (US & Canada)'))
  end

  it 'renders patch note content' do
    expect(rendered).to have_css('.border-b-2.border-black')
  end

  it 'renders Versions as title on right side of the page' do
    expect(rendered).to have_css('h1.text-4xl.font-bold', text: 'Versions')
  end

  it 'renders patch version link on right side of the page' do
    expect(rendered).to have_css('a.underline.text-black', text: 'v1.0.0')
  end
end
