# frozen_string_literal: true

module ControllerMacros
  def login_admin
    before do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      admin = User.create(
        username: 'admin_username_test',
        first_name: 'first_name_test',
        last_name: 'last_name_test',
        email: 'test_admin@gmail.com',
        password: 'password_test',
        role: 'admin'
      )
      sign_in admin
    end
  end

  def login_user
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = User.create(
        username: 'member_username_test',
        first_name: 'first_name_test',
        last_name: 'last_name_test',
        email: 'test_member@gmail.com',
        password: 'password_test',
        role: 'member'
      )
      sign_in user
    end
  end
end
