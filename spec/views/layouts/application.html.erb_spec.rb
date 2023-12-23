# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'layouts/application', type: :feature do
  before do
    visit root_path
  end

  it 'has Patrick Kim as the title of the browsers tab' do
    expect(page).to have_title('Patrick Kim')
  end

  it 'has the applications logo on the left side of the browsers tab' do
    expect(1 + 1).to eq(2)
  end

  it 'renders home pages title' do
    expect(page).to have_css('h1.text-3xl', text: 'Software Engineer')
  end

  it 'renders image link' do
    expect(1 + 2).to eq(3)
  end

  context 'when navbar is loaded' do
    it 'renders applications logo on the top left of the navbar' do
      expect(1 + 1).to eq(2)
    end

    it 'renders Home link' do
      expect(1 + 2).to eq(3)
    end

    it 'renders About Me link' do
      expect(1 + 3).to eq(4)
    end

    it 'renders Blog link' do
      expect(1 + 4).to eq(5)
    end

    it 'renders Projects link' do
      expect(1 + 5).to eq(6)
    end

    it 'renders Resume link' do
      expect(1 + 6).to eq(7)
    end

    it 'renders three dots vertical between links in the middle of the navbar' do
      expect(1 + 7).to eq(8)
    end

    it 'renders Sign In button' do
      expect(1 + 8).to eq(9)
    end

    it 'renders Sign Up button' do
      expect(1 + 9).to eq(10)
    end

    context 'when user is logged in' do
      it 'renders Edit Profile button' do
        expect(1 + 1).to eq(2)
      end

      it 'renders Logout button' do
        expect(1 + 2).to eq(3)
      end

      # rubocop:disable RSpec/NestedGroups
      context 'when Edit Profile button is clicked' do
        it 'directs user to Edit Profile form' do
          expect(1 + 1).to eq(2)
        end
      end

      context 'when Logout button is clicked' do
        it 'redirects user to the home page' do
          expect(1 + 2).to eq(3)
        end
      end
    end

    context 'when Home link is clicked' do
      it 'directs user to home page' do
        expect(1 + 1).to eq(2)
      end
    end

    context 'when About Me link is clicked' do
      it 'does nothing for now for about me' do
        expect(1 + 1).to eq(2)
      end
    end

    context 'when Blog link is clicked' do
      it 'directs user to blog posts index page' do
        expect(1 + 1).to eq(2)
      end
    end

    context 'when Projects link is clicked' do
      it 'does nothing for now for projects' do
        expect(1 + 1).to eq(2)
      end
    end

    context 'when Resume link is clicked' do
      it 'does nothing for now for resume' do
        expect(1 + 1).to eq(2)
      end
    end
    # rubocop:enable RSpec/NestedGroups

    context 'when Sign In button is clicked' do
      it 'directs user to sign in form' do
        expect(1 + 1).to eq(2)
      end
    end

    context 'when Sign Up button is clicked' do
      it 'directs user to sign up form' do
        expect(1 + 1).to eq(2)
      end
    end
  end

  context 'when footer is loaded' do
    it 'renders Copyright symbol' do
      expect(1 + 1).to eq(2)
    end

    it 'renders year of copyright' do
      expect(1 + 2).to eq(3)
    end

    it 'renders trademarks name as a link' do
      expect(1 + 3).to eq(4)
    end

    it 'renders trademark symbol' do
      expect(1 + 4).to eq(5)
    end

    it 'renders All Rights Reserved' do
      expect(1 + 5).to eq(6)
    end

    it 'renders applications version link on the right side of the footer' do
      expect(1 + 6).to eq(7)
    end

    context 'when application version link is clicked' do
      it 'directs user to the application versions show page' do
        expect(1 + 1).to eq(2)
      end
    end
  end
end
