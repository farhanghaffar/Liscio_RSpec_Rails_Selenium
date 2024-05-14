# frozen_string_literal: true

require 'spec_helper'
require_relative '../../pages/web/admin_page'

RSpec.describe 'Admin workflow', js: true, type: :feature do
  it 'ensures firm admin user cannot login to accounts and view their emails', login_as_other_account: true, testrail_id: '3438' do
    admin_path = admin_page.login_as_other_account

    expect(page).to have_current_path(admin_path, ignore_query: true)
  end

  it 'ensures visibility is properly restricted or granted', ensure_visibility: true, testrail_id: '3435' do
    admin_path = admin_page.ensure_visibility

    expect(page).to have_current_path(admin_path, ignore_query: true)
  end

  it 'ensures user should be able to use log me in as feature', log_me_as_feature: true, testrail_id: '4182' do
    admin_page.go_to_users_from_admin
    admin_path = admin_page.use_log_me_as_feature
    expect(page).to have_current_path(admin_path, ignore_query: true)
  end

  it 'ensures user visibility is properly restricted or granted', user_visibility: true, testrail_id: '3435' do
    admin_page.go_to_accounts
    admin_path = admin_page.ensure_user_visibility
    expect(page).to have_current_path(admin_path, ignore_query: true)
  end

  it 'ensures user visibility is properly restricted or granted as employee', user_visibility_employee: true, testrail_id: '3436' do
    admin_page.go_to_accounts
    admin_path = admin_page.ensure_user_visibility_as_employee
    expect(page).to have_current_path(admin_path, ignore_query: true)
  end

  it 'ensures user visibility is properly restricted or granted as employee as specialist', user_visibility_specialist: true, testrail_id: '3437' do
    admin_page.go_to_accounts
    admin_path = admin_page.ensure_user_visibility_as_specialist
    expect(page).to have_current_path(admin_path, ignore_query: true)
  end

  it 'allows user to edit a message template', edit_a_message_template: true, testrail_id: '2524' do
    admin_path = admin_page.edit_a_message_template
    expect(page).to have_current_path(admin_path, ignore_query: true)
  end

  it 'allows user to send a previously edited message template to a recipient', send_edited_template_to_a_recipient: true, testrail_id: '2525' do
    admin_path = admin_page.send_edited_template_to_a_recipient
    expect(page).to have_current_path(admin_path, ignore_query: true)
  end

  def admin_page
    @admin_page ||= AdminPage.new
  end
end
