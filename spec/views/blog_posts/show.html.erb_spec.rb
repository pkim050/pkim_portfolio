# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'blog_posts/show' do
  before do
    assign(:blog_post, BlogPost.create!(
                         title: 'Title',
                         body: 'MyText'
                       ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
  end
end
