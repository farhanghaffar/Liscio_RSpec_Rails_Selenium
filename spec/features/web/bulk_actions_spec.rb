# frozen_string_literal: true

require 'spec_helper'
require_relative '../../pages/web/bulk_actions_page'

RSpec.describe 'Bulk actions workflow', js: true, type: :feature do
  it 'allows users to be able to filter employee list of users via entity type', filter_via_entity: true, testrail_id: '3159' do
    bulk_actions_page.goto_new_message_from_bulk_action
    bulk_actions_path = bulk_actions_page.filter_via_entity_type
    expect(page).to have_current_path(bulk_actions_path, ignore_query: true)
  end

  it 'allows users to be able to filter list of users via entity type', filter_via_entity_download_app: true, testrail_id: '3823' do
    bulk_actions_page.goto_invite_app_from_bulk_action
    bulk_actions_path = bulk_actions_page.filter_entity_type_download_app
    expect(page).to have_current_path(bulk_actions_path, ignore_query: true)
  end

  it 'allows users to be able to filter list of users via contact search', filter_via_contact: true, testrail_id: '3824' do
    bulk_actions_page.goto_invite_app_from_bulk_action
    bulk_actions_path = bulk_actions_page.filter_entity_contact
    expect(page).to have_current_path(bulk_actions_path, ignore_query: true)
  end

  it 'allows users to to send an invite to a user to download the mobile app', send_an_invite: true, testrail_id: '3825' do
    bulk_actions_page.goto_invite_app_from_bulk_action
    bulk_actions_path = bulk_actions_page.send_an_invite_to_user
    expect(page).to have_current_path(bulk_actions_path, ignore_query: true)
  end

  it 'allows users to be able to send an invite to a several users at once to download the mobile app', send_an_invite_to_many: true, testrail_id: '3826' do
    bulk_actions_page.goto_invite_app_from_bulk_action
    bulk_actions_path = bulk_actions_page.send_an_invite_to_several
    expect(page).to have_current_path(bulk_actions_path, ignore_query: true)
  end

  it 'allows users to be able to send a get signature request to a user', send_a_get_sign: true, testrail_id: '3827' do
    bulk_actions_page.goto_get_sign_from_bulk_action
    bulk_actions_path = bulk_actions_page.send_get_signature_request
    expect(page).to have_current_path(bulk_actions_path, ignore_query: true)
  end

  it 'allows users to be able to send a get signature request to multiple users at once', send_a_get_sign_for_multiple: true, testrail_id: '3828' do
    bulk_actions_page.goto_get_sign_from_bulk_action
    bulk_actions_path = bulk_actions_page.send_get_signature_request_to_multiple
    expect(page).to have_current_path(bulk_actions_path, ignore_query: true)
  end

  it 'allows users to be able to filter employee list of users via different relationship types available in site', users_via_different_relationship: true, testrail_id: '3830' do
    bulk_actions_page.goto_get_sign_from_bulk_action
    bulk_actions_path = bulk_actions_page.filter_via_relationship
    expect(page).to have_current_path(bulk_actions_path, ignore_query: true)
  end

  it 'allows users to be able to delete certain people from the list in doing bulk action', remove_certain_people: true, testrail_id: '3831' do
    bulk_actions_page.goto_get_sign_from_bulk_action
    bulk_actions_path = bulk_actions_page.delete_from_list
    expect(page).to have_current_path(bulk_actions_path, ignore_query: true)
  end

  it 'allows users to be able to preview each of the document per user to make individual changes', preview_individuals_changes: true, testrail_id: '3832' do
    bulk_actions_page.goto_get_sign_from_bulk_action
    bulk_actions_path = bulk_actions_page.preview_individuals_changes_per_doc
    expect(page).to have_current_path(bulk_actions_path, ignore_query: true)
  end

  it 'allows users to be able to filter employee list of users via client status', filter_via_status: true, testrail_id: '3833' do
    bulk_actions_path = bulk_actions_page.filter_via_client_status
    expect(page).to have_current_path(bulk_actions_path, ignore_query: true)
  end

  it 'allows users to be able to filter employee list via account owner checkbox', account_owner_checkbox: true, testrail_id: '3834' do
    bulk_actions_page.goto_get_sign_from_bulk_action
    bulk_actions_path = bulk_actions_page.check_account_owner
    expect(page).to have_current_path(bulk_actions_path, ignore_query: true)
  end

  it 'allows users to be able to filter list of users via account search', users_via_account_search: true, testrail_id: '3835' do
    bulk_actions_page.goto_get_sign_from_bulk_action
    bulk_actions_path = bulk_actions_page.filter_via_account_search
    expect(page).to have_current_path(bulk_actions_path, ignore_query: true)
  end

  it 'allows users to be able to clear all currently applied filters', currently_applied_filters: true, testrail_id: '3836' do
    bulk_actions_page.goto_invite_app_from_bulk_action
    bulk_actions_path = bulk_actions_page.clear_all_filters
    expect(page).to have_current_path(bulk_actions_path, ignore_query: true)
  end

  it 'allows users to be able to export bulk contact list as csv', export_csv: true, testrail_id: '3838' do
    bulk_actions_path = bulk_actions_page.export_bulk_contact_list_as_csv
    expect(page).to have_current_path(bulk_actions_path, ignore_query: true)
  end

  it 'allow user to be able to send an invite to a user to liscio', send_an_invite_to_user_to_liscio: true, testrail_id: '3847' do
    bulk_actions_path = bulk_actions_page.send_an_invite_to_user_to_liscio
    expect(page).to have_current_path(bulk_actions_path, ignore_query: true)
  end

  it 'allow users to be able to send edocs to a user', send_edoc_to_user: true, testrail_id: '3864' do
    bulk_actions_path = bulk_actions_page.send_edoc_to_user
    expect(page).to have_current_path(bulk_actions_path, ignore_query: true)
  end

  it 'allow users to be able to send edocs to multiple users at once', send_edoc_to_multiple_users: true, testrail_id: '3865' do
    bulk_actions_path = bulk_actions_page.send_edoc_to_multiple_users
    expect(page).to have_current_path(bulk_actions_path, ignore_query: true)
  end

  describe 'bulk actions > reassign task to new owner' do
    it 'allow users to be able to reassign a task to a user', reassign_to_new_user: true, testrail_id: '3874' do
      bulk_actions_path = bulk_actions_page.reassign_to_new_user
      expect(page).to have_current_path(bulk_actions_path, ignore_query: true)
    end

    it 'allow users to be able to reassign multiple tasks at once to a single user', reassign_multiple_tasks_at_once: true, testrail_id: '3875' do
      bulk_actions_path = bulk_actions_page.reassign_multiple_tasks_at_once
      expect(page).to have_current_path(bulk_actions_path, ignore_query: true)
    end

    it 'allow users to be able to filter employee list of users via user task assignee', filter_via_task_assignee: true, testrail_id: '3876' do
      bulk_actions_path = bulk_actions_page.filter_via_task_assignee
      expect(page).to have_current_path(bulk_actions_path, ignore_query: true)
    end

    it 'allow users to be able to filter employee list of users via task type', filter_via_task_type: true, testrail_id: '3877' do
      bulk_actions_path = bulk_actions_page.filter_via_task_type
      expect(page).to have_current_path(bulk_actions_path, ignore_query: true)
    end

    it 'allow users to be able to filter employee list of users via Task owner', filter_employee_list_via_task_owner: true, testrail_id: '3878' do
      bulk_actions_path = bulk_actions_page.filter_employee_list_via_task_owner
      expect(page).to have_current_path(bulk_actions_path, ignore_query: true)
    end

    it 'allow users to be able to filter list of users via account search', filter_via_account_on_reassign_screen: true, testrail_id: '3879' do
      bulk_actions_path = bulk_actions_page.filter_via_account_on_reassign_screen
      expect(page).to have_current_path(bulk_actions_path, ignore_query: true)
    end

    it 'allow users to be able to filter employee list of users via task assigned to', filter_via_task_assigned_to: true, testrail_id: '3880' do
      bulk_actions_path = bulk_actions_page.filter_via_task_assigned_to
      expect(page).to have_current_path(bulk_actions_path, ignore_query: true)
    end
  end

  it 'allow users to be able to filter employee list via recurring task checkbox', filter_emp_via_recurring: true, testrail_id: '3881' do
    bulk_actions_path = bulk_actions_page.filter_employee_via_recurring
    expect(page).to have_current_path(bulk_actions_path, ignore_query: true)
  end

  it 'allow users to be able to delete certain tasks from the list in doing bulk action', delete_from_recurring: true, testrail_id: '3883' do
    bulk_actions_path = bulk_actions_page.delete_certain_from_recurring
    expect(page).to have_current_path(bulk_actions_path, ignore_query: true)
  end

  it 'allows users to be able to send bulk messages from BULK ACTIONS > Send Message', bulk_messages: true, testrail_id: '3160' do
    bulk_actions_path = bulk_actions_page.send_bulk_messages
    expect(page).to have_current_path(bulk_actions_path, ignore_query: true)
  end

  it 'allows users to be able to send bulk eDocs from BULK ACTIONS to multiple recipients', send_bulk_edocs: true, testrail_id: '3363' do
    bulk_actions_path = bulk_actions_page.send_bulk_edocs
    expect(page).to have_current_path(bulk_actions_path, ignore_query: true)
  end

  it 'allows users to be able to send bulk eDocs with multiple templates using BULK ACTION', send_bulk_edocs_to_multiple_templates: true, testrail_id: '3364' do
    bulk_actions_path = bulk_actions_page.send_bulk_edocs_to_multiple_templates
    expect(page).to have_current_path(bulk_actions_path, ignore_query: true)
  end

  def bulk_actions_page
    @bulk_actions_page ||= BulkActionsPage.new
  end
end
