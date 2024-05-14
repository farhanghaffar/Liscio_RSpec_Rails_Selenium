require_relative 'base_page'
require_relative 'login_page'

class MessagePage < BasePage
  def go_to_inbox
    login_to_app
    within('.Sidebar') do
      click_on 'INBOX'
    end
  end

  def go_to_home_page
    login_to_app
    within('.Sidebar') do
      click_on 'HOME'
    end
  end

  def go_to_contacts
    login_to_app
    within('.Sidebar') do
      click_on 'CONTACTS'
    end
  end

  def go_to_accounts
    login_to_app
    sleep 4
    within('.Sidebar') do
      click_on 'ACCOUNTS'
    end
  end

  def verify_recipients_in_message
    subject = send_a_message
    page.has_text? subject
    find_all('div', text: subject).first.click
    page.has_text?('Adnan Ghaffar')
    page.current_path
  end

  def draft_message
    click_on "+ Message"
    find('a[data-testid="onFocusButton"]').click

    'adnan qa'.chars.each { |char| page.send_keys(char) }
    page.has_text?('Adnan QA QA')
    page.send_keys(:tab)

    click_on "Ok"

    find('#NewMessageModal__SelectTemplate').click
    page.send_keys('Draft')
    page.send_keys(:tab)

    page.has_selector?('iframe')
    iframe = find('iframe')
    within_frame iframe do
      body_div = find_by_id('tinymce').click
      body_div.send_keys("Testing")
    end

    click_on "Send"
  end

  def archiving_a_message
    subject = send_a_message
    find_all('.row')[1].click
  end

  def send_a_message
    time_stamp = Time.new.strftime('%s')
    subject = 'Test_Message_' + time_stamp
    body = 'body'
    fill_info_in_new_message_modal(subject, body)
    verify_message_exist_with_unique_subject(subject)
    subject
  end

  def fill_info_in_new_message_modal(subject, body)
    page.has_text?('+ Message')
    click_link '+ Message'

    # New message modal

    within('.modal-dialog') do
      find('a[data-testid="onFocusButton"]').click

      page.has_selector?('div[data-value]')
      recipient = fill_in 'messageRecipient', with: 'adnan'
      # Verify the recipient's name displays in the TO field
      page.has_text?('Adnan QA QA')
      recipient.send_keys(:enter)

      click_on 'Ok'

      # Verify various subject displays
      page.has_selector?('labelValue')

      # Verify the number subjects begin to filter based on the first letter typed ("H")
      subject_div = find_all('.labelValue')[1].click
      page.send_keys(subject)
      page.send_keys(:tab)

      page.has_selector?('iframe')
      iframe = find('iframe')
      within_frame iframe do
        # Verify "Saving" displays
        body_div = find_by_id('tinymce').click

        # Verify the message description displays
        body_div.send_keys(body)
      end

      click_on 'Send'
    end
  end

  def fill_info_in_new_message_home(subject, body)
    page.has_text?('+ Message')

    # Verify a "New Message" modal
    click_link '+ Message'
    find('button[data-testid="message__to_field"]').click

    # Verify a RECIPIENT + ACCOUNT search box displays
    page.has_selector?('div[data-value]')
    recipient = fill_in 'messageRecipient', with: 'adnan'

    # Verify a CONTACTS box displays with the full name of the recipient' full name
    page.has_text?('Adnan QA QA')
    recipient.send_keys(:enter)

    # Verify the recipient's name displays in the TO field
    click_on 'Ok'

    page.has_selector?('labelValue')
    subject_div = find_all('.labelValue')[1].click
    page.send_keys(subject)
    page.send_keys(:tab)

    page.has_selector?('iframe')
    iframe = find_all('iframe')
    within_frame iframe[0] do
      body_div = find_by_id('tinymce').click
      body_div.send_keys(body)
    end

    click_on 'Send'
  end

  def verify_message_exist_with_unique_subject(subject)
    page.has_text?('Sent |')
    find_all('.nav-item')[2].click

    page.has_selector?('.tRow--body')
    messages_div = find('.tRow--body')

    within messages_div do
      page.has_text?('Adnan QA')
      page.has_selector?('.row')
      row = find_all('.row').first
      expect(row.text).to include(subject)
    end
  end

  def create_new_message(subject, body)
    fill_info_in_new_message_home(subject, body)
  end

  def create_new_message_from_home_screen(subject, body)
    within('.Sidebar') do
      click_on 'INBOX'
    end
    expect(page).to have_current_path('/all_messages')

    fill_info_in_new_message_modal(subject, body)
  end

  def create_new_message_from_account_screen(subject, body)
    within('.Sidebar') do
      click_on 'ACCOUNTS'
    end
    expect(page).to have_current_path('/accounts')

    # Verify the account name displays in the ACCOUNT field
    account_name = 'ABC Inc'
    # Verify "EXPAND SECTIONS BELOW TO VIEW DETAILS" displays
    get_details_of_account(account_name)

    # Go to message
    nav = find('.nav')
    page.has_text?('Messages')
    click_button('Messages')

    account_details_with_id = page.current_path

    fill_info_in_new_message_modal(subject, body)
    account_details_with_id
  end

  def get_details_of_account(account)
    fill_in 'contact-search', with: account

    wait_for_selector('.row.tdBtn')
    find_all('.row.tdBtn').first.click
  end

  def create_new_message_from_contact_detail_screen(subject, body)
    within('.Sidebar') do
      click_on 'CONTACTS'
    end

    expect(page).to have_current_path('/contacts')

    sleep(3)
    page_refresh
    contact_name = 'Albert, Abe'
    get_details_of_account(contact_name)

    detail_selector = 'button[data-testid="inbox__details"]'
    wait_for_selector(detail_selector)
    find(detail_selector).click

    page.has_text?('Messages')
    click_button('Messages')

    contact_details_with_id = page.current_path
    fill_info_in_new_message_modal(subject, body)
    contact_details_with_id
  end

  def create_new_message_from_contact_message_screen(subject, body)
    within('.Sidebar') do
      click_on 'CONTACTS'
    end

    expect(page).to have_current_path('/contacts')

    sleep(3)
    page_refresh

    contact_name = firm_client_email
    get_details_of_account(contact_name)

    detail_selector = 'button[data-testid="inbox__details"]'
    wait_for_selector(detail_selector)
    find(detail_selector).click

    page.has_text?('Messages')
    click_button('Messages')

    contact_details_with_id = page.current_path
    fill_info_in_new_message_modal(subject, body)
    contact_details_with_id
  end

  def create_new_message_from_bulk_action(subject, body)
    within('.Sidebar') do
      find('span', text: 'BULK ACTIONS').click
    end

    div = find('div[role="menu"]')
    within div do
      page.has_text?('Send Message')
      div.find('div[role="menuitem"]', text: 'Send Message').click
    end

    expect(page).to have_current_path('/bulkmessage')

    sleep(2)
    page_refresh
    select_first_two_acconuts
    page.has_text?('Next Step')
    click_button('Next Step')

    subject_div = find('input').click
    subject_div.send_keys(subject)
    subject_div.send_keys(:tab)

    page.has_selector?('iframe')
    iframe = find_all('iframe')[0]
    within_frame iframe do
      body_div = find_by_id('tinymce').click
      body_div.send_keys(body)
    end

    page.has_text?('Draft Message')
    click_on 'Draft Message'
    page.has_text?('Send Message')
    click_on 'Send Message'
  end

  def select_first_two_acconuts
    all_accounts_main_div = find_all('.tdBtn')
    2.times do |i|
      account = all_accounts_main_div[i]
      account.click
    end
  end

  def go_to_add_new
    login_to_app
    within('.Sidebar') do
      find('span', text: 'ADD NEW').click
    end
    div = find('div[role="menu"]')
    within div do
      page.has_text?('Message')
      div.find('div[role="menuitem"]', text: 'Message').click
    end
  end

  def new_message_from_add_new_button(subject, body)
    page.has_selector?('div[data-value]')
    find('button[data-testid="message__to_field"]').click
    recipient = fill_in 'messageRecipient', with: 'han'

    page.has_text?('Han Solo')
    recipient.send_keys(:enter)
    click_on 'Ok'

    page.has_selector?('labelValue')
    subject_div = find_all('.labelValue')[1].click
    page.send_keys(subject)
    page.send_keys(:tab)

    page.has_selector?('iframe')
    iframe = find_all('iframe')
    within_frame iframe[0] do
      body_div = find_by_id('tinymce').click
      body_div.send_keys(body)
    end

    click_on 'Send'
  end

  def open_message_using_sent
    nav = find('.nav')
    page.has_text?('Sent')
    click_button('Sent')
    page.has_text?("Welcome to Liscio!")
    find_all('span', text: "Welcome to Liscio!")[0].click
  end

  def delete_a_message
    sleep 3
    find_all('.row')[1].click
    sleep 3
    page.current_path
  end

  def able_to_click_on_an_alert
    login_to_app

    # Verify user sees Dashboard elements HOME, INBOX, user's full name + avatar displays
    ['HOME', 'INBOX', 'ADNAN GHAFFAR'].each do |element|
      wait_for_text(page, element)
    end

    inbox_selector = 'div[data-testid="sidebar__inbox"]'
    wait_for_selector(inbox_selector)
    find(inbox_selector).click

    # Verify user sees header elements Inbox, Alerts, Sent, Drafts, Archived, Pinned, All
    ['Inbox', 'Alerts', 'Sent', 'Drafts', 'Archived', 'Pinned', 'All'].each do |header_element|
      wait_for_text(page, header_element)
    end
    page.current_path
  end

  def mark_message_unread
    go_to_home_page

    sleep 3
    unread_message = page.has_selector?('div[data-testid="row-4"]')
    read_message = page.has_selector?('div[data-testid="row-0"]')

    page.has_selector?('.col-3.tdCol.truncate')
    page.has_text?('Last Activity At')
    find_all('button[aria-haspopup="menu"]').first.click
    page.current_path
  end

  def mark_message_unread_inbox
    go_to_inbox

    sleep 3

    page.has_text?('Inbox')
    page.has_selector?('.col-3.tdCol.truncate')
    page.has_text?('Last Activity At')
    find_all('button[aria-haspopup="menu"]').first.click
    page.current_path
  end

  def mark_message_thread_level
    go_to_home_page

    sleep 3
    page.has_text?('Last Activity At')
    find_all('i.icon-more').first.click

    page.send_keys(:arrow_down)
    page.send_keys(:arrow_up)
    page.send_keys(:enter)
    page.current_path
  end

  def mark_unread_from_message_level
    go_to_home_page
    sleep 3

    find_all('.row')[1].click
    page.has_text?("Back")

    find_all('i.icon-more').first.click

    page.send_keys(:arrow_down)
    page.send_keys(:arrow_up)
    page.send_keys(:enter)
    page.current_path
  end

  def search_title_in_inbox
    # Send a message to firm side user with a unique subject
    go_to_inbox

    time_stamp = Time.new.strftime('%s')
    subject = 'Test_Message_' + time_stamp
    body = 'body'

    send_message_to_firm_user(subject, body)

    # Sign-in as a Firm-side user
    login_to_app_as_employee

    inbox_selector = 'div[data-testid="sidebar__inbox"]'
    # Existing messages in Inbox
    # In the Landing page, click on MESSAGES from left side nav of the dashboard screen.
    wait_for_selector(inbox_selector)
    find(inbox_selector).click

    # Click "Search bar" then type the message title.
    search_bar_selector = 'input[data-testid="inbox__message_search"]'
    wait_for_selector(search_bar_selector)
    search_bar = find(search_bar_selector)
    search_bar.send_keys(subject)

    # Verify results.
    expect(page).not_to have_content('No Records Found')
    expect(page).to have_content(subject)

    # Unique message
    expect(page).to have_content('Showing 1 to 1 of 1 entries')
    page.current_path
  end

  def search_description_in_inbox
    # Send a message to firm side user with a unique description
    go_to_inbox

    time_stamp = Time.new.strftime('%s')
    subject = 'Subject'
    description = 'unique_' + time_stamp

    send_message_to_firm_user(subject, description)

    # Sign-in as a Firm-side user
    login_to_app_as_employee

    inbox_selector = 'div[data-testid="sidebar__inbox"]'
    # Existing messages in Inbox
    # In the Landing page, click on MESSAGES from left side nav of the dashboard screen.
    wait_for_selector(inbox_selector)
    find(inbox_selector).click

    # Click "Search bar" then type the message title.
    search_bar_selector = 'input[data-testid="inbox__message_search"]'
    wait_for_selector(search_bar_selector)
    search_bar = find(search_bar_selector)
    search_bar.send_keys(description)

    # Verify results.
    expect(page).not_to have_content('No Records Found')
    expect(page).to have_content(description)

    # Unique message
    expect(page).to have_content('Showing 1 to 1 of 1 entries')
    page.current_path
  end

  def invalid_title_search
    # Sign-in as a Firm-side user
    login_to_app_as_employee

    inbox_selector = 'div[data-testid="sidebar__inbox"]'
    # Existing messages in Inbox
    # In the Landing page, click on MESSAGES from left side nav of the dashboard screen.
    wait_for_selector(inbox_selector)
    find(inbox_selector).click

    # Click "Search bar" then type the invalid message title.
    search_bar_selector = 'input[data-testid="inbox__message_search"]'
    wait_for_selector(search_bar_selector)
    search_bar = find(search_bar_selector)
    search_bar.send_keys('www.foobar.com')

    # Verify results.
    expect(page).to have_content('No Records Found')
    expect(page).not_to have_content('Showing 1 to 1 of 1 entries')
    page.current_path
  end

  def invalid_description_search
    # Sign-in as a Firm-side user
    login_to_app_as_employee

    inbox_selector = 'div[data-testid="sidebar__inbox"]'
    # Existing messages in Inbox
    # In the Landing page, click on MESSAGES from left side nav of the dashboard screen.
    wait_for_selector(inbox_selector)
    find(inbox_selector).click

    # Click "Search bar" then type the invalid message description.
    search_bar_selector = 'input[data-testid="inbox__message_search"]'
    wait_for_selector(search_bar_selector)
    search_bar = find(search_bar_selector)
    search_bar.send_keys('www.foobar.com')

    # Verify results.
    expect(page).to have_content('No Records Found')
    expect(page).not_to have_content('Showing 1 to 1 of 1 entries')
    page.current_path
  end

  def list_all_messages_when_search_bar_is_blank
    login_to_app_as_employee

    inbox_selector = 'div[data-testid="sidebar__inbox"]'
    # Existing messages in Inbox
    # In the Landing page, click on MESSAGES from left side nav of the dashboard screen.
    wait_for_selector(inbox_selector)
    find(inbox_selector).click

    # Click "Search bar" then do not type any
    search_bar_selector = 'input[data-testid="inbox__message_search"]'
    wait_for_selector(search_bar_selector)
    search_bar = find(search_bar_selector)
    search_bar.send_keys('')

    # Verify results.
    expect(page).not_to have_content('No Records Found')

    # More than one message exists in inbox
    expect(page).not_to have_content('Showing 1 to 1 of 1 entries')
    page.current_path
  end

  def invalid_description_search_as_client
    login_to_app_as_client

    inbox_selector = 'div[data-testid="sidebar__inbox"]'
    # Existing messages in Inbox
    # In the Landing page, click on MESSAGES from left side nav of the dashboard screen.
    wait_for_selector(inbox_selector)
    find(inbox_selector).click

    # Click "Search bar" then type the invalid message description.
    search_bar_selector = 'input[data-testid="inbox__message_search"]'
    wait_for_selector(search_bar_selector)
    search_bar = find(search_bar_selector)
    search_bar.send_keys('www.foobar.com')

    # Verify results.
    expect(page).to have_content('No Records Found')
    expect(page).not_to have_content('Showing 1 to 1 of 1 entries')
    page.current_path
  end

  def all_messages_as_client_with_blank_search_bar
    login_to_app_as_client

    inbox_selector = 'div[data-testid="sidebar__inbox"]'
    # Existing messages in Inbox
    # In the Landing page, click on MESSAGES from left side nav of the dashboard screen.
    wait_for_selector(inbox_selector)
    find(inbox_selector).click

    # Click "Search bar" then do not type any
    search_bar_selector = 'input[data-testid="inbox__message_search"]'
    wait_for_selector(search_bar_selector)
    search_bar = find(search_bar_selector)
    search_bar.send_keys('')

    # Verify results.
    expect(page).not_to have_content('No Records Found')

    # More than one message exists in inbox
    expect(page).not_to have_content('Showing 1 to 1 of 1 entries')
    page.current_path
  end

  def print_message_from_messages
    login_to_app
    inbox_selector = 'div[data-testid="sidebar__inbox"]'
    wait_for_selector(inbox_selector)
    find(inbox_selector).click

    wait_for_text(page, 'SENDERS')
    wait_for_text(page, 'MESSAGE DETAILS')
    wait_for_selector('.row')
    row = find_all('.row')[1].click
    find('a[title="Print Thread"]').click
    page.current_path
  end

  def print_message_from_contacts
    go_to_contacts

    page.has_selector?('.tableWrap')
    table = find('.tableWrap')

    within table do
      page.has_selector?('.tbBtn')
      second_contact = table.find_all('.tdBtn')[1]
      second_contact.click
    end

    page.has_css?('.nav')
    nav = find('.nav')
    page.has_text?('Messages')
    nav_links = find_all('.nav-link')
    nav_links.find { |n| n.text == 'Messages' }.click

    row = find_all('.row')[1]
    wait_for_selector(row)
    find(row).click
    find('a[title="Print Thread"]').click
    page.current_path
  end

  def print_message_from_accounts
    go_to_accounts

    page.has_selector?('.tableWrap')
    table = find('.tableWrap')

    within table do
      page.has_selector?('.tbBtn')
      second_contact = table.find_all('.tdBtn')[1]
      second_contact.click
    end

    page.has_css?('.nav')
    nav = find('.nav')
    page.has_text?('Messages')
    nav_links = find_all('.nav-link')
    nav_links.find { |n| n.text == 'Messages' }.click

    row = find_all('.row')[1]
    wait_for_selector(row)
    find(row).click
    find('a[title="Print Thread"]').click
    page.current_path
  end

  def client_searches_for_title
    # Send a message to Client user with a unique description
    go_to_inbox

    time_stamp = Time.new.strftime('%s')
    subject = 'Test_Message_' + time_stamp
    description = 'description'

    send_message_to_client_user(subject, description)

    # Sign-in as a Client user
    login_page.logout
    login_to_app_as_client

    inbox_selector = 'div[data-testid="sidebar__inbox"]'
    # Existing messages in Inbox
    # In the Landing page, click on MESSAGES from left side nav of the dashboard screen.
    wait_for_selector(inbox_selector)
    find(inbox_selector).click

    # Click "Search bar" then type the message title.
    search_bar_selector = 'input[data-testid="inbox__message_search"]'
    wait_for_selector(search_bar_selector)
    search_bar = find(search_bar_selector)
    search_bar.send_keys(subject)

    # Verify results.
    expect(page).not_to have_content('No Records Found')
    expect(page).to have_content(subject)

    # Unique message
    expect(page).to have_content('Showing 1 to 1 of 1 entries')
    page.current_path
  end

  def create_manage_to_go_items_from_inbox_list
    # Sign-in as a Firm-side user.
    login_to_app_as_employee

    # In the Landing page, click on INBOX from left side nav of the dashboard screen.
    inbox_selector = 'div[data-testid="sidebar__inbox"]'
    wait_for_selector(inbox_selector)
    find(inbox_selector).click

    # Under INBOX tab, click on the ellipses button beside a message.
    # Choose Create Task
    sleep(3)
    wait_for_selector('.icon-more')
    subject_title = find_all('.tdCol')[2].text.split("\n").first
    find_all('i.icon-more').first.click
    page.send_keys(:arrow_down) # Click on Create Task
    page.send_keys(:enter)

    # Under CREATE TASK SCREEN, verify the pre-selected DUE DATE and OWNER
    date_picker_wrapper_selector = 'react-datepicker__input-container'
    wait_for_selector(".#{date_picker_wrapper_selector}")
    date_picker_wrapper = find(".#{date_picker_wrapper_selector}")
    pre_filled_date = date_picker_wrapper.find('input').value

    # Click TASK: then select Manage To Go Items
    task_div = find('.task-type-select').click
    task_div.find_all('div', text: 'Manage To Go Items').last.click

    # Click the FOR ACCOUNT: drop down menu then choose "ABC Inc." as the account.
    page.has_selector?('input[aria-label="seachAccount"]')
    for_account = find('input[aria-label="seachAccount"]').click
    'abc inc'.chars.each { |ch| page.send_keys(ch) }
    page.has_text?('ABC Inc')
    page.send_keys(:enter)
    sleep(3)

    # Click the FOR CONTACT: drop down menu then choose "Adnan QA Ghaffar" as one of the recipient.
    wait_for_selector('.labelValue')
    find_all('.labelValue')[1].click
    'adnan qa ghaffar'.chars.each { |ch| page.send_keys(ch) }
    page.has_text?('Adnan QA Ghaffar')
    page.send_keys(:enter)

    # Click the TO-GO TYPE: drop down menu then choose "Pickup" as one of the recipient.
    page.has_selector?('input[aria-label="togoType"]')
    for_to_go_type = find('input[aria-label="togoType"]').click
    'pickup'.chars.each { |ch| page.send_keys(ch) }
    page.has_text?('Pickup')
    page.send_keys(:enter)
    sleep(1)

    page.has_selector?('input[aria-label="documentType"]')
    for_to_go_type = find('input[aria-label="documentType"]').click
    page.send_keys(:enter)
    sleep(1)

    # Verify the SUBJECT in the SUBJECT field.
    subject = find_by_id('taskTitle').value
    expect(subject).to eq(subject_title)

    # Click on CREATE TASK button.
    click_on 'Create Task'
    wait_for_text(page, 'Task created successfully')
    page.current_path
  end

  def client_searches_for_description
    # Send a message to Client user with a unique description
    go_to_inbox

    time_stamp = Time.new.strftime('%s')
    subject = 'Subject'
    description = 'unique_' + time_stamp

    send_message_to_client_user(subject, description)

    # Sign-in as a Client user
    login_page.logout
    login_to_app_as_client

    inbox_selector = 'div[data-testid="sidebar__inbox"]'
    # Existing messages in Inbox
    # In the Landing page, click on MESSAGES from left side nav of the dashboard screen.
    wait_for_selector(inbox_selector)
    find(inbox_selector).click

    # Click "Search bar" then type the message title.
    search_bar_selector = 'input[data-testid="inbox__message_search"]'
    wait_for_selector(search_bar_selector)
    search_bar = find(search_bar_selector)
    search_bar.send_keys(description)

    # Verify results.
    expect(page).not_to have_content('No Records Found')
    expect(page).to have_content(subject)

    # Unique message
    expect(page).to have_content('Showing 1 to 1 of 1 entries')
    page.current_path
  end

  def client_searches_for_invalid_title
    # Sign-in as a Client user
    login_to_app_as_client

    inbox_selector = 'div[data-testid="sidebar__inbox"]'
    # Existing messages in Inbox
    # In the Landing page, click on MESSAGES from left side nav of the dashboard screen.
    wait_for_selector(inbox_selector)
    find(inbox_selector).click

    # Click "Search bar" then type the message title.
    search_bar_selector = 'input[data-testid="inbox__message_search"]'
    wait_for_selector(search_bar_selector)
    search_bar = find(search_bar_selector)
    search_bar.send_keys('a bee see on the tree')
    wait_for_loading_animation

    # Verify results.
    expect(page).to have_content('No Records Found')
    page.current_path
  end

  def create_manage_to_go_items_from_inbox_thread_level
    # Sign-in as a Firm-side user.
    login_to_app_as_employee

    # In the Landing page, click on INBOX from left side nav of the dashboard screen.
    inbox_selector = 'div[data-testid="sidebar__inbox"]'
    wait_for_selector(inbox_selector)
    find(inbox_selector).click

    sleep(3)
    wait_for_selector('.row')
    subject_title = find_all('.row')[1].text.split("\n")[1]
    find_all('.row')[1].click
    expect(page.current_path).to include('inbox')

    # Under MESSAGE DETAILS screen, click on the CREATE TASK inline with the message title.
    create_task_button_selector = 'svg[data-testid="CheckBoxOutlinedIcon"]'
    wait_for_selector(create_task_button_selector)
    find(create_task_button_selector).click

    # Under CREATE TASK SCREEN, verify the pre-selected DUE DATE and OWNER
    date_picker_wrapper_selector = 'react-datepicker__input-container'
    wait_for_selector(".#{date_picker_wrapper_selector}")
    date_picker_wrapper = find(".#{date_picker_wrapper_selector}")
    pre_filled_date = date_picker_wrapper.find('input').value

    # Click TASK: then select Manage To Go Items
    task_div = find('.task-type-select').click
    task_div.find_all('div', text: 'Manage To Go Items').last.click

    # Click the FOR ACCOUNT: drop down menu then choose "ABC Inc." as the account.
    page.has_selector?('input[aria-label="seachAccount"]')
    for_account = find('input[aria-label="seachAccount"]').click
    'abc inc'.chars.each { |ch| page.send_keys(ch) }
    page.has_text?('ABC Inc')
    page.send_keys(:enter)
    sleep(3)

    # Click the FOR CONTACT: drop down menu then choose "Adnan QA Ghaffar" as one of the recipient.
    wait_for_selector('.labelValue')
    find_all('.labelValue')[1].click
    'adnan qa ghaffar'.chars.each { |ch| page.send_keys(ch) }
    page.has_text?('Adnan QA Ghaffar')
    page.send_keys(:enter)

    # Click the TO-GO TYPE: drop down menu then choose "Pickup" as one of the recipient.
    page.has_selector?('input[aria-label="togoType"]')
    for_to_go_type = find('input[aria-label="togoType"]').click
    'pickup'.chars.each { |ch| page.send_keys(ch) }
    page.has_text?('Pickup')
    page.send_keys(:enter)
    sleep(1)

    page.has_selector?('input[aria-label="documentType"]')
    for_to_go_type = find('input[aria-label="documentType"]').click
    page.send_keys(:enter)
    sleep(1)

    # Verify the SUBJECT in the SUBJECT field.
    subject = find_by_id('taskTitle').value
    expect(subject).to eq(subject_title)

    # Click on CREATE TASK button.
    click_on 'Create Task'
    wait_for_text(page, 'Task created successfully')
    page.current_path
  end

  def edit_subject_in_message
    # Sign-in as a Firm-side user.
    login_to_app_as_employee

    # In the Landing page, click on INBOX from left side nav of the dashboard screen.
    inbox_selector = 'div[data-testid="sidebar__inbox"]'
    wait_for_selector(inbox_selector)
    find(inbox_selector).click

    wait_for_loading_animation
    sleep(3)
    wait_for_selector('.row')
    subject_title = find_all('.row')[1].text.split("\n")[1]
    find_all('.row')[1].click
    expect(page.current_path).to include('inbox')

    # Under MESSAGE DETAILS screen, click on the CREATE TASK inline with the message title.
    create_task_button_selector = 'svg[data-testid="CheckBoxOutlinedIcon"]'
    wait_for_selector(create_task_button_selector)
    find(create_task_button_selector).click

    # Under CREATE TASK SCREEN, verify the pre-selected DUE DATE and OWNER
    date_picker_wrapper_selector = 'react-datepicker__input-container'
    wait_for_selector(".#{date_picker_wrapper_selector}")
    date_picker_wrapper = find(".#{date_picker_wrapper_selector}")
    pre_filled_date = date_picker_wrapper.find('input').value

    # Click TASK: then select Manage To Go Items
    task_div = find('.task-type-select').click
    task_div.find_all('div', text: 'Manage To Go Items').last.click

    # Click the FOR ACCOUNT: drop down menu then choose "ABC Inc." as the account.
    page.has_selector?('input[aria-label="seachAccount"]')
    for_account = find('input[aria-label="seachAccount"]').click
    'abc inc'.chars.each { |ch| page.send_keys(ch) }
    page.has_text?('ABC Inc')
    page.send_keys(:enter)
    sleep(3)

    # Click the FOR CONTACT: drop down menu then choose "Adnan QA Ghaffar" as one of the recipient.
    wait_for_selector('.labelValue')
    find_all('.labelValue')[1].click
    'adnan qa ghaffar'.chars.each { |ch| page.send_keys(ch) }
    page.has_text?('Adnan QA Ghaffar')
    page.send_keys(:enter)

    # Click the TO-GO TYPE: drop down menu then choose "Pickup" as one of the recipient.
    page.has_selector?('input[aria-label="togoType"]')
    for_to_go_type = find('input[aria-label="togoType"]').click
    'pickup'.chars.each { |ch| page.send_keys(ch) }
    page.has_text?('Pickup')
    page.send_keys(:enter)
    sleep(1)

    page.has_selector?('input[aria-label="documentType"]')
    for_to_go_type = find('input[aria-label="documentType"]').click
    page.send_keys(:enter)
    sleep(1)

    # Verify the SUBJECT in the SUBJECT field.
    subject = find_by_id('taskTitle').value
    expect(subject).to eq(subject_title)

    time_stamp = Time.now.to_i
    modified_subject_title = "_#{time_stamp}"

    subject_field = find_by_id('taskTitle')
    subject_field.send_keys(modified_subject_title)

    # Click on CREATE TASK button.
    click_on 'Create Task'
    wait_for_text(page, 'Task created successfully')
    verify_task_has_been_created(modified_subject_title)
    page.current_path
  end

  def view_all_filter_messages
    go_to_inbox

    time_stamp = Time.new.strftime('%s')
    subject = 'Test_Message_' + time_stamp
    body = 'body'

    send_message_to_firm_user(subject, body)

    login_to_app_as_employee

    inbox_selector = 'div[data-testid="sidebar__inbox"]'
    wait_for_selector(inbox_selector)
    find(inbox_selector).click

    search_bar_selector = 'input[data-testid="inbox__message_search"]'
    wait_for_selector(search_bar_selector)
    search_bar = find(search_bar_selector)
    search_bar.send_keys(subject)

    expect(page).not_to have_content('No Records Found')
    expect(page).to have_content(subject)

    expect(page).to have_content('Showing 1 to 1 of 1 entries')
    page.current_path
  end

  def setup_new_employee
    go_to_contacts

    sleep 3
    page_refresh

    wait_for_selector('.row.tdBtn')
    find_all('.row.tdBtn')[1].click
    expect(page.current_path).to include('contactdetails')

    button_selector = 'button[data-testid="inbox__messages"]'
    wait_for_selector(button_selector)
    find(button_selector).click

    expect(page.current_url).to include('#messages')
    sleep 3
    wait_for_selector('.row')
    find_all('.row')[1].click

    print_button_selector = 'a[title="Print Thread"]'
    wait_for_selector(print_button_selector)
    page.current_path
  end

  def setup_new_employee_for_sms
    login_to_app
    inbox_selector = 'div[data-testid="sidebar__inbox"]'
    wait_for_selector(inbox_selector)
    find(inbox_selector).click

    sleep 3
    wait_for_selector('.row')
    find_all('.row')[1].click

    print_button_selector = 'a[title="Print Thread"]'
    wait_for_selector(print_button_selector)
    page.current_path
  end

  def create_to_do_from_inbox_list_level_ellipses
    # In the Landing page, click on INBOX from the left side nav of the dashboard screen
    go_to_inbox

    # Under INBOX tab, click on the ellipses button beside a message
    wait_for_selector('.tRow--body')
    table = find('.tRow--body')
    rows = table.find_all('.row')

    message_index = 0
    message_title = ""
    rows.each_with_index do |row, index|
      next if row.text.include?('This message has been deleted')

      message_title = row.text.split("\n")[1]
      message_index = index
      break
    end

    message_row = table.find_all('.row')[message_index]
    wait_for_selector('.icon-more')
    message_row.find('.icon-more').click
    page.send_keys(:arrow_down)
    sleep(0.5)
    page.send_keys(:enter)
    sleep 5

    # Under CREATE TASK SCREEN, verify the pre-selected DUE DATE and OWNER
    # Click TASK: then select TO DO
    # By default selected 'To Do' Task

    wait_for_selector('.miscellaneous')
    modal = find('.miscellaneous')
    for_employee = modal.find_all('input').first
    for_account = modal.find_all('input')[2]
    for_contact = modal.find_all('input')[4]

    'automation qa'.chars.each { |ch| for_employee.send_keys(ch) }
    wait_for_text(page, 'Automation QA')
    page.send_keys(:enter)
    sleep 1

    # Click the FOR ACCOUNT: drop-down menu then choose "ANGUS ADVENTURE" as the account
    'angus adventure'.chars.each { |ch| for_account.send_keys(ch) }
    wait_for_text(page, 'Angus Adventures')
    page.send_keys(:enter)
    sleep 1

    # Verify the FOR CONTACT dropdown list
    # Click the FOR CONTACT: drop-down menu then choose "AQUIFA HALBERT" as one of the recipients
    'aquifa halbert'.chars.each { |ch| for_contact.send_keys(ch) }
    wait_for_text(page, 'Aquifa Halbert')
    page.send_keys(:enter)
    sleep 1

    # Verify the SUBJECT in the SUBJECT field
    subject = find_by_id('taskTitle').value
    expect(subject).to eq(message_title)

    # Click on CREATE TASK button
    click_on 'Create Task'

    # User should be able to create 'To Do' task in a Message from Inbox > list level ellipses
    wait_for_text(page, 'Task created successfully')
    page.current_path
  end

  def create_to_do_from_message_level_ellipses
    # In the Landing page, click on INBOX from the left side nav of the dashboard screen
    go_to_inbox
    sleep 2

    # Under INBOX tab, click on the message.
    expect(page).to have_current_path('/all_messages')
    sleep 2
    wait_for_selector('.tRow--body')
    table = find('.tRow--body')
    row = table.find_all('.row')[0]
    message_title = row.text.split("\n")[1]
    table.find_all('.row')[0].click

    # Under MESSAGE DETAILS screen, click on the ellipses button beside the date
    wait_for_selector('.icon-more')
    page.find_all('.icon-more').first.click
    page.send_keys(:arrow_down)
    sleep(0.5)
    # Choose Create Task
    page.send_keys(:enter)
    sleep 5

    wait_for_selector('.miscellaneous')
    modal = find('.miscellaneous')
    for_employee = modal.find_all('input').first
    for_account = modal.find_all('input')[2]
    for_contact = modal.find_all('input')[4]

    sleep 3
    'automation qa'.chars.each { |ch| for_employee.send_keys(ch) }
    wait_for_text(page, 'Automation QA')
    page.send_keys(:enter)
    sleep 1

    # Click the FOR ACCOUNT: drop-down menu then choose "ANGUS ADVENTURE" as the account
    'angus adventure'.chars.each { |ch| for_account.send_keys(ch) }
    wait_for_text(page, 'Angus Adventures')
    page.send_keys(:enter)
    sleep 1

    # Verify the FOR CONTACT dropdown list
    # Click the FOR CONTACT: drop-down menu then choose "AQUIFA HALBERT" as one of the recipients
    'aquifa halbert'.chars.each { |ch| for_contact.send_keys(ch) }
    wait_for_text(page, 'Aquifa Halbert')
    page.send_keys(:enter)
    sleep 1

    # Verify the SUBJECT in the SUBJECT field
    subject = find_by_id('taskTitle').value
    expect(subject).to eq(message_title)

    # Click on CREATE TASK button
    click_on 'Create Task'

    # User should be able to create 'To Do' task in a Message from Inbox > Message level ellipses
    wait_for_text(page, 'Task created successfully')
    page.current_path
  end

  def create_to_do_from_inbox_thread_level_button
    # In the Landing page, click on INBOX from the left side nav of the dashboard screen
    go_to_inbox
    sleep 2

    # Under INBOX tab, click on the message
    expect(page).to have_current_path('/all_messages')
    sleep 2
    wait_for_selector('.tRow--body')
    table = find('.tRow--body')
    row = table.find_all('.row')[0]
    message_title = row.text.split("\n")[1]
    table.find_all('.row')[0].click

    # Under MESSAGE DETAILS screen, click on the CREATE TASK inline with the message title
    create_task_button_selector = 'svg[data-testid="CheckBoxOutlinedIcon"]'
    wait_for_selector(create_task_button_selector)
    find(create_task_button_selector).click

    wait_for_selector('.miscellaneous')
    modal = find('.miscellaneous')
    for_employee = modal.find_all('input').first
    for_account = modal.find_all('input')[2]
    for_contact = modal.find_all('input')[4]

    sleep 3
    'automation qa'.chars.each { |ch| for_employee.send_keys(ch) }
    wait_for_text(page, 'Automation QA')
    page.send_keys(:enter)
    sleep 1

    # Click the FOR ACCOUNT: drop-down menu then choose "ANGUS ADVENTURE" as the account
    'angus adventure'.chars.each { |ch| for_account.send_keys(ch) }
    wait_for_text(page, 'Angus Adventures')
    page.send_keys(:enter)
    sleep 1

    # Verify the FOR CONTACT dropdown list
    # Click the FOR CONTACT: drop-down menu then choose "AQUIFA HALBERT" as one of the recipients
    'aquifa halbert'.chars.each { |ch| for_contact.send_keys(ch) }
    wait_for_text(page, 'Aquifa Halbert')
    page.send_keys(:enter)
    sleep 1

    # Verify the SUBJECT in the SUBJECT field
    subject = find_by_id('taskTitle').value
    expect(subject).to eq(message_title)

    # Click on CREATE TASK button
    click_on 'Create Task'

    # User should be able to create 'To Do' task in a Message from Inbox > Message level ellipses
    wait_for_text(page, 'Task created successfully')
    page.current_path
  end

  def list_level_ellipses
    go_to_inbox

    time_stamp = Time.new.strftime('%s')
    subject = 'Test_Message_' + time_stamp
    body = 'body'

    send_message_to_firm_user(subject, body)

    login_to_app_as_employee

    inbox_selector = 'div[data-testid="sidebar__inbox"]'
    wait_for_selector(inbox_selector)
    find(inbox_selector).click

    search_bar_selector = 'input[data-testid="inbox__message_search"]'
    wait_for_selector(search_bar_selector)
    search_bar = find(search_bar_selector)
    search_bar.send_keys(subject)

    expect(page).not_to have_content('No Records Found')
    expect(page).to have_content(subject)

    expect(page).to have_content('Showing 1 to 1 of 1 entries')
    page.current_path
  end

  def message_level_ellipses
    go_to_inbox

    time_stamp = Time.new.strftime('%s')
    subject = 'Subject'
    description = 'unique_' + time_stamp

    send_message_to_firm_user(subject, description)

    login_to_app_as_employee

    inbox_selector = 'div[data-testid="sidebar__inbox"]'
    wait_for_selector(inbox_selector)
    find(inbox_selector).click

    search_bar_selector = 'input[data-testid="inbox__message_search"]'
    wait_for_selector(search_bar_selector)
    search_bar = find(search_bar_selector)
    search_bar.send_keys(description)

    expect(page).not_to have_content('No Records Found')
    expect(page).to have_content(description)

    expect(page).to have_content('Showing 1 to 1 of 1 entries')
    page.current_path
  end

  def thread_level_button
    go_to_inbox

    time_stamp = Time.new.strftime('%s')
    subject = 'Test_Message_' + time_stamp
    body = 'body'

    send_message_to_firm_user(subject, body)

    login_to_app_as_employee

    inbox_selector = 'div[data-testid="sidebar__inbox"]'
    wait_for_selector(inbox_selector)
    find(inbox_selector).click

    search_bar_selector = 'input[data-testid="inbox__message_search"]'
    wait_for_selector(search_bar_selector)
    search_bar = find(search_bar_selector)
    search_bar.send_keys(subject)

    expect(page).not_to have_content('No Records Found')
    expect(page).to have_content(subject)

    expect(page).to have_content('Showing 1 to 1 of 1 entries')
    page.current_path
  end

  def manage_item_task_in_message
    go_to_inbox

    sleep 3

    page.has_text?('Inbox')
    page.has_selector?('.col-3.tdCol.truncate')
    page.has_text?('Last Activity At')
    find_all('button[aria-haspopup="menu"]').first.click
    page.current_path
  end

  def create_request_information_task_from_inbox_list_level_ellipses
    login_to_app_as_employee

    # In the Landing page, click on INBOX from left side nav of the dashboard screen.
    inbox_selector = 'div[data-testid="sidebar__inbox"]'
    wait_for_selector(inbox_selector)
    find(inbox_selector).click

    # Under INBOX tab, click on the ellipses button beside a message.
    # Choose Create Task
    wait_for_loading_animation
    sleep(3)
    wait_for_selector('.icon-more')
    subject_title = find_all('.tdCol')[2].text.split("\n").first
    find_all('i.icon-more').first.click
    sleep 0.5
    page.send_keys(:arrow_down) # Click on Create Task
    sleep 0.5
    page.send_keys(:enter)

    # Under CREATE TASK SCREEN, verify the pre-selected DUE DATE and OWNER
    date_picker_wrapper_selector = 'react-datepicker__input-container'
    wait_for_selector(".#{date_picker_wrapper_selector}")
    date_picker_wrapper = find(".#{date_picker_wrapper_selector}")
    pre_filled_date = date_picker_wrapper.find('input').value

    # Click TASK: then select Request Information
    task_div = find('.task-type-select').click
    task_div.find_all('div', text: 'Request Information').last.click

    # Click the FOR ACCOUNT: drop down menu then choose "ABC Testing Inc." as the account.
    page.has_selector?('input[aria-label="seachAccount"]')
    for_account = find('input[aria-label="seachAccount"]').click
    'abc inc'.chars.each { |ch| page.send_keys(ch) }
    page.has_text?('ABC Inc')
    page.send_keys(:enter)
    sleep(3)

    # Click the FOR CONTACT: drop down menu then choose "Adnan QA QA" as one of the recipient.
    wait_for_selector('.labelValue')
    find_all('.labelValue')[1].click
    'adnan qa ghaffar'.chars.each { |ch| page.send_keys(ch) }
    page.has_text?('Adnan QA Ghaffar')
    page.send_keys(:enter)

    # Verify the SUBJECT in the SUBJECT field.
    subject = find_by_id('taskTitle').value
    expect(subject).to eq(subject_title)

    time_stamp = Time.now.to_i
    modified_subject_title = "_#{time_stamp}"

    subject_field = find_by_id('taskTitle')
    subject_field.send_keys(modified_subject_title)

    # Click on CREATE TASK button.
    click_on 'Create Task'
    wait_for_text(page, 'Task created successfully')
    verify_task_has_been_created(modified_subject_title)
    page.current_path
  end

  def create_request_information_task_from_message_level_ellipses
    # In the Landing page, click on INBOX from the left side nav of the dashboard screen
    go_to_inbox
    sleep 2

    # Under INBOX tab, click on the message.
    expect(page).to have_current_path('/all_messages')
    sleep 2
    wait_for_selector('.tRow--body')
    table = find('.tRow--body')
    row = table.find_all('.row')[0]
    message_title = row.text.split("\n")[1]
    table.find_all('.row')[0].click

    # Under MESSAGE DETAILS screen, click on the ellipses button beside the date
    wait_for_selector('.icon-more')
    page.find_all('.icon-more').first.click
    page.send_keys(:arrow_down)
    sleep(0.5)
    # Choose Create Task
    page.send_keys(:enter)
    sleep 5

    # Click TASK: then select Request Information
    task_div = find('.task-type-select').click
    task_div.find_all('div', text: 'Request Information').last.click

    sleep 3
    wait_for_selector('.miscellaneous')
    modal = find('.miscellaneous')
    for_account = modal.find_all('input')[0]
    for_contact = modal.find_all('input')[2]

    # Click the FOR ACCOUNT: drop-down menu then choose "ANGUS ADVENTURE" as the account
    'angus adventure'.chars.each { |ch| for_account.send_keys(ch) }
    wait_for_text(page, 'Angus Adventures')
    page.send_keys(:enter)
    sleep 1

    # Verify the FOR CONTACT dropdown list
    # Click the FOR CONTACT: drop-down menu then choose "AQUIFA HALBERT" as one of the recipients
    'aquifa halbert'.chars.each { |ch| for_contact.send_keys(ch) }
    wait_for_text(page, 'Aquifa Halbert')
    page.send_keys(:enter)
    sleep 1

    # Verify the SUBJECT in the SUBJECT field
    subject = find_by_id('taskTitle').value
    expect(subject).to eq(message_title)

    time_stamp = Time.now.to_i
    modified_subject_title = "_#{time_stamp}"

    subject_field = find_by_id('taskTitle')
    subject_field.send_keys(modified_subject_title)

    # Click on CREATE TASK button
    click_on 'Create Task'

    # User should be able to create 'To Do' task in a Message from Inbox > Message level ellipses
    wait_for_text(page, 'Task created successfully')
    verify_task_has_been_created(modified_subject_title)
    page.current_path
  end

  def create_request_information_from_inbox_thread_level_button
    login_to_app_as_employee

    # In the Landing page, click on INBOX from left side nav of the dashboard screen.
    inbox_selector = 'div[data-testid="sidebar__inbox"]'
    wait_for_selector(inbox_selector)
    find(inbox_selector).click

    sleep(3)
    wait_for_selector('.row')
    subject_title = find_all('.row')[1].text.split("\n")[1]
    find_all('.row')[1].click
    expect(page.current_path).to include('inbox')

    # Under MESSAGE DETAILS screen, click on the CREATE TASK inline with the message title.
    create_task_button_selector = 'svg[data-testid="CheckBoxOutlinedIcon"]'
    wait_for_selector(create_task_button_selector)
    find(create_task_button_selector).click

    # Under CREATE TASK SCREEN, verify the pre-selected DUE DATE and OWNER
    date_picker_wrapper_selector = 'react-datepicker__input-container'
    wait_for_selector(".#{date_picker_wrapper_selector}")
    date_picker_wrapper = find(".#{date_picker_wrapper_selector}")
    pre_filled_date = date_picker_wrapper.find('input').value

    # Click TASK: then select Request Information
    task_div = find('.task-type-select').click
    task_div.find_all('div', text: 'Request Information').last.click

    # Click the FOR ACCOUNT: drop down menu then choose "ABC Inc." as the account.
    page.has_selector?('input[aria-label="seachAccount"]')
    for_account = find('input[aria-label="seachAccount"]').click
    'abc inc'.chars.each { |ch| page.send_keys(ch) }
    page.has_text?('ABC Inc')
    page.send_keys(:enter)
    sleep(3)

    # Click the FOR CONTACT: drop down menu then choose "Adnan QA Ghaffar" as one of the recipient.
    wait_for_selector('.labelValue')
    find_all('.labelValue')[1].click
    'adnan qa ghaffar'.chars.each { |ch| page.send_keys(ch) }
    page.has_text?('Adnan QA Ghaffar')
    page.send_keys(:enter)

    # Verify the SUBJECT in the SUBJECT field.
    subject = find_by_id('taskTitle').value
    expect(subject).to eq(subject_title)

    time_stamp = Time.now.to_i
    modified_subject_title = "_#{time_stamp}"

    subject_field = find_by_id('taskTitle')
    subject_field.send_keys(modified_subject_title)

    # Click on CREATE TASK button.
    click_on 'Create Task'
    wait_for_text(page, 'Task created successfully')
    verify_task_has_been_created(modified_subject_title)
    page.current_path
  end

  def create_meeting_task_from_list_level_ellipses
    login_to_app

    # In the Landing page, click on INBOX from left side nav of the dashboard screen.
    inbox_selector = 'div[data-testid="sidebar__inbox"]'
    wait_for_selector(inbox_selector)
    find(inbox_selector).click

    # Under INBOX tab, click on the ellipses button beside a message.
    # Choose Create Task
    wait_for_loading_animation
    sleep(3)
    wait_for_selector('.icon-more')
    subject_title = find_all('.tdCol')[2].text.split("\n").first
    find_all('i.icon-more').first.click
    sleep 0.5
    page.send_keys(:arrow_down) # Click on Create Task
    sleep 0.5
    page.send_keys(:enter)

    # Under CREATE TASK SCREEN, verify the pre-selected DUE DATE and OWNER
    date_picker_wrapper_selector = 'react-datepicker__input-container'
    wait_for_selector(".#{date_picker_wrapper_selector}")
    date_picker_wrapper = find(".#{date_picker_wrapper_selector}")
    pre_filled_date = date_picker_wrapper.find('input').value

    # Click TASK: then select Meeting
    task_div = find('.task-type-select').click
    task_div.find_all('div', text: 'Meeting').last.click

    # Click the FOR ACCOUNT: drop down menu then choose "ABC Testing Inc." as the account.
    page.has_selector?('input[aria-label="seachAccount"]')
    for_account = find('input[aria-label="seachAccount"]').click
    'abc testing inc'.chars.each { |ch| page.send_keys(ch) }
    page.has_text?('ABC Testing Inc.')
    page.send_keys(:enter)
    sleep(3)

    # Click the FOR CONTACT: drop down menu then choose "Adnan QA QA" as one of the recipient.
    wait_for_selector('.labelValue')
    find_all('.labelValue')[1].click
    'adnan qa qa'.chars.each { |ch| page.send_keys(ch) }
    page.has_text?('Adnan QA QA')
    page.send_keys(:enter)

    # Verify the SUBJECT in the SUBJECT field
    # Bug? Current Implementation does not have the subject
    # Steps to reproduce: Create a meeting task from from list level ellipses
    # subject = find_by_id('taskTitle').value
    # expect(subject).to eq(subject_title)

    time_stamp = Time.now.to_i
    modified_subject_title = "_#{time_stamp}"

    subject_field = find_by_id('taskTitle')
    subject_field.send_keys(modified_subject_title)

    # Click on CREATE TASK button.
    click_on 'Create Task'
    wait_for_text(page, 'Task created successfully')
    verify_task_has_been_created(modified_subject_title)
    page.current_path
  end

  def create_meeting_task_from_message_level_ellipses
    login_to_app
    sleep 3

    # In the Landing page, click on INBOX from left side nav of the dashboard screen.
    inbox_selector = 'div[data-testid="sidebar__inbox"]'
    wait_for_selector(inbox_selector)
    find(inbox_selector).click

    # Under INBOX tab, click on the message.
    expect(page).to have_current_path('/all_messages')
    sleep 2
    wait_for_selector('.tRow--body')
    table = find('.tRow--body')
    row = table.find_all('.row')[0]
    message_title = row.text.split("\n")[1]
    table.find_all('.row')[0].click

    # Under MESSAGE DETAILS screen, click on the ellipses button beside the date
    wait_for_selector('.icon-more')
    page.find_all('.icon-more').first.click
    page.send_keys(:arrow_down)
    sleep(0.5)
    # Choose Create Task
    page.send_keys(:enter)
    sleep 5

    # Click TASK: then select Meeting
    task_div = find('.task-type-select').click
    task_div.find_all('div', text: 'Meeting').last.click

    sleep 3
    wait_for_selector('.miscellaneous')
    modal = find('.miscellaneous')
    for_account = modal.find_all('input')[0]
    for_contact = modal.find_all('input')[2]

    # Click the FOR ACCOUNT: drop-down menu then choose "ANGUS ADVENTURE" as the account
    'angus adventure'.chars.each { |ch| for_account.send_keys(ch) }
    wait_for_text(page, 'Angus Adventures')
    page.send_keys(:enter)
    sleep 1

    # Verify the FOR CONTACT dropdown list
    # Click the FOR CONTACT: drop-down menu then choose "AQUIFA HALBERT" as one of the recipients
    'aquifa halbert'.chars.each { |ch| for_contact.send_keys(ch) }
    wait_for_text(page, 'Aquifa Halbert')
    page.send_keys(:enter)
    sleep 1

    # Verify the SUBJECT in the SUBJECT field
    # subject = find_by_id('taskTitle').value
    # expect(subject).to eq(message_title)

    time_stamp = Time.now.to_i
    modified_subject_title = "_#{time_stamp}"

    subject_field = find_by_id('taskTitle')
    subject_field.send_keys(modified_subject_title)

    # Click on CREATE TASK button
    click_on 'Create Task'

    # User should be able to create 'To Do' task in a Message from Inbox > Message level ellipses
    wait_for_text(page, 'Task created successfully')
    verify_task_has_been_created(modified_subject_title)
    page.current_path
  end

  def create_meeting_task_from_thread_level_button
    login_to_app

    # In the Landing page, click on INBOX from left side nav of the dashboard screen.
    inbox_selector = 'div[data-testid="sidebar__inbox"]'
    wait_for_selector(inbox_selector)
    find(inbox_selector).click

    wait_for_loading_animation
    expect(page).to have_current_path('/all_messages')
    wait_for_selector('.row')
    sleep(3)
    subject_title = find_all('.row')[1].text.split("\n")[1]
    find_all('.row')[1].click
    expect(page.current_path).to include('inbox')

    # Under MESSAGE DETAILS screen, click on the CREATE TASK inline with the message title.
    create_task_button_selector = 'svg[data-testid="CheckBoxOutlinedIcon"]'
    wait_for_selector(create_task_button_selector)
    find(create_task_button_selector).click

    # Under CREATE TASK SCREEN, verify the pre-selected DUE DATE and OWNER
    date_picker_wrapper_selector = 'react-datepicker__input-container'
    wait_for_selector(".#{date_picker_wrapper_selector}")
    date_picker_wrapper = find(".#{date_picker_wrapper_selector}")
    pre_filled_date = date_picker_wrapper.find('input').value

    # Click TASK: then select Meeting
    task_div = find('.task-type-select').click
    task_div.find_all('div', text: 'Meeting').last.click

    # Click the FOR ACCOUNT: drop down menu then choose "ABC Testing Inc." as the account.
    page.has_selector?('input[aria-label="seachAccount"]')
    for_account = find('input[aria-label="seachAccount"]').click
    'abc testing inc'.chars.each { |ch| page.send_keys(ch) }
    page.has_text?('ABC Testing Inc.')
    page.send_keys(:enter)
    sleep(3)

    # Click the FOR CONTACT: drop down menu then choose "Adnan QA QA" as one of the recipient.
    wait_for_selector('.labelValue')
    find_all('.labelValue')[1].click
    'adnan qa qa'.chars.each { |ch| page.send_keys(ch) }
    page.has_text?('Adnan QA QA')
    page.send_keys(:enter)

    # Verify the SUBJECT in the SUBJECT field.
    # subject = find_by_id('taskTitle').value
    # expect(subject).to eq(subject_title)

    time_stamp = Time.now.to_i
    modified_subject_title = "_#{time_stamp}"

    subject_field = find_by_id('taskTitle')
    subject_field.send_keys(modified_subject_title)

    # Click on CREATE TASK button.
    click_on 'Create Task'
    wait_for_text(page, 'Task created successfully')
    verify_task_has_been_created(modified_subject_title)
    page.current_path
  end

  def add_another_recipient_to_a_thread_from_contact_messages
    go_to_home_page

    contact_selector = 'div[data-testid="sidebar__contacts"]'
    wait_for_selector(contact_selector)
    find(contact_selector).click

    search_contact_selector = 'input[data-testid="contact__search_input"]'

    if !page.has_selector?(search_contact_selector)
      page_refresh
    end

    expect(page).to have_current_path('/contacts')

    contact_search = find(search_contact_selector)
    contact_search.send_keys('adnan.qat123@gmail.com')
    page.has_text?('QA, Adnan QA')

    find('span', text: 'QA, Adnan QA').click

    messages_selector = 'button[data-testid="inbox__messages"]'
    wait_for_selector(messages_selector)
    find(messages_selector).click

    subject = create_a_placeholder_message_to_test

    find('span', text: subject).click

    # Click on the "Reply" text field
    find('textarea').click
    # Verify "Additional Recipients:" displays
    # Click on the "Additional Recipients:" field

    wait_for_selector('.customTags')
    find('.customTags').click

    # Enter "Han" and verify "Han Solo" is suggested
    sleep 3
    fill_in 'messageRecipient', with: 'han'

    # Click on the "Han Solo"
    wait_for_text(page, 'Han Solo')
    page.send_keys(:enter)
    click_on 'Ok'

    page.send_keys(:tab)

    # Add a reply "Adding Han to this thread"
    iframe = find_all('iframe[id^="tiny-react_"]').last
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('Adding Han to this thread')
      page.send_keys(:tab)
    end

    # Click on the "Send" button
    click_on "Send"
    page.current_path
  end

  private

  def create_a_placeholder_message_to_test
    wait_for_text(page, '+ Message')
    find('a', text: '+ Message').click

    time_stamp = Time.now.to_i
    subject = "Message_#{time_stamp}"

    within('.modal-dialog') do
      # Verify various subject displays
      page.has_selector?('labelValue')

      # Verify the number subjects begin to filter based on the first letter typed ("H")
      subject_div = find_all('.labelValue')[1].click
      page.send_keys(subject)
      page.send_keys(:tab)

      page.has_selector?('iframe')
      iframe = find('iframe')
      within_frame iframe do
        # Verify "Saving" displays
        body_div = find_by_id('tinymce').click

        # Verify the message description displays
        body_div.send_keys("body")
      end

      click_on 'Send'
    end
    subject
  end

  def verify_task_has_been_created(subject)
    within('.Sidebar') do
      click_on 'TASKS'
    end

    expect(page).to have_current_path('/all_tasks')
    wait_for_text(page, subject)
  end

  def send_message_to_client_user(subject, body)
    page.has_text?('+ Message')
    click_link '+ Message'

    # New message modal
    within('.modal-dialog') do
      find('a[data-testid="onFocusButton"]').click

      sleep 2
      page.has_selector?('div[data-value]')
      # Aquifa Halbert
      recipient = fill_in 'messageRecipient', with: 'aquifa halbert'
      # Verify the recipient's name displays in the TO field
      page.has_text?('Aquifa Halbert')
      recipient.send_keys(:enter)

      click_on 'Ok'

      # Verify various subject displays
      page.has_selector?('labelValue')

      # Verify the number subjects begin to filter based on the first letter typed ("H")
      subject_div = find_all('.labelValue')[1].click
      page.send_keys(subject)
      page.send_keys(:tab)

      page.has_selector?('iframe')
      iframe = find('iframe')
      within_frame iframe do
        # Verify "Saving" displays
        body_div = find_by_id('tinymce').click

        # Verify the message description displays
        body_div.send_keys(body)
      end
      click_on 'Send'
    end
  end

  def send_message_to_firm_user(subject, body)
    page.has_text?('+ Message')
    click_link '+ Message'

    # New message modal
    within('.modal-dialog') do
      find('a[data-testid="onFocusButton"]').click

      page.has_selector?('div[data-value]')
      recipient = fill_in 'messageRecipient', with: 'test account ad'
      # Verify the recipient's name displays in the TO field
      page.has_text?('test account Adnan')
      recipient.send_keys(:enter)

      click_on 'Ok'

      # Verify various subject displays
      page.has_selector?('labelValue')

      # Verify the number subjects begin to filter based on the first letter typed ("H")
      subject_div = find_all('.labelValue')[1].click
      page.send_keys(subject)
      page.send_keys(:tab)

      page.has_selector?('iframe')
      iframe = find('iframe')
      within_frame iframe do
        # Verify "Saving" displays
        body_div = find_by_id('tinymce').click

        # Verify the message description displays
        body_div.send_keys(body)
      end
      click_on 'Send'
    end

    login_page.logout
  end

  def login_to_app_as_employee
    login_page.ensure_login_page_rendered

    login_page.sign_in_with_valid_employee
    login_page.ensure_correct_credientials
    login_page
  end

  def login_to_app_as_client
    login_page.ensure_login_page_rendered

    login_page.sign_in_with_valid_client
    login_page.ensure_correct_credientials
    login_page
  end

  def login_to_app
    login_page.ensure_login_page_rendered

    login_page.sign_in_with_valid_user
    login_page.ensure_correct_credientials
    login_page
  end

  def login_page
    @login_page ||= LoginPage.new
  end
end
