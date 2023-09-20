# frozen_string_literal: true

FactoryBot.define do
  factory :blog_comment do
    body { 'MyText' }
    user { nil }
    blog_post { nil }
  end
end
