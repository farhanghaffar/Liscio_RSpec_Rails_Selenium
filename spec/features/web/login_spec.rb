# frozen_string_literal: true

require 'spec_helper'
require_relative '../../pages/web/login_page'

RSpec.describe 'Login workflow', js: true, type: :feature do
  # TODO: add testrail_id
  it 'ensures login page displays' do
    login_page.ensure_login_page_rendered
    expect(page).to have_content('Sign In')
  end

  it 'disallows users to sign in with invalid credentials', login_fails: true, testrail_id: '2502' do
    login_page.ensure_login_page_rendered

    login_page.sign_in(email: 'dummy@example.com', password: 'Password@1234')
    expect(page).to have_content('Incorrect email and/or password')
  end

  it 'allows users to sign in with valid credentials', login: true, testrail_id: '2501' do
    login_page.ensure_login_page_rendered

    # TODO: create a user and stub its response
    login_page.sign_in_with_valid_user
    login_page.ensure_correct_credientials
    expect(page).to have_content('DASHBOARD')
  end

  it 'allows users to sign in with a Google account', sign_in_with_google: true, testrail_id: '2503' do
    login_page.ensure_login_page_rendered
    login_page.sign_in_with_google

    expect(page).to have_current_path('/v3/signin/identifier', ignore_query: true)
  end

  it 'allows users to sign in with Office 365', sign_in_with_microsoft: true, testrail_id: '2504' do
    login_page.ensure_login_page_rendered
    login_page.sign_in_with_microsoft

    expect(page).to have_current_path('/common/oauth2/v2.0/authorize', ignore_query: true)
  end

  # initi login page here
  def login_page
    @login_page ||= LoginPage.new
  end
end
