# frozen_string_literal: true

require 'spec_helper'
require_relative '../../pages/web/task_workflow_page'

RSpec.describe 'Task workflow', js: true, type: :feature do

  it 'allows users to create a task from bulk get a signature', create_task_from_bulk: true, testrail_id: '2624' do
    task_workflow_page.go_to_bulk_actions
    task_workflow_page.create_task_from_bulk_actions
    expect(page).to have_current_path('/bulksignature')
  end

  it 'allows users to create a task from existing messages', create_task_using_checkbox: true, testrail_id: '2625' do
    task_workflow_page.go_to_home
    task_workflow_page.create_task_using_checkbox
    expect(page).to have_current_path(%r{/inbox/.*}, ignore_query: true)
  end

  it 'allows users to create a task from more options from emails section', create_task_from_emails: true, testrail_id: '2627' do
    task_workflow_page.go_to_emails
    task_workflow_page.create_task_from_emails
    expect(page).to have_current_path('/emails', ignore_query: true)
  end

  it 'allows users to create a task from more options of an existing message card on list', create_task_from_message: true, testrail_id: '2626' do
    task_workflow_page.go_to_home
    task_workflow_page.create_task_from_message
    expect(page).to have_current_path(%r{/inbox/.*}, ignore_query: true)
  end

  it 'allows users to archive an existing task from more option in task details page', archive_task: true, testrail_id: '2694' do
    task_workflow_page.go_to_home
    task_workflow_page.archive_from_task_list
    expect(page).to have_current_path('/')
  end

  it 'allows users to archive an existing task from the task list in tasks section', archive_existing_task: true, testrail_id: '2712' do
    task_workflow_page.go_to_tasks
    task_workflow_page.archive_an_existing_task
    expect(page).to have_current_path('/all_tasks')
  end

  it 'allows users to re-open an archived task', re_open_archived_task: true, testrail_id: '2695' do
    task_workflow_page.go_to_tasks
    current_path = page.current_url
    visit current_path
    task_workflow_path = task_workflow_page.reopen_archived_task
    expect(page).to have_current_path(task_workflow_path, ignore_query: true)
  end

  it 'allows users to create a task from home dashboard', create_task_from_home_dashboard: true, testrail_id: '2617' do
    task_workflow_path = task_workflow_page.create_task_from_home_dashboard

    expect(page).to have_current_path(task_workflow_path, ignore_query: true)
  end

  it 'allows users to create a task from inside task section', create_task_from_task_section: true, testrail_id: '2619' do
    task_workflow_path = task_workflow_page.create_task_from_task_section

    expect(page).to have_current_path(task_workflow_path, ignore_query: true)
  end

  it 'allows users to create a task from accounts > in focus', create_task_from_account_infocus: true, testrail_id: '2620' do
    task_workflow_path = task_workflow_page.create_task_from_account_infocus

    expect(page).to have_current_path(task_workflow_path, ignore_query: true)
  end

  it 'allows users to create a task from accounts > tasks', create_task_from_account: true, testrail_id: '2621' do
    task_workflow_page.go_to_accounts
    task_workflow_path = task_workflow_page.create_task_from_accounts
    expect(page).to have_current_path(task_workflow_path)
  end

  it 'allows users to create a task from existing contact > tasks', create_task_from_contact: true, testrail_id: '2622' do
    task_workflow_page.go_to_contacts
    task_workflow_page.create_task_from_contacts
    expect(page).to have_current_path(%r{/contactdetails/\d+}, ignore_query: true)
  end

  def task_workflow_page
    @task_workflow_page ||= TaskWorkflowPage.new
  end
end
