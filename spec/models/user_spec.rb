# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe User do
  describe 'schema' do
    it { is_expected.to have_db_column(:email) }
    it { is_expected.to have_db_column(:encrypted_password) }
    it { is_expected.to have_db_column(:reset_password_token) }
    it { is_expected.to have_db_column(:remember_created_at) }
    it { is_expected.to have_db_column(:created_at) }
    it { is_expected.to have_db_column(:updated_at) }
    it { is_expected.to have_db_column(:role) }
    it { is_expected.to have_db_column(:username) }
    it { is_expected.to have_db_column(:first_name) }
    it { is_expected.to have_db_column(:last_name) }
    it { is_expected.to have_db_column(:email).of_type(:string) }
    it { is_expected.to have_db_column(:encrypted_password).of_type(:string) }
    it { is_expected.to have_db_column(:reset_password_token).of_type(:string) }
    it { is_expected.to have_db_column(:remember_created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:role).of_type(:integer) }
    it { is_expected.to have_db_column(:username).of_type(:string) }
    it { is_expected.to have_db_column(:first_name).of_type(:string) }
    it { is_expected.to have_db_column(:last_name).of_type(:string) }
    it { is_expected.to have_db_column(:email).with_options(default: '', null: false) }
    it { is_expected.to have_db_column(:encrypted_password).with_options(default: '', null: false) }
    it { is_expected.to have_db_column(:created_at).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).with_options(null: false) }
    it { is_expected.to have_db_index(:email) }
    it { is_expected.to have_db_index(:reset_password_token) }
    it { is_expected.to have_db_index(:username) }
    it { is_expected.to have_db_index(:email).unique(true) }
    it { is_expected.to have_db_index(:reset_password_token).unique(true) }
    it { is_expected.to have_db_index(:username).unique(true) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:blog_posts) }
    it { is_expected.to have_many(:blog_comments) }
    it { is_expected.to define_enum_for(:role) }
    it { is_expected.to define_enum_for(:role).with_values(%i[member admin]) }
    it { is_expected.to define_enum_for(:role).with_values(member: 0, admin: 1) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_uniqueness_of(:username).case_insensitive }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end

  describe 'abilities' do
    subject(:ability) { Ability.new(user) }

    let(:user) { nil }

    context 'when user is an admin' do
      let(:user) do
        described_class.create(
          username: 'username_admin_test',
          first_name: 'first_name_admin_test',
          last_name: 'last_name_admin_test',
          email: 'admin_test@gmail.com',
          password: 'password_admin_test',
          role: 'admin'
        )
      end

      it { is_expected.to be_able_to(:manage, BlogPost) }
      it { is_expected.to be_able_to(:manage, BlogComment) }
    end

    context 'when user is a member' do
      let(:user) do
        described_class.create(
          username: 'username_test',
          first_name: 'first_name_test',
          last_name: 'last_name_test',
          email: 'test@gmail.com',
          password: 'password_test',
          role: 'member'
        )
      end

      it { is_expected.to be_able_to(:read, BlogPost) }
      it { is_expected.not_to be_able_to(:create, BlogPost) }
      it { is_expected.not_to be_able_to(:update, BlogPost) }
      it { is_expected.not_to be_able_to(:destroy, BlogPost) }
      it { is_expected.to be_able_to(:read, BlogComment) }
      it { is_expected.to be_able_to(:create, BlogComment) }
    end

    context 'when comment/reply does not belong to user' do
      let(:user_created_comment) do
        described_class.create(
          username: 'username_test_1',
          first_name: 'first_name_test',
          last_name: 'last_name_test',
          email: 'test1@gmail.com',
          password: 'password_test',
          role: 'member'
        )
      end
      let(:user) do
        described_class.create(
          username: 'username_test_2',
          first_name: 'first_name_test',
          last_name: 'last_name_test',
          email: 'test2@gmail.com',
          password: 'password_test',
          role: 'member'
        )
      end
      let(:blog_post) do
        BlogPost.create(
          title: 'Title test',
          body: 'Body test',
          user_id: user_created_comment.id
        )
      end
      let(:blog_comment) do
        BlogComment.create(
          body: 'Body test',
          blog_post_id: blog_post.id,
          user_id: user_created_comment.id
        )
      end

      before do
        blog_comment
        user
      end

      it { is_expected.not_to be_able_to(:update, blog_comment) }
      it { is_expected.not_to be_able_to(:destroy, blog_comment) }
    end
  end
end
