# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'blog_posts/edit' do
  let(:blog_post) do
    BlogPost.create!(
      title: 'MyString',
      body: 'MyText'
    )
  end

  before do
    assign(:blog_post, blog_post)
  end

  it 'renders the edit blog_post form' do
    render

    assert_select 'form[action=?][method=?]', blog_post_path(blog_post), 'post' do
      assert_select 'input[name=?]', 'blog_post[title]'

      assert_select 'textarea[name=?]', 'blog_post[body]'
    end
  end
end
