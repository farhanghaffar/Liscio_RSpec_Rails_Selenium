# frozen_string_literal: true

require 'spec_helper'
require_relative '../../pages/web/task_page'

RSpec.describe 'Task workflow', js: true, type: :feature do
  it 'allows users to view a signed engagement letter', engagement_letter: true, testrail_id: '2583' do
    task_page.go_to_tasks

    task_path = task_page.verify_engagement_letter
    expect(task_path).to include('/task/detail/')
    #expect(page).has_text('403 ERROR')
  end

  it 'allows users to create a new task from task tab', create_todo: true, testrail_id: '2619' do
    task_page.go_to_tasks

    task_page.create_new_todo_task
    expect(page).to have_current_path('/task/new', ignore_query: true)
  end

  it 'allows users to create a new task from home screen', create_todo_from_home: true, testrail_id: '2617' do
    task_page.create_new_todo_task_from_home
    expect(page).to have_current_path('/task/new', ignore_query: true)
  end

  it 'allows users to create a new task from account screen', create_todo_from_account: true, testrail_id: '2620' do
    accounts_path = task_page.create_new_todo_task_from_account
    expect(page).to have_current_path(accounts_path)
  end

  it 'allows users to create a new task from contact screen', create_todo_from_contact: true, testrail_id: '2622' do
    contacts_path = task_page.create_new_todo_task_from_contact
    expect(page).to have_current_path(%r{/contactdetails/task/\d+})
  end

  it 'ensures a description box displays', description_box: true, testrail_id: '2585' do
    task_page.go_to_tasks

    task_path = task_page.ensure_box_border_is_visible
    expect(page).to have_current_path(task_path, ignore_query: true)
  end

  describe 'ensure all task types are working as expected', task_type: true do
    it 'allows users to create a request information task', create_request_info_task: true, testrail_id: '3349' do
      task_page.go_to_tasks
      task_path = task_page.create_task_request_info
      expect(page).to have_current_path(task_path, ignore_query: true)
    end

    it 'disallows users to create a request information task with incomplete mandatory details', incomplete_data_task_details: true, testrail_id: '3367' do
      task_page.go_to_tasks
      task_path = task_page.create_incomplete_request_info
      expect(page).to have_current_path(task_path, ignore_query: true)
    end

    it 'allows users to create a get a signature task', create_get_signature_task: true, testrail_id: '3350' do
      task_page.go_to_tasks
      task_path = task_page.create_task_get_sign
      expect(page).to have_current_path(task_path, ignore_query: true)
    end

    it 'disallows users to create a To Do signature task with incomplete mandatory details', incomplete_data_get_signature: true, testrail_id: '3369' do
      task_page.go_to_tasks
      task_path = task_page.create_incomplete_sign_task
      expect(page).to have_current_path(task_path, ignore_query: true)
    end

    it 'allows users to be create a To Do task', create_to_do_task: true, testrail_id: '3351' do
      task_page.go_to_tasks
      task_path = task_page.create_task_to_do
      expect(page).to have_current_path(task_path, ignore_query: true)
    end

    it 'disallows users to create a To Do task with incomplete mandatory details', incomplete_data_to_do: true, testrail_id: '3370' do
      task_page.go_to_tasks
      task_path = task_page.create_incomplete_todo_task
      expect(page).to have_current_path(task_path, ignore_query: true)
    end

    it 'allows users to be create a Manage To Go items task', create_manage_to_items: true, testrail_id: '3353' do
      task_page.go_to_tasks
      task_path = task_page.create_task_manage_to_items
      expect(page).to have_current_path(task_path, ignore_query: true)
    end

    it 'disallows users to create a Manage To Go task with incomplete mandatory details', incomplete_manage_to_items: true, testrail_id: '3373' do
      task_page.go_to_tasks
      task_path = task_page.create_incomplete_manage_items
      expect(page).to have_current_path(task_path, ignore_query: true)
    end


    it 'allows users to be create a meeting task', create_meeting_task: true, testrail_id: '3352' do
      task_page.go_to_tasks
      task_path = task_page.create_task_meeting
      expect(page).to have_current_path(task_path, ignore_query: true)
    end

    it 'disallows users to create a meeting task with incomplete mandatory details', incomplete_meeting_task: true, testrail_id: '3372' do
      task_page.go_to_tasks
      task_path = task_page.create_incomplete_meeting
      expect(page).to have_current_path(task_path, ignore_query: true)
    end

    it 'allows users to be create a calendly meeting task', create_calendly_meeting_task: true, testrail_id: '3355' do
      task_page.go_to_tasks
      task_path = task_page.create_calendly_task
      expect(page).to have_current_path(task_path, ignore_query: true)
    end
  end

  describe 'Task view', task_view: true do
    it 'allows users to be able to use text formatting in creating task', testrail_id: '4195', use_text_formatting: true do
      task_page.goto_templates_from_admin
      task_path = task_page.use_text_formatting_in_task
      expect(page).to have_current_path(task_path, ignore_query: true)
    end

    it 'allows users to be able to attach templates and attachments in creating a new task', attach_templates_and_attachments: true, testrail_id: '4196' do
      task_page.go_to_task_to_do
      task_path = task_page.attach_templates_in_new_task
      expect(page).to have_current_path(task_path, ignore_query: true)
    end

    it 'allows users to be able to view tasks with proper formatting', testrail_id: '4197', view_task: true do
      task_page.go_to_home
      task_path = task_page.view_tasks_with_formatting
      expect(page).to have_current_path(task_path, ignore_query: true)
    end
  end

  describe 'Task Creation', task_creation: true do
    it 'allows users to manually create a get a signature tasks for engagement letter from tasks > + task', create_a_task_from_tasks_screen: true, testrail_id: '3800' do
      task_path = task_page.create_a_task_from_tasks_screen
      expect(page).to have_current_path(task_path, ignore_query: true)
    end

    it 'allows users to manually create a get a signature tasks for engagement letter from + add new > task', create_a_task_from_add_new: true, testrail_id: '3801' do
      task_path = task_page.create_a_task_from_add_new
      expect(page).to have_current_path(task_path, ignore_query: true)
    end
  end

  it 'allow users manually mark the get a signature task for consent to release as complete', mark_get_a_signature_as_complete: true, testrail_id: '3885' do
    task_path = task_page.mark_get_a_signature_as_complete
    expect(page).to have_current_path(task_path, ignore_query: true)
  end

  it 'allows user to sign a get a signature task for engagement letter', sign_get_a_signature_for_engagement_letter: true, testrail_id: '3897' do
    task_path = task_page.sign_get_a_signature_for_engagement_letter
    expect(page).to have_current_path(task_path, ignore_query: true)
  end

  it 'allows user to sign a get a signature task for consent to release.', sign_get_a_signature_for_consent_to_release: true, testrail_id: '3898' do
    task_path = task_page.sign_get_a_signature_for_consent_to_release
    expect(page).to have_current_path(task_path, ignore_query: true)
  end

  it 'allows user to manually create a get a signature tasks for engagement letter from email', manually_create_get_a_signatur_for_engagement_letter_from_email: true, testrail_id: '3798' do
    task_path = task_page.manually_create_get_a_signatur_for_engagement_letter_from_email
    expect(page).to have_current_path(task_path, ignore_query: true)
  end

  it 'allows user to manually create a get a signature tasks for consent to release from email', manualy_create_get_a_signature_for_consent_to_release: true, testrail_id: '3799' do
    task_path = task_page.manualy_create_get_a_signature_for_consent_to_release
    expect(page).to have_current_path(task_path, ignore_query: true)
  end

  it 'allow users manually create a get a signature tasks for engagement letter from accounts > + task', manually_create_sign_task_from_account: true, testrail_id: '3802' do
    task_path = task_page.manually_create_sign_task_from_account
    expect(page).to have_current_path(task_path, ignore_query: true)
  end

  it 'allows user manually create a get a signature tasks for engagement letter from contacts > + task', manually_create_sign_task_from_contact: true, testrail_id: '3803' do
    task_path = task_page.manually_create_sign_task_from_contact
    expect(page).to have_current_path(task_path, ignore_query: true)
  end

  it 'allows user manually create a get a signature tasks for consent to release from tasks > + task', manually_create_sign_task_from_tasks: true, testrail_id: '3804' do
    task_path = task_page.manually_create_sign_task_from_tasks
    expect(page).to have_current_path(task_path, ignore_query: true)
  end

  it 'allow users manually create a get a signature tasks for consent to release + add new > task', create_consent_release_from_task: true, testrail_id: '3817' do
    task_path = task_page.create_consent_release_from_task
    expect(page).to have_current_path(task_path, ignore_query: true)
  end

  it 'allows user manually create a get a signature tasks for consent to release from accounts > + task', create_consent_release_from_account: true, testrail_id: '3818' do
    task_path = task_page.create_consent_release_from_account
    expect(page).to have_current_path(task_path, ignore_query: true)
  end

  it 'allows user manually create a get a signature tasks for consent to release from contacts > + task', create_consent_release_from_contact: true, testrail_id: '3819' do
    task_path = task_page.create_consent_release_from_contact
    expect(page).to have_current_path(task_path, ignore_query: true)
  end

  it 'allows firm admin to send file to a client without sending them a liscio notification', send_file_without_sending_notification: true, testrail_id: '3820' do
    task_path = task_page.send_file_without_sending_notification
    expect(page).to have_current_path(task_path, ignore_query: true)
  end

  it 'allows user manually mark the get a signature task for engagement letter as complete', letter_mark_as_complete: true, testrail_id: '3884' do
    task_path = task_page.letter_mark_as_complete
    expect(page).to have_current_path(task_path, ignore_query: true)
  end

  it 'allows user should be able to create a zoom meeting task', create_meeting_task: true, testrail_id: '3356' do
    task_page.go_to_tasks
    task_path = task_page.create_meeting_task
    expect(page).to have_current_path(task_path, ignore_query: true)
  end

  it 'allows user able to create a task via add new button from dashboard', create_task_from_addnew: true, testrail_id: '2618' do
    task_page.go_to_tasks
    task_path = task_page.create_task_from_addnew
    expect(page).to have_current_path(task_path, ignore_query: true)
  end

  it 'allows user to upload multiple files with different file types', upload_different_file_type: true, testrail_id: '102' do
    task_path = task_page.upload_different_file_type
    expect(page).to have_current_path(task_path, ignore_query: true)
  end

  it 'allows user to attach files to tasks from dashboard > add new', attach_files_to_tasks_from_add_new: true, testrail_id: '2698' do
    task_path = task_page.attach_files_to_tasks_from_add_new
    expect(page).to have_current_path(task_path, ignore_query: true)
  end

  def task_page
    @task_page ||= TaskPage.new
  end
end
