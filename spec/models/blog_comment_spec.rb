# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BlogComment do
  describe 'schema' do
    it { is_expected.to have_db_column(:body) }
    it { is_expected.to have_db_column(:user_id) }
    it { is_expected.to have_db_column(:blog_post_id) }
    it { is_expected.to have_db_column(:created_at) }
    it { is_expected.to have_db_column(:updated_at) }
    it { is_expected.to have_db_column(:parent_id) }
    it { is_expected.to have_db_column(:body).of_type(:text) }
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    it { is_expected.to have_db_column(:blog_post_id).of_type(:integer) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:parent_id).of_type(:integer) }
    it { is_expected.to have_db_column(:user_id).with_options(null: false) }
    it { is_expected.to have_db_column(:blog_post_id).with_options(null: false) }
    it { is_expected.to have_db_column(:created_at).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).with_options(null: false) }
    it { is_expected.to have_db_index(:blog_post_id) }
    it { is_expected.to have_db_index(:user_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:blog_post) }
    it { is_expected.to belong_to(:parent).class_name('BlogComment').optional }
    it { is_expected.to have_many(:replies) }
    it { is_expected.to have_many(:replies).class_name('BlogComment') }
    it { is_expected.to have_many(:replies).with_foreign_key(:parent_id) }
    it { is_expected.to have_many(:replies).dependent(:destroy) }
    it { is_expected.to have_many(:replies).inverse_of(false) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:body) }
  end
end
