# frozen_string_literal: true

require 'spec_helper'
require_relative '../../pages/mobile/login_page'

RSpec.describe 'Login Feature', js: true, type: :feature do
  it 'verifies mobile users see login screen' do
    login_page.ensure_login_page_rendered
    expect(page).to have_content('Sign In')
  end

  it 'disallows mobile users with invalid credentials to log in', login_fails: true do
    login_page.ensure_login_page_rendered

    login_page.sign_in(email: 'dummy@example.com', password: 'Password@1234')
    expect(page).to have_content('Incorrect email and/or password')
  end

  it 'allows mobile users with valid credentials to log in', login: true do
    login_page.ensure_login_page_rendered

    # TODO: create a user and stub its response
    login_page.sign_in_with_valid_user
    login_page.ensure_correct_credientials
    expect(page).to have_content('Dashboard')
  end

  # it 'allows mobile users to reset password', reset_password: true do
  #   login_page.go_to_forgot_password
  #   expect(page).to have_current_path('/')
  # end

  it 'allows mobile users to sign in with Google', sign_in_with_google: true do
    login_page.ensure_login_page_rendered
    login_page.sign_in_with_google

    expect(page).to have_current_path('/v3/signin/identifier', ignore_query: true)
  end

  it 'allows mobile users to sign in with Office 365', sign_in_with_microsoft: true do
    login_page.ensure_login_page_rendered
    login_page.sign_in_with_microsoft

    expect(page).to have_current_path('/common/oauth2/v2.0/authorize', ignore_query: true)
  end

  # initi login page here
  def login_page
    @login_page ||= LoginPage.new
  end
end
