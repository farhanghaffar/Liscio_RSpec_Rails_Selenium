# frozen_string_literal: true

require 'spec_helper'
require_relative '../../pages/mobile/message_page'

RSpec.describe 'Message Workflow', js: true, type: :feature do
  it 'allows mobiles users to send/create a message', send_message: true do
    message_page.go_to_inbox

    message_page.send_a_message('Test message')
    expect(page).to have_current_path('/messages/list')
  end

  it 'verifies recipients should display in the message', verify_recipients: true do
    message_page.go_to_inbox

    message_path = message_page.verify_recipients_in_message
    expect(message_path).to match(%r{/messages/details/.*})
  end

  it 'allows mobile users to send a message with attachment', send_message_with_attachment: true do
    message_page.go_to_inbox

    message_page.send_message_with_attachment
    expect(page).to have_current_path('/messages/list')
  end

  it 'allows mobile users to save a draft message', saving_draft: true do
    message_page.go_to_inbox
    message_page.draft_message
    expect(page).to have_current_path(page.current_path)

  end

  it 'allows mobile users to archive a message', message_archive: true do
    message_page.go_to_inbox
    message_page.archiving_a_message
    expect(page).to have_current_path('/messages/list')
  end

  def message_page
    @message_page ||= MessagePage.new
  end
end
