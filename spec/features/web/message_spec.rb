# frozen_string_literal: true

require 'spec_helper'
require_relative '../../pages/web/message_page'

RSpec.describe 'Message workflow', js: true, type: :feature do
  it 'ensures users can click the send/create button', send_message: true, testrail_id: '2744' do
    message_page.go_to_inbox

    message_page.send_a_message
    expect(page).to have_current_path('/all_messages')
  end

  it 'ensures recipients displays in the message', verify_recipients: true, testrail_id: '2581' do
    message_page.go_to_inbox

    message_page.verify_recipients_in_message
    expect(page).to have_current_path(%r{/sent/})
  end

  # TODO: add testrail_id
  it 'allows users to save a draft message', saving_draft: true do
    message_page.go_to_inbox
    message_page.draft_message
    expect(page).to have_current_path('/message/new/modal')
  end

  # TODO: add testrail_id
  it 'allows users to archive a message', message_archive: true do
    message_page.go_to_inbox
    message_page.archiving_a_message
    expect(page).to have_current_path(%r{^/sent/.+})
  end

  it 'allow users to be able to click on an alert and be redirected to the correct message recipient', able_to_click_on_an_alert: true, testrail_id: '2512' do
    message_path = message_page.able_to_click_on_an_alert
    expect(page).to have_current_path(message_path, ignore_query: true)
  end

  it 'allows users can create a new message from home screen', home: true, testrail_id: '2515' do
    message_page.go_to_home_page

    message_page.create_new_message('subject_headline', 'body')

    expect(page).to have_current_path('/message/new', ignore_query: true)
    expect(page).not_to have_selector('.modal-dialog')
  end

  it 'allows users can create a new message from inbox screen', inbox: true, testrail_id: '2516' do
    message_page.go_to_home_page

    message_page.create_new_message_from_home_screen('subject_headline', 'body')

    expect(page).to have_current_path('/all_messages')
    expect(page).not_to have_selector('.modal-dialog')
  end

  it 'allows users can create a new message from account screen', account: true, testrail_id: '2517' do
    message_page.go_to_home_page

    path = message_page.create_new_message_from_account_screen('subject_headline', 'body')

    expect(page).to have_current_path(path, ignore_query: true)
    expect(page).not_to have_selector('.modal-dialog')
  end

  it 'allows users can create a new message from contact detail screen', contact_detail: true, testrail_id: '2518' do
    message_page.go_to_home_page

    path = message_page.create_new_message_from_contact_detail_screen('subject_headline', 'body')

    expect(page).to have_current_path(path, ignore_query: true)
    expect(page).not_to have_selector('.modal-dialog')
  end

  it 'allows users can create a new message from contact message screen', contact_message: true, testrail_id: '2519' do
    message_page.go_to_home_page

    path = message_page.create_new_message_from_contact_message_screen('subject_headline', 'body')

    expect(page).to have_current_path(path, ignore_query: true)
    expect(page).not_to have_selector('.modal-dialog')
  end

  it 'allows users to reply and add another recipient to a thread from contacts > messages', add_another_recipient_to_a_thread_from_contact_messages: true, testrail_id: '2520' do
    message_path = message_page.add_another_recipient_to_a_thread_from_contact_messages
    expect(page).to have_current_path(message_path, ignore_query: true)
  end

  it 'allows users can reate a new message from bulk action screen', bulk_action: true, testrail_id: '2521' do
    message_page.go_to_home_page

    message_page.create_new_message_from_bulk_action('subject_headline', 'body')

    expect(page).to have_current_path('/bulkmessage')
  end

  it 'allows users to delete a message from other recipients views', other_recipients_views: true, testrail_id: '63' do
    message_page.go_to_home_page
    message_path = message_page.delete_a_message
    expect(page).to have_current_path(message_path, ignore_query: true)
  end

  it 'allow users to be able to mark a message as unread from dashboard > home', mark_as_unread: true, testrail_id: '51' do
    message_path = message_page.mark_message_unread
    expect(page).to have_current_path(message_path, ignore_query: true)
  end

  it 'allow users to be able to mark a message as unread from dashboard > inbox list level', mark_as_unread_from_inbox: true, testrail_id: '52' do
    message_path = message_page.mark_message_unread_inbox
    expect(page).to have_current_path(message_path, ignore_query: true)
  end

  it 'allow users to be able to mark a message as unread from the thread level', mark_as_unread_thread_level: true, testrail_id: '53' do
    message_path = message_page.mark_message_thread_level
    expect(page).to have_current_path(message_path, ignore_query: true)
  end

  it 'allow users to be able to mark a message as unread from the message level', mark_as_unread_message_level: true, testrail_id: '54' do
    message_path = message_page.mark_unread_from_message_level
    expect(page).to have_current_path(message_path, ignore_query: true)
  end

  describe 'Search bar', search_bar: true do
    it 'allow users to be able to search title of the message in inbox', search_title_in_inbox: true, testrail_id: '47' do
      message_path = message_page.search_title_in_inbox
      expect(page).to have_current_path(message_path, ignore_query: true)
    end

    it 'allow users to be able to search the description of the message in inbox', search_description_in_inbox: true, testrail_id: '48' do
      message_path = message_page.search_description_in_inbox
      expect(page).to have_current_path(message_path, ignore_query: true)
    end

    it 'allow users to be able search with invalid title and get there is no result found', invalid_title_search: true, testrail_id: '49' do
      message_path = message_page.invalid_title_search
      expect(page).to have_current_path(message_path, ignore_query: true)
    end

    it 'allow users to be able search with invalid description and get there is no result found', invalid_description_search: true, testrail_id: '50' do
      message_path = message_page.invalid_description_search
      expect(page).to have_current_path(message_path, ignore_query: true)
    end

    it 'allow users to be able to see all messages in inbox when the search bar is blank', list_all_messages_when_search_bar_is_blank: true, testrail_id: '4151' do
      message_path = message_page.list_all_messages_when_search_bar_is_blank
      expect(page).to have_current_path(message_path, ignore_query: true)
    end

    it 'allow users to be able search as a client with invalid description and get there is no result found', invalid_description_search: true, testrail_id: '4191' do
      message_path = message_page.invalid_description_search_as_client
      expect(page).to have_current_path(message_path, ignore_query: true)
    end

    it 'allow users to be able to see all messages as a client in inbox when the search bar is blank', list_all_messages_when_search_bar_is_blank: true, testrail_id: '4192' do
      message_path = message_page.all_messages_as_client_with_blank_search_bar
      expect(page).to have_current_path(message_path, ignore_query: true)
    end

    it 'allow users to be able to print a Message from Inbox > Print button', print_message: true, testrail_id: '4543' do
      skip 'until interacted with chrome print modal'
      message_path = message_page.print_message_from_messages
      expect(page).to have_current_path(message_path, ignore_query: true)
    end

    it 'allow users to be able to print a Message from CONTACTS > MESSAGES then Print button', print_message_from_contacts: true, testrail_id: '4544' do
      skip 'until interacted with chrome print modal'
      message_path = message_page.print_message_from_contacts
      expect(page).to have_current_path(message_path, ignore_query: true)
    end

    it 'allow users to be able to print a Message from ACCOUNTS > MESSAGES then Print button', print_message_from_accounts: true, testrail_id: '4545' do
      skip 'until interacted with chrome print modal'
      message_path = message_page.print_message_from_accounts
      expect(page).to have_current_path(message_path, ignore_query: true)
    end

    it 'allows client user to search title of the message in inbox', client_searches_for_title: true, testrail_id: '4188' do
      message_path = message_page.client_searches_for_title
      expect(page).to have_current_path(message_path, ignore_query: true)
    end

    it 'allows client user to not search the title of the message in inbox if there is no result found', client_searches_for_invalid_title: true, testrail_id: '4189' do
      message_path = message_page.client_searches_for_invalid_title
      expect(page).to have_current_path(message_path, ignore_query: true)
    end

    it 'allows client user to search the description of the message in inbox', client_searches_for_description: true, testrail_id: '4190' do
      message_path = message_page.client_searches_for_description
      expect(page).to have_current_path(message_path, ignore_query: true)
    end
  end

  describe 'Create task from inbox', create_tasks_from_inbox: true do
    it 'allows firm users to create manage to go items task in a message from inbox > message level ellipses', create_manage_to_go_items_from_inbox_list: true, testrail_id: '4241' do
      message_path = message_page.create_manage_to_go_items_from_inbox_list
      expect(page).to have_current_path(message_path, ignore_query: true)
    end

    it 'allows firm users to create manage to go items task in a message from inbox > thread level button', create_manage_to_go_items_from_inbox_thread_level: true, testrail_id: '4242' do
      message_path = message_page.create_manage_to_go_items_from_inbox_thread_level
      expect(page).to have_current_path(message_path, ignore_query: true)
    end

    it 'allows firm users to create task and edit subject in message from inbox', edit_subject_in_message: true, testrail_id: '4243' do
      message_path = message_page.edit_subject_in_message
      expect(page).to have_current_path(message_path, ignore_query: true)
    end

    it 'allows firm users to create to do task in a message from inbox > list level ellipses', create_to_do_from_inbox_list_level_ellipses: true, testrail_id: '4228' do
      message_path = message_page.create_to_do_from_inbox_list_level_ellipses
      expect(page).to have_current_path(message_path, ignore_query: true)
    end

    it 'allows firm user to create to do task in a message from inbox > message level ellipses', create_to_do_from_message_level_ellipses: true, testrail_id: '4229' do
      message_path = message_page.create_to_do_from_message_level_ellipses
      expect(page).to have_current_path(message_path, ignore_query: true)
    end

    it 'allows firm user to create to do task in a message from inbox > thread level button', create_to_do_from_inbox_thread_level_button: true, testrail_id: '4230' do
      message_path = message_page.create_to_do_from_inbox_thread_level_button
      expect(page).to have_current_path(message_path, ignore_query: true)
    end

    it 'allows firm user to create request information task in a message from inbox > list level ellipses', create_request_information_task_from_inbox_list_level_ellipses: true, testrail_id: '4231' do
      message_path = message_page.create_request_information_task_from_inbox_list_level_ellipses
      expect(page).to have_current_path(message_path, ignore_query: true)
    end

    it 'allows firm user to create request information task in a message from inbox > message level ellipses', create_request_information_task_from_message_level_ellipses: true, testrail_id: '4232' do
      message_path = message_page.create_request_information_task_from_message_level_ellipses
      expect(page).to have_current_path(message_path, ignore_query: true)
    end

    it 'allows firm user to create request information task in a message from inbox > thread level button', create_request_information_from_inbox_thread_level_button: true, testrail_id: '4233' do
      message_path = message_page.create_request_information_from_inbox_thread_level_button
      expect(page).to have_current_path(message_path, ignore_query: true)
    end

    it 'allows firm user to create meeting task in a message from inbox > list level ellipses', create_meeting_task_from_list_level_ellipses: true, testrail_id: '4234' do
      message_path = message_page.create_meeting_task_from_list_level_ellipses
      expect(page).to have_current_path(message_path, ignore_query: true)
    end

    it 'allows firm user to create meeting task in a message from inbox > message level ellipses', create_meeting_task_from_message_level_ellipses: true, testrail_id: '4235' do
      message_path = message_page.create_meeting_task_from_message_level_ellipses
      expect(page).to have_current_path(message_path, ignore_query: true)
    end

    it 'allows firm user to create meeting task in a message from inbox > thread level button', create_meeting_task_from_thread_level_button: true, testrail_id: '4236' do
      message_path = message_page.create_meeting_task_from_thread_level_button
      expect(page).to have_current_path(message_path, ignore_query: true)
    end
  end

  it 'allows users to view all messages then filter messages by created view', view_all_filter_messages: true, testrail_id: '2510' do
    message_path = message_page.view_all_filter_messages
    expect(page).to have_current_path(message_path, ignore_query: true)
  end

  it 'allows users to set up a new firm employee', setup_new_employee: true, testrail_id: '2574' do
    skip 'Until SMS enabled for adnan@liscio.me account'
    message_path = message_page.setup_new_employee
    expect(page).to have_current_path(message_path, ignore_query: true)
  end

  it 'allows users to set up a firm employee for SMS using the desktop dashbaord', setup_new_employee_for_sms: true, testrail_id: '2575' do
    skip 'Until SMS enabled for adnan@liscio.me account'
    message_path = message_page.setup_new_employee_for_sms
    expect(page).to have_current_path(message_path, ignore_query: true)
  end

  it 'allows users to create Get a Signature task in a Message from Inbox > list level ellipses', list_level_ellipses: true, testrail_id: '4237' do
    message_path = message_page.list_level_ellipses
    expect(page).to have_current_path(message_path, ignore_query: true)
  end

  it 'allows users to create Get a Signature task in a Message from Inbox > Message level ellipses', message_level_ellipses: true, testrail_id: '4238' do
    message_path = message_page.message_level_ellipses
    expect(page).to have_current_path(message_path, ignore_query: true)
  end

  it 'allows users to create Get a Signature task in a Message from Inbox > Thread level button', thread_level_button: true, testrail_id: '4239' do
    message_path = message_page.message_level_ellipses
    expect(page).to have_current_path(message_path, ignore_query: true)
  end

  it 'allows users to create Manage To Go Items task in a Message from Inbox > list level ellipses', manage_item_task_in_message: true, testrail_id: '4240' do
    message_path = message_page.manage_item_task_in_message
    expect(page).to have_current_path(message_path, ignore_query: true)
  end

  def message_page
    @message_page ||= MessagePage.new
  end
end
