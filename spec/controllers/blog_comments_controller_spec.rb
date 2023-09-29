# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BlogCommentsController do
  describe 'routes' do
    it { is_expected.to route(:get, '/blog_posts/1/blog_comments').to(action: :index, blog_post_id: 1) }
  end
end
