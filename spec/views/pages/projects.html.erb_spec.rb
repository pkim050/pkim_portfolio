# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'pages/projects' do
  before do
    render
  end

  it 'renders Projects title' do
    expect(rendered).to have_css('h1.text-4xl.font-bold.text-center', text: 'Projects')
  end

  it 'renders brief explanation of the project page' do
    expect(rendered).to have_css('p.m-8')
  end

  it 'renders project title as a link' do
    expect(rendered).to have_css('div a.underline', count: 6)
  end

  it 'renders project images as a link on the left side' do
    expect(rendered).to have_css('a img', count: 6)
  end

  it 'renders project explanation on the right side' do
    expect(rendered).to have_css('p.text-left.ml-4', count: 6)
  end

  it 'renders a divider between projects' do
    expect(rendered).to have_css('.divide-y')
  end
end
