# frozen_string_literal: true

require 'spec_helper'
require_relative '../../pages/web/email_page'

RSpec.describe 'Email workflow', js: true, type: :feature do
  it 'allow users to be able to open a message and add additional recipients', add_additional_recipients: true, testrail_id: '2509' do
    email_path = email_page.add_additional_recipients
    expect(page).to have_current_path(email_path, ignore_query: true)
  end

  it 'allows users to manually link contacts and accounts auto-associated with an email', association: true, testrail_id: '2537' do
    email_path = email_page.select_first_email_for_testing_association
    expect(page).to have_current_path(email_path, ignore_query: true)
  end

  it 'allows users to manually unlink contacts and accounts auto-associated with an email', unlink_association: true, testrail_id: '2536' do
    email_path = email_page.unlink_association
    expect(page).to have_current_path(email_path, ignore_query: true)
  end

  it 'allows users to manually link accounts and contacts to emails not associated in liscio', link_non_liscio_association: true, testrail_id: '2539' do
    email_path = email_page.link_non_liscio_association
    expect(page).to have_current_path(email_path, ignore_query: true)
  end

  it 'allows users to manually unlink accounts and contacts to emails not associated in liscio', unlink_non_liscio_association: true, testrail_id: '2550' do
    email_path = email_page.unlink_non_liscio_association
    expect(page).to have_current_path(email_path, ignore_query: true)
  end

  it 'ensures dashboard email only pulls google inbox emails', ensure_email_pulls_google: true, testrail_id: '2554' do
    email_page.go_to_email
    email_path = email_page.ensure_email_pull_only_google
    expect(page).to have_current_path(email_path, ignore_query: true)
  end

  it 'allows users to send a new email', new_email: true, testrail_id: '3162' do
    email_page.go_to_email
    email_path = email_page.send_new_email
    expect(page).to have_current_path(email_path, ignore_query: true)
  end

  it 'allows users to send bulk messages with images from bulk actions > send message', send_bulk_messages: true, testrail_id: '3161' do
    email_page.goto_new_message_from_bulk_action
    email_path = email_page.send_messages_with_images
    expect(page).to have_current_path(email_path, ignore_query: true)
  end

  it 'allows users to reply to an email', reply: true, testrail_id: '3164' do
    email_page.go_to_email
    email_path = email_page.reply_an_email
    expect(page).to have_current_path(email_path, ignore_query: true)
  end

  it 'allows users to reply all to an email', reply_all: true, testrail_id: '3165' do
    email_page.go_to_email
    email_path = email_page.reply_all_to_email
    expect(page).to have_current_path(email_path, ignore_query: true)
  end

  it 'allow user to forward an email', forward_email: true, testrail_id: '3166' do
    email_path = email_page.forward_an_email
    expect(page).to have_current_path(email_path, ignore_query: true)
  end

  it 'allow user to forward an email', forward_email: true, testrail_id: '100' do
    email_path = email_page.forward_an_email

    expect(page).to have_current_path(email_path, ignore_query: true)
  end

  describe 'email syncing', email_sync: true do
    it 'ensures received emails in liscio mailbox are in sync with gmail inbox', received_emails: true, testrail_id: '3374' do
      email_page.go_to_email

      email_path = email_page.received_emails_in_lisco_mailbox
      expect(page).to have_current_path(email_path, ignore_query: true)
    end

    it 'ensures gmail and liscio email sent items section are synced', sent_items_section: true, testrail_id: '3375' do
      email_page.go_to_email

      email_path = email_page.sent_items_sync
      expect(page).to have_current_path(email_path, ignore_query: true)
    end

    it 'ensures emails archived in liscio mailbox are in sync with gmail inbox', archived_emails_in_liscio: true, testrail_id: '3376' do
      email_page.go_to_email

      email_path = email_page.archive_an_email
      expect(page).to have_current_path(email_path, ignore_query: true)
    end

    it 'ensures drafts created in liscio mail are in sync with gmail account', create_draft_email: true, testrail_id: '3380' do
      email_page.go_to_email

      email_path = email_page.create_draft
      expect(page).to have_current_path(email_path, ignore_query: true)
    end

    it 'allows users to create draft in liscio mail, and ensure it is in sync with gmail account', create_draft: true, testrail_id: '3381' do
      email_page.go_to_email

      email_path = email_page.create_draft
      expect(page).to have_current_path(email_path, ignore_query: true)
    end

    it 'allows users to filter emails associated with contact', filter_emails: true, testrail_id: '3368' do
      email_path = email_page.filter_emails
      expect(page).to have_current_path(email_path, ignore_query: true)
    end

    it 'allows users to reply to email with Liscio message', reply_email_with_message: true, testrail_id: '3401' do
      email_page.go_to_email
      email_path = email_page.reply_email_with_message
      expect(page).to have_current_path(email_path, ignore_query: true)
    end

    it 'allows users to create "TO DO" task from email.', create_todo_task: true, testrail_id: '3402' do
      email_path = email_page.create_todo_task
      expect(page).to have_current_path(email_path, ignore_query: true)
    end

    it 'allows users to create "REQUEST INFORMATION" task from email.', create_request_info_task: true, testrail_id: '3403' do
      email_path = email_page.create_request_info_task
      expect(page).to have_current_path(email_path, ignore_query: true)
    end

    it 'allows users to create "MANAGE TO GO ITEMS" task from email.', create_manage_items_task: true, testrail_id: '3404' do
      email_page.go_to_email
      email_path = email_page.create_manage_items_task
      expect(page).to have_current_path(email_path, ignore_query: true)
    end

    it 'allows users to create a NOTE from email.', create_note: true, testrail_id: '3410' do
      email_page.go_to_email
      email_path = email_page.create_note
      expect(page).to have_current_path(email_path, ignore_query: true)
    end

    it 'allows users to create "GET A SIGNATURE" task from email.', create_sign_task: true, testrail_id: '3405' do
      email_page.go_to_email
      email_path = email_page.create_sign_task
      expect(page).to have_current_path(email_path, ignore_query: true)
    end

    it 'allows users to ensure contacts and accounts automatically associate with relevant emails', ensure_contact_and_accounts: true, testrail_id: '2535' do
      email_page.go_to_email
      email_path = email_page.ensure_contact_and_accounts
      expect(page).to have_current_path(email_path, ignore_query: true)
    end
  end

  it 'allows user to attach an image to a message', attach_image_to_a_message: true, testrail_id: '2527' do
    email_path = email_page.attach_image_to_a_message
    expect(page).to have_current_path(email_path, ignore_query: true)
  end

  def email_page
    @email_page ||= EmailPage.new
  end
end
