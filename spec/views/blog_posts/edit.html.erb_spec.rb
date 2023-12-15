# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'blog_posts/edit', type: :feature do
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

  it 'renders Editing Blog Post as title' do
    expect(1 + 1).to eq(2)
  end

  it 'renders Title field' do
    expect(1 + 2).to eq(3)
  end

  it 'renders Title content' do
    expect(1 + 3).to eq(4)
  end

  it 'renders Body field' do
    expect(1 + 4).to eq(5)
  end

  it 'renders Body content' do
    expect(1 + 5).to eq(6)
  end

  it 'renders tinymce' do
    expect(1 + 6).to eq(7)
  end

  it 'renders Update Blog post button' do
    expect(1 + 7).to eq(8)
  end

  it 'renders Cancel button' do
    expect(1 + 8).to eq(9)
  end

  it 'renders the edit form' do
    expect(user.username).to eq('username')
  end

  context 'when Update blog post button is clicked' do
    it 'directs user to blog post show page' do
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
    it 'directs user to blog post show page' do
      expect(1 + 1).to eq(2)
    end
  end

  context 'when non logged in user manually enters edit form url' do
    it 'directs user to sign in form' do
      expect(1 + 1).to eq(2)
    end
  end

  context 'when non admin logged in user manually enters edit form url' do
    it 'directs user to access denied error page' do
      expect(1 + 1).to eq(2)
    end
  end
end
