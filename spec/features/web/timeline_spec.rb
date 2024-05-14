# frozen_string_literal: true

require 'spec_helper'
require_relative '../../pages/web/timeline_page'

RSpec.describe 'Timeline', js: true, type: :feature do
  it 'ensures all messages automatically reflected in contacts timeline', sync_messages_contacts_from_messages: true, testrail_id: '3340' do
    timeline_page.go_to_message
    timeline = timeline_page.sync_messages_contacts
    expect(page).to have_current_path(timeline, ignore_query: true)
  end

  it 'ensures user can see all emails automatically reflected in contacts timeline', sync_messages_contacts_from_messages: true, testrail_id: '3341' do
    timeline_page.go_to_message
    timeline = timeline_page.sync_messages_contacts
    expect(page).to have_current_path(timeline, ignore_query: true)
  end

  it 'ensures user can see all the reply messages automatically reflected in the contacts timeline', sync_messages_contacts_from_messages: true, testrail_id: '3342' do
    timeline_page.go_to_message
    timeline = timeline_page.sync_messages_contacts
    expect(page).to have_current_path(timeline, ignore_query: true)
  end

  it 'ensures tasks automatically reflected in contacts timeline', sync_messages_contacts_from_tasks: true, testrail_id: '3343' do
    timeline_page.go_to_task
    timeline = timeline_page.sync_messages_from_tasks
    expect(page).to have_current_path(timeline, ignore_query: true)
  end

  it 'ensures file uploads automatically reflected in contacts timeline', sync_messages_contacts_from_files: true, testrail_id: '3344' do
    timeline_page.go_to_files
    timeline = timeline_page.sync_messages_from_files
    expect(page).to have_current_path(timeline, ignore_query: true)
  end

  it 'ensures user can see all messages automatically reflected in accounts timeline', sync_messages_contacts_from_account: true, testrail_id: '3357' do
    timeline_page.go_to_message
    timeline = timeline_page.sync_messages_contacts
    expect(page).to have_current_path(timeline, ignore_query: true)
  end

  it 'ensures user can see all messages automatically reflected in accounts timeline', sync_messages_contacts_from_account: true, testrail_id: '3358' do
    timeline_page.go_to_message
    timeline = timeline_page.sync_messages_contacts
    expect(page).to have_current_path(timeline, ignore_query: true)
  end

  it 'ensures user can see all the reply messages automatically reflected in the accounts timeline', sync_messages_contacts_from_account: true, testrail_id: '3359' do
    timeline_page.go_to_files
    timeline = timeline_page.sync_messages_from_files
    expect(page).to have_current_path(timeline, ignore_query: true)
  end

  it 'ensures user can see all the tasks automatically reflected in accounts timeline', sync_messages_contacts_from_account: true, testrail_id: '3360' do
    timeline_page.go_to_task
    timeline = timeline_page.sync_messages_from_tasks
    expect(page).to have_current_path(timeline, ignore_query: true)
  end

  it 'ensures user can see all file uploads automatically reflected in accounts timeline', sync_messages_contacts_from_account: true, testrail_id: '3361' do
    timeline_page.go_to_files
    timeline = timeline_page.sync_messages_from_files
    expect(page).to have_current_path(timeline, ignore_query: true)
  end

  it 'ensures user can see all notes automatically reflected in accounts timeline', sync_messages_contacts_from_account: true, testrail_id: '3361' do
    timeline_page.go_to_message
    timeline = timeline_page.sync_messages_contacts
    expect(page).to have_current_path(timeline, ignore_query: true)
  end

  it 'ensures all notes automatically reflected in Accounts Timeline', ensure_notes_reflected: true, testrail_id: '3362' do
    timeline_page.go_to_message
    timeline = timeline_page.ensure_notes_reflected
    expect(page).to have_current_path(timeline, ignore_query: true)
  end


  def timeline_page
    @timeline_page ||= TimelinePage.new
  end
end
