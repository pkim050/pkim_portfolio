# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Todo do
  describe 'schema' do
    it { is_expected.to have_db_column(:title) }
    it { is_expected.to have_db_column(:done) }
    it { is_expected.to have_db_column(:created_at) }
    it { is_expected.to have_db_column(:updated_at) }
    it { is_expected.to have_db_column(:title).of_type(:string) }
    it { is_expected.to have_db_column(:done).of_type(:boolean) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:done).with_options(default: false) }
    it { is_expected.to have_db_column(:done).with_options(null: false) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
  end
end
