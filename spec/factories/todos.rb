# frozen_string_literal: true

FactoryBot.define do
  factory :todo do
    title { 'MyString' }
    done { false }
  end
end
