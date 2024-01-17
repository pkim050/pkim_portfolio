# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'blog_posts/new', type: :feature do
  let(:admin_user) do
    User.create(
      username: 'admin_username',
      first_name: 'admin_first_name',
      last_name: 'admin_last_name',
      email: 'admin_email@email.com',
      password: 'admin_password',
      role: 1
    )
  end
  let(:user) do
    User.create(
      username: 'username',
      first_name: 'first_name',
      last_name: 'last_name',
      email: 'email@email.com',
      password: 'password'
    )
  end

  before do
    login_as admin_user
    visit new_blog_post_path
  end

  it 'renders New Blog Post as title' do
    expect(page).to have_css('.text-4xl.font-bold.flex.items-center.justify-center.pt-6', text: 'New Blog Post')
  end

  it 'renders Title fields title' do
    expect(page).to have_css('label.string.optional.text-xl.text-pink-300', text: 'Title')
  end

  it 'renders Title field' do
    expect(page).to have_css('.string.required.border-2.border-gray-300.p-2.w-full')
  end

  it 'renders Body fields title' do
    expect(page).to have_css('label.string.optional.text-xl.text-pink-300', text: 'Body')
  end

  it 'renders Body field' do
    expect(page).to have_css('textarea.tinymce.border-2.border-gray-500')
  end

  it 'has two asterisk, one for each fields' do
    expect(page).to have_css('span.text-red-500', text: '*', count: 2)
  end

  it 'renders new blog_post form' do
    expect(page).to have_css('div.p-6.bg-black.border-b')
  end

  it 'renders Create Blog post button' do
    expect(find('.btn.p-3.bg-green-500.text-black.font-bold.transition.duration-200').value).to eq('Create Blog post')
  end

  it 'renders Cancel button' do
    expect(page).to have_css('.p-3.bg-red-500.text-black.font-bold.transition.duration-200', text: 'Cancel')
  end

  context 'when Create Blog post button is clicked' do
    it 'directs user to show page' do
      fill_in 'blog_post_title', with: 'Title Example'
      fill_in 'blog_post_body', with: 'Body Example'
      click_button 'Create Blog post'
      expect(page).to have_current_path(blog_post_path(BlogPost.first))
    end

    context 'when title field is empty' do
      it 'renders title error on top of the form' do
        fill_in 'blog_post_body', with: 'Body Example'
        click_button 'Create Blog post'
        expect(page).to have_css('strong.text-red-500.flex.justify-center.items-center', text: "Title can't be blank")
      end
    end

    context 'when body field is empty' do
      it 'renders body error on top of the form' do
        fill_in 'blog_post_title', with: 'Title Example'
        click_button 'Create Blog post'
        expect(page).to have_css('strong.text-red-500.flex.justify-center.items-center', text: "Body can't be blank")
      end
    end

    context 'when title and body fields are empty' do
      it 'renders title and body errors on top of the form' do
        click_button 'Create Blog post'
        expect(page).to have_css('strong.text-red-500.flex.justify-center.items-center', count: 2)
      end
    end
  end

  context 'when Cancel button is clicked' do
    it 'directs user to index page' do
      click_link 'Cancel'
      expect(page).to have_current_path(blog_posts_path)
    end
  end

  context 'when non logged in user manually enters new form url' do
    it 'directs user to log in form' do
      logout
      visit new_blog_post_path
      expect(page).to have_current_path(user_session_path)
    end
  end

  context 'when non admin logged in user manually enters new form url' do
    it 'directs user to access denied error page' do
      logout
      login_as user
      expect { visit new_blog_post_path }.to raise_error(
        CanCan::AccessDenied, 'You are not authorized to access this page.'
      )
    end
  end
end
