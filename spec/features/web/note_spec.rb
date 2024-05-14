# frozen_string_literal: true

require 'spec_helper'
require_relative '../../pages/web/note_page'

RSpec.describe 'Notes workflow', js: true, type: :feature do
  it 'allow users to be able to create a note from dashboard > add new', create_note_from_add_new: true, testrail_id: '59' do
    note_path = note_page.create_note_from_add_new
    expect(page).to have_current_path(note_path, ignore_query: true)
  end

  it 'allow users to be able to create a note from dashboard > home > inbox list level', create_note_from_dashboard_inbox_list_level: true, testrail_id: '60' do
    note_path = note_page.create_note_from_dashboard_inbox_list_level
    expect(page).to have_current_path(note_path, ignore_query: true)
  end

  it 'allow users to be able to delete a message from other recipients views', delete_message: true, testrail_id: '63' do
    note_path = note_page.delete_message
    expect(page).to have_current_path(note_path, ignore_query: true)
  end

  it 'allow users create a note without duplicates', create_note_without_duplicates: true, testrail_id: '2743' do
    note_path = note_page.create_note_without_duplicates
    expect(page).to have_current_path(note_path, ignore_query: true)
  end

  describe 'create note', create_note: true do
    it 'allow users to create a note from dashboard > home > inbox message level', create_note_from_inbox_message_level: true, testrail_id: '4221' do
      note_path = note_page.create_note_from_inbox_message_level
      expect(page).to have_current_path(note_path, ignore_query: true)
    end

    it 'allow users to create a note from dashboard > home > inbox message thread level', create_note_from_inbox_message_thread_level: true, testrail_id: '4222' do
      note_path = note_page.create_note_from_inbox_message_thread_level
      expect(page).to have_current_path(note_path, ignore_query: true)
    end

    it 'allow users to create a note from dashboard > accounts > notes', create_note_from_account_notes: true, testrail_id: '4223' do
      note_path = note_page.create_note_from_account_notes
      expect(page).to have_current_path(note_path, ignore_query: true)
    end

    it 'allow users to create a note from dashboard > accounts > messages', create_note_from_dashboard_accounts_messages: true, testrail_id: '4224' do
      note_path = note_page.create_note_from_dashboard_accounts_messages
      expect(page).to have_current_path(note_path, ignore_query: true)
    end

    it 'allow users to create a note from dashboard > contacts > notes', create_note_from_dashboard_contacts_notes: true, testrail_id: '4225' do
      note_path = note_page.create_note_from_dashboard_contacts_notes
      expect(page).to have_current_path(note_path, ignore_query: true)
    end

    it 'allow users to create a note from dashboard > contacts > messages', create_note_from_dashboard_contacts_messages: true, testrail_id: '4226' do
      note_path = note_page.create_note_from_dashboard_contacts_messages
      expect(page).to have_current_path(note_path, ignore_query: true)
    end

    it 'allow users to edit note text formatting', edit_note_with_text_formatting: true, testrail_id: '4227' do
      note_path = note_page.edit_note_with_text_formatting
      expect(page).to have_current_path(note_path, ignore_query: true)
    end
  end

  def note_page
    @note_page ||= NotePage.new
  end
end
