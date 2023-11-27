# frozen_string_literal: true

namespace :custom do
  desc 'boot up the server'
  task :run_server_task do
    on roles(:app) do
      within '/var/www/patrickaaronkim.com/current' do
        with rails_env: 'production' do
          execute 'bin/prod'
        end
      end
    end
  end
end
