# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'about_me/index' do
  before do
    render
  end

  it 'renders About Me title' do
    expect(rendered).to have_css('h1.text-4xl.font-bold.text-center.mt-8', text: 'Career Timeline')
  end

  it 'renders left side of timeline' do
    expect(rendered).to have_css('div.grid.col-start-1.col-end-6.justify-items-end.mb-40', count: 7)
  end

  it 'renders vertical timeline' do
    expect(rendered).to have_css('div.border-s.border-black', count: 7)
  end

  it 'renders circles to be aligned vertical timeline' do
    expect(rendered).to have_css('div.absolute.w-3.h-3.rounded-full.border.border-black', count: 7)
  end

  it 'renders right side of timeline' do
    expect(rendered).to have_css('div.grid.col-start-7.col-end-13.mb-40', count: 7)
  end
end
