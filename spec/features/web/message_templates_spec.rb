# frozen_string_literal: true

require 'spec_helper'
require_relative '../../pages/web/message_templates_page'

RSpec.describe 'Message Templates workflow', js: true, type: :feature do

  it 'allows users to be able to create a new message template', create_new_template: true, testrail_id: '4283' do
    message_templates_page.goto_templates_from_admin

    message_templates_path = message_templates_page.create_new_template_from_admin
    expect(page).to have_current_path(message_templates_path, ignore_query: true)
  end

  it 'allows users to be able to edit an existing message template', edit_existing_template: true, testrail_id: '4284' do
    message_templates_page.goto_templates_from_admin

    message_templates_path = message_templates_page.edit_existing_template_from_admin
    expect(page).to have_current_path(message_templates_path, ignore_query: true)
  end

  it 'allows users to be able to delete an existing message template', delete_template: true, testrail_id: '4285' do
    message_templates_page.goto_templates_from_admin

    message_templates_path = message_templates_page.delete_template_from_admin
    expect(page).to have_current_path(message_templates_path, ignore_query: true)
  end

  it 'allows users to be able to sort orders of existing message templates', sort_template: true, testrail_id: '4286' do
    message_templates_page.goto_templates_from_admin

    message_templates_path = message_templates_page.sort_template_from_admin
    expect(page).to have_current_path(message_templates_path, ignore_query: true)
  end

  it 'allows users to be able to use message templates when sending a message', use_templates_when_sending_message: true, testrail_id: '4287' do
    message_templates_page.go_to_message_from_add_new

    message_templates_path = message_templates_page.use_templates_on_subject
    expect(page).to have_current_path(message_templates_path, ignore_query: true)
  end

  it 'allows users to be able to clear message template that is currently used in description', clear_templates_when_sending_message: true, testrail_id: '4288' do
    message_templates_page.go_to_message_from_add_new

    message_templates_path = message_templates_page.clear_templates_on_subject
    expect(page).to have_current_path(message_templates_path, ignore_query: true)
  end

  it 'allows users to be able to search for message templates while creating a new message', type_anyword_when_sending_message: true, testrail_id: '4289' do
    message_templates_page.go_to_message_from_add_new

    message_templates_path = message_templates_page.type_anyword_on_subject
    expect(page).to have_current_path(message_templates_path, ignore_query: true)
  end

  it 'allows users to be able to ensure visibility is properly restricted or granted', ensure_visibility_properly_restricted: true, testrail_id: '4290' do
    message_templates_page.go_to_accounts

    message_templates_path = message_templates_page.ensure_visibility_properly_granted
    expect(page).to have_current_path(message_templates_path, ignore_query: true)
  end

  it 'allows users to be able to ensure visibility is properly restricted or granted', ensure_visibility_properly_granted: true, testrail_id: '4291' do
    message_templates_page.go_to_accounts

    message_templates_path = message_templates_page.ensure_visibility_properly_restricted
    expect(page).to have_current_path(message_templates_path, ignore_query: true)
  end

  it 'allows users to be able to ensure details visibility is properly restricted or granted', ensure_visibility_properly_granted: true, testrail_id: '4292' do
    message_templates_page.go_to_accounts

    message_templates_path = message_templates_page.ensure_details_visibility
    expect(page).to have_current_path(message_templates_path, ignore_query: true)
  end

  it 'allows users to be able to ensure emails visibility is properly restricted or granted', ensure_visibility_properly_granted: true, testrail_id: '4293' do
    message_templates_page.go_to_accounts

    message_templates_path = message_templates_page.ensure_emails_visibility
    expect(page).to have_current_path(message_templates_path, ignore_query: true)
  end



  def message_templates_page
    @message_templates_page ||= MessageTemplatesPage.new
  end
end
