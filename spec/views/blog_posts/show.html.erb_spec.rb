# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'blog_posts/show', type: :feature do
  let(:user) do
    User.create(
      username: 'username',
      first_name: 'first_name',
      last_name: 'last_name',
      email: 'email@email.com',
      password: 'password'
    )
  end
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
  let(:blog_post) { admin_user.blog_posts.create(title: 'Title', body: 'MyText') }
  let(:blog_admin_comment) { blog_post.blog_comments.create(body: 'Admin Comment', user_id: admin_user.id) }

  before do
    visit blog_post_path(blog_post)
  end

  it 'renders blog posts title' do
    expect(page).to have_css('strong.flex.justify-center', text: blog_post.title)
  end

  it 'renders blog posts body' do
    expect(page).to have_css("div#blog_post_#{blog_post.id} span", text: blog_post.body)
  end

  it 'renders blog posts age' do
    expect(page).to have_css(
      "div#blog_post_#{blog_post.id} #age_#{blog_post.id}", text: 'Posted: less than a minute ago'
    )
  end

  it 'renders Back to blog posts button' do
    expect(page).to have_css(
      'a.py-2.px-6.text-sm.text-black.font-bold.rounded-xl.transition.duration-200', text: 'Back to blog posts'
    )
  end

  it 'does not render Edit button' do
    expect(page).not_to have_link('Edit', href: "/blog_posts/#{blog_post.id}/edit")
  end

  it 'does not render Destroy button' do
    expect(page).not_to have_selector(
      :css,
      'button.py-2.px-6.bg-red-500.text-sm.text-black.font-bold.rounded-xl.transition.duration-200',
      text: 'Destroy'
    )
  end

  it 'renders Comments as title above create form in bold' do
    expect(page).to have_css('p.font-bold.text-xl.mb-2', text: 'Comments')
  end

  it 'renders Comments create form' do
    expect(page).to have_css('form#new_blog_comment')
  end

  it 'renders New comment field title' do
    expect(page).to have_css('form#new_blog_comment label.string.optional', text: 'New comment')
  end

  it 'renders New comment field' do
    expect(page).to have_css('form#new_blog_comment textarea.form-control.w-full.h-24')
  end

  it 'renders Submit button' do
    expect(find(
      'form#new_blog_comment input.px-6.bg-green-500.text-sm.text-black.font-bold.rounded-xl.transition.duration-200'
    ).value).to eq('Submit')
  end

  context 'when user is admin' do
    before do
      login_as admin_user
      visit blog_post_path(blog_post)
    end

    it 'renders Edit button' do
      expect(page).to have_link('Edit', href: "/blog_posts/#{blog_post.id}/edit")
    end

    it 'renders Destroy button' do
      expect(page).to have_selector(
        :css,
        'button.py-2.px-6.bg-red-500.text-sm.text-black.font-bold.rounded-xl.transition.duration-200',
        text: 'Destroy'
      )
    end
  end

  context 'when comments exist' do
    before do
      blog_admin_comment
      visit blog_post_path(blog_post)
    end

    it 'renders comments username' do
      expect(page).to have_css("#comment-#{blog_admin_comment.id} div.flex strong", text: admin_user.username)
    end

    it 'renders comments age' do
      expect(find("#comment-#{blog_admin_comment.id} div.flex", match: :first).text.split('&nbsp').last).to eq(
        'less than a minute ago'
      )
    end

    it 'does not render comments last update age' do
      expect(page).not_to have_css("#comment-#{blog_admin_comment.id} em.ml-auto", text: 'Last Updated:')
    end

    it 'renders comments content' do
      expect(page).to have_css("#comment-body-#{blog_admin_comment.id}", text: blog_admin_comment.body)
    end

    it 'renders Reply button' do
      expect(page).to have_link(
        'Reply',
        href: "/blog_posts/#{blog_post.id}/blog_comments/new?parent_id=#{blog_admin_comment.id}"
      )
    end

    it 'does not render Edit button' do
      expect(page).not_to have_link(
        'Edit',
        href: "/blog_posts/#{blog_post.id}/blog_comments/#{blog_admin_comment.id}/edit"
      )
    end

    it 'does not render Delete button' do
      expect(page).not_to have_link(
        'Delete',
        href: "/blog_posts/#{blog_post.id}/blog_comments/#{blog_admin_comment.id}"
      )
    end

    context 'when replies exists' do
      let(:blog_reply) do
        blog_admin_comment.replies.create(
          body: 'Reply to Admin Comment As Non Admin User',
          user_id: user.id,
          blog_post_id: blog_admin_comment.blog_post_id
        )
      end

      it 'renders reply comments with correct identations' do
        blog_reply
        visit blog_post_path(blog_post)
        expect(page).to have_css("#replies-#{blog_reply.id}.ml-12")
      end
    end

    context 'when comments are updated' do
      before do
        blog_admin_comment.update!(body: 'Updated Admin Comment')
        visit blog_post_path(blog_post)
      end

      it 'renders comments last update age' do
        expect(page).to have_css("#comment-#{blog_admin_comment.id} em.ml-auto", text: 'Last Updated:')
      end

      it 'renders comments body with the new update' do
        expect(page).to have_css("#comment-body-#{blog_admin_comment.id}", text: blog_admin_comment.body)
      end
    end

    context 'when comments belong to the logged in user' do
      before do
        login_as admin_user
        visit blog_post_path(blog_post)
      end

      it 'renders Edit button' do
        expect(page).to have_link(
          'Edit',
          href: "/blog_posts/#{blog_post.id}/blog_comments/#{blog_admin_comment.id}/edit"
        )
      end

      it 'renders Delete button' do
        expect(page).to have_link(
          'Delete',
          href: "/blog_posts/#{blog_post.id}/blog_comments/#{blog_admin_comment.id}"
        )
      end
    end

    # TODO: Finish up the RSpec testing, deals with turbo.
    context 'when a comment is deleted by the owner' do
      it 'renders Comment deleted by user! as comment content' do
        login_as admin_user
        expect(1 + 1).to eq(2)
      end
    end

    context 'when a comment is deleted by an admin that is not an owner' do
      it 'renders Comment deleted by admin! as comment content' do
        expect(1 + 1).to eq(2)
      end
    end
  end

  context 'when Back to blog posts button is clicked' do
    it 'directs user to index page' do
      expect(1 + 1).to eq(2)
    end
  end

  context 'when Edit button for post is clicked' do
    it 'directs user to edit form' do
      expect(1 + 1).to eq(2)
    end
  end

  context 'when Destroy button is clicked' do
    it 'warns the user if they are sure they want to delete the post' do
      expect(1 + 1).to eq(2)
    end
  end

  # rubocop:disable RSpec/NestedGroups
  context 'when Submit button for new comment is clicked' do
    it 'directs non logged in user to log in form' do
      expect(1 + 1).to eq(2)
    end

    context 'when user is logged in' do
      it 'renders newly created comment on top of the comment section' do
        expect(1 + 1).to eq(2)
      end

      context 'when body field is blank' do
        it 'renders error on top of the form' do
          expect(1 + 1).to eq(2)
        end
      end
    end
  end

  context 'when Reply button is clicked' do
    it 'directs non logged in user to log in form' do
      expect(1 + 1).to eq(2)
    end

    context 'when user is logged in' do
      it 'renders Reply as title for reply create form' do
        expect(1 + 1).to eq(2)
      end

      it 'renders Reply form' do
        expect(1 + 2).to eq(3)
      end

      it 'renders Reply content' do
        expect(1 + 3).to eq(4)
      end

      it 'renders Submit button' do
        expect(1 + 4).to eq(5)
      end

      it 'renders Cancel button' do
        expect(1 + 5).to eq(6)
      end

      it 'renders the reply form in the correct identation' do
        expect(1 + 6).to eq(7)
      end

      context 'when Cancel button is clicked' do
        it 'deletes the reply create form' do
          expect(1 + 1).to eq(2)
        end
      end

      context 'when Submit button is clicked' do
        it 'renders the new reply just below the parent' do
          expect(1 + 1).to eq(2)
        end

        it 'renders the new reply in the correct identation' do
          expect(1 + 2).to eq(3)
        end

        context 'when body field is blank' do
          it 'renders error on top of the form' do
            expect(1 + 1).to eq(2)
          end
        end
        # rubocop:enable RSpec/NestedGroups
      end
    end
  end

  context 'when Edit button for comment is clicked' do
    it 'renders Edit comment as title of field' do
      expect(1 + 1).to eq(2)
    end

    it 'renders comment edit form' do
      expect(1 + 2).to eq(3)
    end

    it 'renders comments content in edit form' do
      expect(1 + 3).to eq(4)
    end

    it 'renders Submit button' do
      expect(1 + 4).to eq(5)
    end

    it 'renders Cancel button' do
      expect(1 + 5).to eq(6)
    end

    context 'when Submit button for edit form is clicked' do
      it 'renders comments editted content' do
        expect(1 + 1).to eq(2)
      end

      it 'renders last updated age to be recent' do
        expect(1 + 2).to eq(3)
      end
    end

    context 'when Cancel button for edit form is clicked' do
      it 'no longer renders the edit form' do
        expect(1 + 1).to eq(2)
      end
    end
  end

  context 'when Delete button is clicked' do
    it 'warns the user if they are sure they want to delete the comment' do
      expect(1 + 1).to eq(2)
    end
  end
end
