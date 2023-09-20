# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'blog_posts/index' do
  before do
    assign(:blog_posts, [
             BlogPost.create!(
               title: 'Title',
               body: 'MyText'
             ),
             BlogPost.create!(
               title: 'Title',
               body: 'MyText'
             )
           ])
  end

  it 'renders a list of blog_posts' do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new('Title'.to_s), count: 2
    assert_select cell_selector, text: Regexp.new('MyText'.to_s), count: 2
  end
end
