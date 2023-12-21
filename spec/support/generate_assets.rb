# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:suite) do
    system('yarn install')
    system('yarn build')
    system('yarn build:css')
  end
end
