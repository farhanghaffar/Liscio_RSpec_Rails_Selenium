# frozen_string_literal: true

require 'spec_helper'
require_relative '../../pages/web/inbox_page'

RSpec.describe 'Custom inbox filtering', js: true, type: :feature do
  it 'allows users to create a new message filter', create: true, testrail_id: '2505' do
    filter = 'my_temp_filter'
    inbox_page.go_to_inbox

    inbox_page.create_new_filter(filter)
    inbox_page.ensure_custom_filter_exist(filter)
    inbox_page.delete_filter(filter, true)

    expect(page).to have_current_path('/all_messages')
  end

  it 'allows users to edit an existing filter', edit: true, testrail_id: '2506' do
    filter = 'my_temp_filter'

    inbox_page.go_to_inbox
    inbox_page.create_new_filter(filter)
    inbox_page.ensure_custom_filter_exist(filter)
    inbox_page.edit_custome_filter_name(filter, 'my_filter')
    inbox_page.ensure_custom_filter_exist('my_filter')
    inbox_page.delete_filter('my_filter', true)

    expect(page).to have_current_path('/all_messages')
  end

  it 'allows users to delete an existing filter', delete: true, testrail_id: '2507' do
    filter = 'my_temp_filter'
    inbox_page.go_to_inbox

    inbox_page.create_new_filter(filter)
    inbox_page.ensure_custom_filter_exist(filter)
    inbox_page.delete_filter(filter, true)

    expect(page).to have_current_path('/all_messages')
  end

  it 'allow user to be able to open a message to send a reply', send_a_reply: true, testrail_id: '2508' do
    inbox_path = inbox_page.send_a_reply
    expect(page).to have_current_path(inbox_path, ignore_query: true)
  end

  it 'user should not click on the save button with a blank view form', disabled_save_button: true, testrail_id: '3' do
    inbox_path = inbox_page.disabled_save_button
    expect(page).to have_current_path(inbox_path, ignore_query: true)
  end

  it 'allows user to be able to click on the x button to close the create view modal', close_create_view_modal: true, testrail_id: '4' do
    inbox_path = inbox_page.close_create_view_modal
    expect(page).to have_current_path(inbox_path, ignore_query: true)
  end

  it 'allows user to be able to click on the cancel button to close the create view modal', cancel_create_view_modal: true, testrail_id: '5' do
    inbox_path = inbox_page.cancel_create_view_modal
    expect(page).to have_current_path(inbox_path, ignore_query: true)
  end

  it 'allow users to be able to click on the x button to close the edit view modal', close_edit_modal: true, testrail_id: '7' do
    inbox_path = inbox_page.close_edit_modal
    expect(page).to have_current_path(inbox_path, ignore_query: true)
  end

  it 'As a user, I can click on the "Cancel" button to close the "Edit View" modal', cancel_edit_modal: true, testrail_id: '8' do
    inbox_path = inbox_page.cancel_edit_modal
    expect(page).to have_current_path(inbox_path, ignore_query: true)
  end

  it 'As a user, I can click on the x button to close the delete view prompt', close_delete: true, testrail_id: '10' do
    inbox_path = inbox_page.close_delete_view
    expect(page).to have_current_path(inbox_path, ignore_query: true)
  end

  it 'As a user, I can click on the "No" button to close the delete view prompt', close_delete_modal: true, testrail_id: '11' do
    inbox_path = inbox_page.close_delete_view_modal
    expect(page).to have_current_path(inbox_path, ignore_query: true)
  end

  it 'As a user, I can view all messages then filter messages by created view', view_all_messages: true, testrail_id: '12' do
    inbox_path = inbox_page.all_messages_view
    expect(page).to have_current_path(inbox_path, ignore_query: true)
  end

  it 'As a user, I can close + cancel creating a new message from dashboard > HOME', close_or_cancel_modal: true, testrail_id: '24' do
    inbox_path = inbox_page.close_and_cancel_modal
    expect(page).to have_current_path(inbox_path, ignore_query: true)
  end

  it 'As a user, I can close + cancel creating a new message from dashboard > INBOX', close_or_cancel_from_inbox: true, testrail_id: '25' do
    inbox_path = inbox_page.close_and_cancel_modal_inbox
    expect(page).to have_current_path(inbox_path, ignore_query: true)
  end

  it 'As a user, I can view messages sent to a specific account', view_messages_sent: true, testrail_id: '26' do
    inbox_path = inbox_page.view_sent_messages
    expect(page).to have_current_path(inbox_path, ignore_query: true)
  end

  def inbox_page
    @inbox_page ||= InboxPage.new
  end
end
