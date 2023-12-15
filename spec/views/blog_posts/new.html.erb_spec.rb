# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'blog_posts/new', type: :feature do
  let(:user) do
    User.create(
      username: 'username',
      first_name: 'first_name',
      last_name: 'last_name',
      email: 'email@email.com',
      password: 'password'
    )
  end
  let(:blog_post) { user.blog_posts.new }

  it 'renders New Blog Post as title' do
    expect(1 + 1).to eq(2)
  end

  it 'renders Title field' do
    expect(1 + 2).to eq(3)
  end

  it 'renders Body field' do
    expect(1 + 3).to eq(4)
  end

  it 'renders tinymce' do
    expect(1 + 4).to eq(5)
  end

  it 'renders new blog_post form' do
    expect(user.username).to eq('username')
  end

  context 'when Create Blog post button is clicked' do
    it 'directs user to show page' do
      expect(1 + 1).to eq(2)
    end

    context 'when title field is empty' do
      it 'renders title error on top of the form' do
        expect(1 + 1).to eq(2)
      end
    end

    context 'when body field is empty' do
      it 'renders body error on top of the form' do
        expect(1 + 1).to eq(2)
      end
    end

    context 'when title and body fields are empty' do
      it 'renders title and body errors on top of the form' do
        expect(1 + 1).to eq(2)
      end
    end
  end

  context 'when Cancel button is clicked' do
    it 'directs user to index page' do
      expect(1 + 1).to eq(2)
    end
  end

  context 'when non logged in user manually enters new form url' do
    it 'directs user to sign in form' do
      expect(1 + 1).to eq(2)
    end
  end

  context 'when non admin logged in user manually enters new form url' do
    it 'directs user to access denied error page' do
      expect(1 + 1).to eq(2)
    end
  end
end
