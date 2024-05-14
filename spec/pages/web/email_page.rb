require_relative 'base_page'
require_relative 'login_page'

class EmailPage < BasePage
  def go_to_email
    login_to_app
    within('.Sidebar') do
      click_on 'EMAILS', visible: true
    end
  end

  def goto_new_message_from_bulk_action
    login_to_app

    within('.Sidebar') do
      find('span', text: 'BULK ACTIONS', visible: true).click
    end
    sleep(2)
    div = find('div[role="menu"]')
    sleep(2)
    within div do
      page.has_text?('Send Message')
      div.find('div[role="menuitem"]', text: 'Send Message', visible: true).click
    end
  end

  def select_first_email_for_testing_association
    subject = send_email_via_qa_automation
    expand_email_with_subject(subject)

    enter_associated_account('Angus', 'Angus Adventures')
    wait_for_loading_animation
    enter_associated_contact('Ole Gunnar', 'Ole Gunnar Solskjaer')
    test_for_the_association('Angus Adventures', 'Ole Gunnar Solskjaer')
    page.current_path
  end

  def unlink_association
    subject = send_email_via_qa_automation
    expand_email_with_subject(subject)

    enter_associated_account('Angus', 'Angus Adventures')
    wait_for_loading_animation
    enter_associated_contact('Ole Gunnar', 'Ole Gunnar Solskjaer')
    test_for_the_association('Angus Adventures', 'Ole Gunnar Solskjaer')

    unlink_association_account
    unlink_association_contact
    ensure_sender_email_does_not_exists_on_accounts_page("subject")
    page.current_path
  end

  def link_non_liscio_association
    subject = send_email_via_qa_automation
    expand_email_with_subject(subject)

    enter_associated_account('Angus', 'Angus Adventures')
    wait_for_loading_animation
    enter_associated_contact('Angus', 'Angus McFife')
    test_for_the_association('Angus Adventures', 'Angus McFife')
    page.current_path
  end

  def unlink_non_liscio_association
    subject = send_email_via_qa_automation
    expand_email_with_subject(subject)

    enter_associated_account('Angus', 'Angus Adventures')
    wait_for_loading_animation
    enter_associated_contact('Angus', 'Angus McFife')
    test_for_the_association('Angus Adventures', 'Angus McFife')

    unlink_association_account
    unlink_association_contact
    page.current_path
  end

  def unlink_association_account
    page_refresh
    click_on_details_caret_button
    page.has_selector?('div.info')
    account = find_all('div.info').first

    # Verify a respective pencil icon (edit) button displays for the "Associated Accounts" and "Associated Contacts" fields
    account.has_selector?('span.button-icon')
    account.find('span.button-icon').click

    # Verify a red "X" button displays next to account name
    account.has_selector?('div[role="button"]')
    account.find('div[role="button"]').click

    # Verify a "Select…" bar replaces the unlinked account name
    page.has_text?('Select...')
    sleep(2)
    click_on_message_header
  end

  def unlink_association_contact
    page_refresh
    click_on_details_caret_button
    page.has_selector?('div.info')
    contact = find_all('div.info').last
    sleep(3)
    # Verify a respective pencil icon (edit) button displays for the "Associated Accounts" and "Associated Contacts" fields
    contact.has_selector?('span.button-icon')
    contact.find('span.button-icon').click

    # Verify a red "X" button displays next to contact name
    contact.has_selector?('div[role="button"]')
    contact.find_all('div[role="button"]').first.click

    # Verify a "Select…" bar replaces the unlinked contact name
    page.has_text?('Select...')
    sleep(2)
    click_on_message_header
  end

  def click_on_first_email
    page.has_selector?('input[type="search"]')
    search_box = find('input[type="search"]')
    search_box.send_keys('auto assoc test')

    # Verify a loading animation displays
    wait_for_loading_animation

    # # Verify the email information and body displays
    page.has_selector?('.EmailBlock')
    page.has_selector?('.EmOne')

    if page.has_text?('automation_qa@liscio.me')
      sleep(3)
      email_list = find('.EmailBlock')
      first_email = email_list.find_all('.EmOne').first
      first_email.click
    end

    email_list = find('.EmailBlock')
    email_list.find_all('.EmOne').first.click

    # Header displays
    page.has_selector?('.EMreply__Block')
    # Email body div shows
    page.has_selector?('.messageExpand')
    page.has_selector?('svg[xmlns="http://www.w3.org/2000/svg"]')
  end

  def enter_associated_account(account_partial_name, account_full_name)
    # Verify an ellipses button displays next to the date and time the email was sent
    page.has_selector?('.ReplyAction')
    message_action = find_all('.ReplyAction').last
    # Verify a drop-down menu displays
    within message_action do
      find_all('span').last.click
      9.times.each do |x|
        page.send_keys(:arrow_down) # Add Account
      end
      page.send_keys(:enter)
    end

    page.has_selector?('.MsgWrap')
    message_body = find_all('.MsgWrap').last
    # Verify the "Associated Contacts" field and "Select…" bar displays
    message_body.has_text?('Select...')
    message_body.has_selector?('div[data-value]')
    message_body.find('div[data-value]').click
    page.send_keys(account_partial_name)
    # Verify full contact name is suggested
    message_body.has_text?(account_full_name)
    page.send_keys(:enter)

    # Click out of the "Select…" bar
    click_on_message_header
    click_on_message_header
  end

  def enter_associated_contact(contact_partial_name, contact_full_name)
    # Verify an ellipses button displays next to the date and time the email was sent
    page.has_selector?('.ReplyAction')
    message_action = find_all('.ReplyAction').last
    # Verify a drop-down menu displays
    within message_action do
      find_all('span').last.click
      10.times.each do |x|
        page.send_keys(:arrow_down) # Add Contact
      end
      page.send_keys(:enter)
    end

    page.has_selector?('.MsgWrap')
    message_body = find_all('.MsgWrap').last
    # Verify the "Associated Accounts" field and "Select…" bar displays
    message_body.has_text?('Select...')
    message_body.has_selector?('div[data-value]')
    message_body.find_all('div[data-value]').last.click
    contact_partial_name.chars.each do |contact_character|
      page.send_keys(contact_character)
      sleep(1)
    end
    # Verify full contact name is suggested
    # Verify "Associated Contacts * Ole Gunnar Solskjaer" displays
    page.has_text?(contact_full_name)
    page.send_keys(:enter)
    sleep(1)
    click_on_message_header
    click_on_message_header
  end

  def click_on_message_header
    wait_for_selector('.EMreply__Head')
    find_all('.EMreply__Head').last.click
  end

  def fetch_sender_subject
    page.has_selector?('.EmHead__Leftcol')
    email_header = find('.EmHead__Leftcol')
    email_header.text
  end

  def ensure_sender_email_does_not_exists_on_accounts_page(subject)
    # Verify "Associated Accounts * Angus Adventures" displays above "Associated Contacts * Ole Gunnar Solskjaer"
    within('.Sidebar') do
      click_on 'ACCOUNTS', visible: true
    end

    fill_in 'account-search', with: 'angus'
    # Verify "Angus Adventures" displays

    page.has_text?('Angus Adventures')
    click_on 'Angus Adventures', visible: true
    page.has_selector?('.nav-item')
    find('.nav-item', text: 'Email').click

    page.has_selector?('.EmailBlock')
    page.has_selector?('.EmOne')

    sleep(3)
    email_list = find('.EmailBlock')
    first_email = email_list.find_all('.EmOne').first
    first_email.click

    subject_on_accounts_page = fetch_sender_subject
    expect(subject).not_to eq(subject_on_accounts_page)
  end

  def test_for_the_association(account_name, contact_name)
    page_refresh
    click_on_details_caret_button
    page.has_selector?('div.info')
    account_and_contact = find_all('div.info')
    account_and_contact.each do |info|
      # Verify "Associated Accounts * account_name" displays
      if info.find('span.label').text == 'Associated Accounts'
        expect(info.text).to include(account_name)
      end
      # Verify "Associated Accounts * contact_name" displays
      if info.find('span.label').text == 'Associated Contacts'
        expect(info.text).to include(contact_name)
      end
    end
  end

  def click_on_details_caret_button
    # Click on the caret button
    email_list = find('.EmailBlock')
    email_list.find_all('.EmOne').first.click

    page.has_selector?('.EMreply__Block')
    reply_block = find_all('.EMreply__Block').last
    reply_block.click
    click_on_message_header
    page.has_selector?('.EmailRecTo')
    div = page.find('.EmailRecTo')
    div.find_all('svg').last.click
    # reply_block.find_all('span.button-icon').last.click
  end

  def ensure_email_pull_only_google
    # Verify user sees “Primary” i.e tabs with relevant email counts
    page.has_text?("Primary")

    # Verify “Select an item to read” is displayed on the right side of the “Primary | {Email Count}” tab page
    page.has_text?('Select an item to read')

    # Read the time stamps for each email
    find_all('.Emdate').first.text

    new_window = open_new_window
    within_window(new_window) do
      visit 'https://mail.google.com' # Replace with the actual Gmail URL
    end
    page.current_path
  end

  def create_draft
    wait_for_loading_animation

    # Click + Email
    click_on '+ Email', visible: true

    # Type 'Draft Firm' in Subject field
    side_window = find('.Aside__Sec', visible: true)
    within side_window do
      fill_in 'subject', with: 'Draft Firm'
    end

    # Wait for 3 seconds, and click on X button of New Mail window
    sleep(3)
    find('.close').click

    # Go to Liscio Drafts section
    nav_links = find_all('.nav-link')
    nav_links.each do |nav_link|
      nav_link.click if nav_link.text.split(' |')[0] == 'Drafts'
    end

    sleep(2)
    page.has_selector?('.EmOne')
    find_all('.EmOne').first.click


    page.has_selector?('.EmailBlock__EmailPrev')
    main_div = find('.EmailBlock__EmailPrev')

    draft_heading = main_div.find('h4').text
    # User should be able to see the message under Drafts section in Liscio
    expect(draft_heading).to eq('Draft Firm')
    page.current_path
  end

  def received_emails_in_lisco_mailbox
    sleep(3)
    # Click + Email
    page.has_text?("Email")
    click_on "+ Email", visible: true

    # Put your own Liscio email address in TO field
    find_by_id('react-select-2-input').click
    page.send_keys('adnan')
    sleep(2)
    page.has_text?('adnan@liscio.me')
    page.send_keys(:tab)

    # Type 'Received Message Firm' in Subject field
    find_by_id('emailSubject').click
    page.send_keys('Received Message Firm')
    page.send_keys(:tab)

    # Type 'This is just a test message.' in the body of email
    iframe = find('iframe[id^="tiny-react_"]')
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('This is just a test message.')
      page.send_keys(:tab)
    end
    # Click on Send button
    click_on "Send", visible: true
    page.current_path
  end

  def sent_items_sync
    sleep(3)
    # Click + Email
    page.has_text?("Email")
    click_on "+ Email", visible: true

    # Put your own Liscio email address in TO field
    find_by_id('react-select-2-input').click
    page.send_keys('adnan')
    target_div = find('.Aside__form')
    wait_for_text(target_div, 'adnan@liscio.me')
    page.send_keys(:tab)

    # Type 'Received Message Firm' in Subject field
    find_by_id('emailSubject').click
    page.send_keys('Received Message Firm')
    page.send_keys(:tab)

    # Type 'This is just a test message.' in the body of email
    iframe = find('iframe[id^="tiny-react_"]')
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('This is just a test message.')
      page.send_keys(:tab)
    end
    # Click on Send button
    click_on "Send", visible: true

    # Go to Liscio Sent section
    click_link "Sent"
    sleep(2)
    page.current_path
  end

  def archive_an_email
    # Under Primary tab, open one mail conversation
    find('div[data-testid="email_0"]').click
    find('div[data-testid="email_0"]').click

    # Click on the Archive icon located below the Search Message field
    find_all('svg[viewBox="0 0 14 15"').first.click
    page.current_path
  end

  def send_new_email
    sleep(3)
    # Click + Email
    page.has_text?("Email")
    click_on "+ Email", visible: true

    # Put your own Liscio email address in TO field
    find_by_id('react-select-2-input').click
    page.send_keys('adnan')
    target_div = find('.Aside__form')
    wait_for_text(target_div, 'adnan@liscio.me')
    page.send_keys(:tab)

    # Type 'Received Message Firm' in Subject field
    find_by_id('emailSubject').click
    page.send_keys('New email test')
    page.send_keys(:tab)

    # Type 'This is just a test message.' in the body of email
    iframe = find('iframe[id^="tiny-react_"]')
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('This is just a test message.')
      page.send_keys(:tab)
    end
    # Click on Send button
    click_on "Send", visible: true

    sleep(2)
    page.current_path
  end

  def send_messages_with_images
    sleep(4)
    search_contact = find_all('input').first
    search_contact.click
    search_contact.send_keys('automation')
    search_contact.send_keys(:enter)
    expect(page).to have_content('Tester, Automation')

    # Scroll if necessary and check boxes to select random contacts
    find_all('.checkbox')[1].click

    # Click Next Step button
    click_on "Next Step", visible: true

    # Click on MESSAGE TITLE field
    find('#react-select-2-input').click
    page.send_keys('This is my TEMPLATE!!')
    page.send_keys(:tab)

    iframe = find('iframe[id^="tiny-react_"]')
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('This is just a test message.')
      page.send_keys(:tab)
    end

    # Verify Upload File modal displays
    find('.fileContainer.text-capitalize', text: 'Browse').click

    # Click TAGS to enter the tag name.
    find_by_id('tags').click
    page.send_keys('Test')
    page.has_text?('Test')
    find('.dropdown-item').click


    file_input = find('input[id="upload_doc"]', visible: :all)
    file_input.attach_file(fixtures_path.join('images', '404.png'))
    sleep(3)

    # Click on Upload button
    click_on "Upload", visible: true
    sleep(2)

    # Click on Draft Message button
    click_on "Draft Message", visible: true

    # Click on Send Message button
    click_on "Send Message", visible: true

    # Click on INBOX in left-hand dashboard nav
    within('.Sidebar') do
      click_on 'INBOX'
    end

    # Click on the Sent tab
    click_on "Sent"

    sleep(2)
    page.current_path
  end

  def reply_an_email
    # Verify the Primary tab and relevant count is selected
    page.has_text?('Primary')

    # Open up the first email for testing
    page.has_selector?('.EmailBlock')
    email_list = find('.EmailBlock')
    within email_list do
      page.has_selector?('.EmOne')
      find_all('.EmOne', visible: true)[3].click
    end

    # Click on the Reply button with a message box and arrow icon
    find_all('div[title="Reply"]').first.click

    # Type random text in email reply content box above the faded original email date and time
    iframe = find('iframe[id^="tiny-react_"]')
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('This is just a test message.')
      page.send_keys(:tab)
    end

    # Scroll and click on Send button
    click_on "Send", visible: true
    page.current_path
  end

  def reply_all_to_email
    # Verify the Primary tab and relevant count is selected
    page.has_text?('Primary')

    # Open up the first email for testing
    page.has_selector?('.EmailBlock')
    email_list = find('.EmailBlock')
    within email_list do
      page.has_selector?('.EmOne')
      find_all('.EmOne', visible: true)[3].click
    end

    # Click on the Reply button with a message box and arrow icon
    find('div[title="Reply"]').click

    # Type random text in email reply content box above the faded original email date and time
    iframe = find('iframe[id^="tiny-react_"]')
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('This is just a test message.')
      page.send_keys(:tab)
    end

    # Scroll and click on Send button
    click_on "Send", visible: true
    page.current_path
  end

  def expand_email_with_subject(subject)
    page.has_selector?('input[type="search"]')
    search_box = find('input[type="search"]')
    search_box.send_keys(subject)

    # Verify a loading animation displays
    wait_for_loading_animation

    # # Verify the email information and body displays
    page.has_selector?('.EmailBlock')
    page.has_selector?('.EmOne')

    if page.has_text?('automation_qa@liscio.me')
      sleep(3)
      email_list = find('.EmailBlock')
      first_email = email_list.find_all('.EmOne').first
      first_email.click
    end

    email_list = find('.EmailBlock')
    email_list.find_all('.EmOne').first.click

    # Header displays
    page.has_selector?('.EMreply__Block')
    # Email body div shows
    page.has_selector?('.messageExpand')
    page.has_selector?('svg[xmlns="http://www.w3.org/2000/svg"]')
  end

  def send_email_via_qa_automation
    login_to_app_as_automation_qa
    subject = send_email_to_adnan_with_unique_timestamp
    login_page.logout
    go_to_email
    subject
  end

  def forward_an_email
    # First send email from automation qa account
    login_to_app_as_automation_qa
    subject = send_email_to_adnan_with_unique_timestamp
    login_page.logout
    go_to_email
    expand_email_with_subject(subject)

    page.has_selector?('.ReplyAction')
    message_action = find_all('.ReplyAction').last
    # Verify a drop-down menu displays
    within message_action do
      find_all('span').last.click
      3.times.each do |x|
        page.send_keys(:arrow_down) # Click on forward
      end
      page.send_keys(:enter)
    end

    sleep(3)
    page.has_selector?('div[data-value]')
    find('div[data-value]').click

    page.send_keys('automation_qa')
    target_div = find('.ReplyEmailWrap', visible: true)
    wait_for_text(target_div, 'automation_qa@liscio.me')
    page.send_keys(:enter)

    click_on 'Send'
    page.current_path
  end

  def add_additional_recipients
    subject = send_email_via_qa_automation
    expand_email_with_subject(subject)

    page.has_selector?('.ReplyAction')
    message_action = find_all('.ReplyAction').last
    # Verify a drop-down menu displays
    within message_action do
      find_all('span').last.click
      page.send_keys(:arrow_down) # Reply
      page.send_keys(:enter)
    end

    # On the additional recipients field, add an additional recipient
    sleep(2)
    input = find_all('input').last
    input.send_keys('adnan@liscio')
    wait_for_text(page, 'adnan@liscio.me')
    input.send_keys(:enter)

    # Enter a random email reply string
    sleep(2)
    iframe = find('iframe[id^="tiny-react_"]')
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('This is just a test message.')
      page.send_keys(:tab)
    end

    # Click on send button
    click_on "Send", visible: true
    page.current_path
  end

  def filter_emails
    subject = send_email_via_qa_automation
    expand_email_with_subject(subject)

    enter_associated_account('Angus', 'Angus Adventures')
    wait_for_loading_animation
    enter_associated_contact('Ole Gunnar', 'Ole Gunnar Solskjaer')
    test_for_the_association('Angus Adventures', 'Ole Gunnar Solskjaer')

    unlink_association_account
    unlink_association_contact
    ensure_sender_email_does_not_exists_on_accounts_page("subject")
    page.current_path
  end

  def reply_email_with_message
    page.has_text?('Primary')

    page.has_selector?('.EmailBlock')
    email_list = find('.EmailBlock')
    within email_list do
      page.has_selector?('.EmOne')
      find_all('.EmOne', visible: true)[3].click
    end

    find('div[title="Reply"]').click

    iframe = find('iframe[id^="tiny-react_"]')
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('This is just a test message.')
      page.send_keys(:tab)
    end

    click_on "Send", visible: true
    page.current_path
  end


  def create_todo_task
    login_to_app_as_automation_qa
    subject = send_email_to_adnan_with_unique_timestamp
    login_page.logout
    go_to_email
    expand_email_with_subject(subject)

    page.has_selector?('.ReplyAction')
    message_action = find_all('.ReplyAction').last
    within message_action do
      find_all('span').last.click
      3.times.each do |x|
        page.send_keys(:arrow_down)
      end
      page.send_keys(:enter)
    end

    sleep(3)
    page.has_selector?('div[data-value]')
    find('div[data-value]').click

    page.send_keys('automation_qa')
    target_div = find('.ReplyEmailWrap', visible: true)
    wait_for_text(target_div, 'automation_qa@liscio.me')
    page.send_keys(:enter)

    click_on 'Send'
    page.current_path
  end

  def create_request_info_task
    subject = send_email_via_qa_automation
    expand_email_with_subject(subject)

    enter_associated_account('Angus', 'Angus Adventures')
    wait_for_loading_animation
    enter_associated_contact('Ole Gunnar', 'Ole Gunnar Solskjaer')
    test_for_the_association('Angus Adventures', 'Ole Gunnar Solskjaer')

    unlink_association_account
    unlink_association_contact
    ensure_sender_email_does_not_exists_on_accounts_page("subject")
    page.current_path
  end

  def create_manage_items_task
    page.has_text?('Primary')

    page.has_selector?('.EmailBlock')
    email_list = find('.EmailBlock')
    within email_list do
      page.has_selector?('.EmOne')
      find_all('.EmOne', visible: true)[3].click
    end

    find('div[title="Reply"]').click

    iframe = find('iframe[id^="tiny-react_"]')
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('This is just a test message.')
      page.send_keys(:tab)
    end

    click_on "Send", visible: true
    page.current_path
  end


  def create_note
    sleep(3)
    page.has_text?("Email")
    click_on "+ Email", visible: true

    find_by_id('react-select-2-input').click
    page.send_keys('adnan')
    target_div = find('.Aside__form')
    wait_for_text(target_div, 'adnan@liscio.me')
    page.send_keys(:tab)

    find_by_id('emailSubject').click
    page.send_keys('Received Message Firm')
    page.send_keys(:tab)

    iframe = find('iframe[id^="tiny-react_"]')
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('This is just a test message.')
      page.send_keys(:tab)
    end
    click_on "Send", visible: true

    click_link "Sent"
    sleep(2)
    page.current_path
  end

  def create_sign_task
    sleep(3)
    page.has_text?("Email")
    click_on "+ Email", visible: true

    find_by_id('react-select-2-input').click
    page.send_keys('adnan')
    sleep(2)
    page.has_text?('adnan@liscio.me')
    page.send_keys(:tab)

    find_by_id('emailSubject').click
    page.send_keys('Received Message Firm')
    page.send_keys(:tab)

    iframe = find('iframe[id^="tiny-react_"]')
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('This is just a test message.')
      page.send_keys(:tab)
    end
    click_on "Send", visible: true
    page.current_path
  end

  def ensure_contact_and_accounts
    page.has_text?("Email")
    click_on "+ Email", visible: true

    find_by_id('react-select-2-input').click
    page.send_keys('adnan')
    target_div = find('.Aside__form')
    wait_for_text(target_div, 'adnan@liscio.me')
    page.send_keys(:tab)

    find_by_id('emailSubject').click
    page.send_keys('Received Message Firm')
    page.send_keys(:tab)

    iframe = find('iframe[id^="tiny-react_"]')
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('This is just a test message.')
      page.send_keys(:tab)
    end
    click_on "Send", visible: true

    click_link "Sent"
    page.current_path
  end

  def attach_image_to_a_message
    go_to_email

    # Create an email with the subject "Message with image attachment"
    find('button', text: '+ Email').click
    find_by_id('react-select-2-input').click
    page.send_keys('automation_qa')
    target_div = find('.Aside__form', visible: true)
    wait_for_text(target_div, 'automation_qa@liscio.me')
    page.send_keys(:tab)

    # Create a message with "Hello, this is a message with an photo attachment"
    find_by_id('emailSubject').click
    subject = "Hello, this is a message with an photo attachment"
    page.send_keys(subject)
    page.send_keys(:tab)

    # Type 'This is just a test message.' in the body of email
    iframe = find('iframe[id^="tiny-react_"]')
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('This is just a test message.')
      page.send_keys(:tab)
    end

    # Attach an image using drag and drop or browse methods
    # Click on Browse link in email section
    file_input = find('input[data-testid="attachment__browse"]', visible: :all)
    file_input.attach_file(fixtures_path.join('images', '404.png'))

    # Select file to attach and upload
    wait_for_text(page, 'Preview')

    # Click on Send button
    click_on 'Send'
    wait_for_text(page, 'Email sent successfully')
    page.current_path
  end

  private

  def send_email_to_adnan_with_unique_timestamp
    within('.Sidebar') do
      page.find('[data-testid="sidebar__emails"]', visible: true)
      click_on 'EMAILS', visible: true
    end

    wait_for_loading_animation

    click_on "+ Email"

    # Put your own Liscio email address in TO field
    find_by_id('react-select-2-input').click
    page.send_keys('adnan')
    target_div = find('.Aside__form', visible: true)
    wait_for_text(target_div, 'adnan@liscio.me')
    page.send_keys(:tab)

    # Type 'Received Message Firm' in Subject field
    find_by_id('emailSubject').click
    subject = get_subject_with_timestamp
    page.send_keys(subject)
    page.send_keys(:tab)

    # Type 'This is just a test message.' in the body of email
    iframe = find('iframe[id^="tiny-react_"]')
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('This is just a test message.')
      page.send_keys(:tab)
    end
    # Click on Send button
    click_on "Send", visible: true

    return subject
  end

  def get_subject_with_timestamp
    time_stamp = Time.now.to_i
    "auto assoc test #{time_stamp}"
  end

  def login_to_app_as_automation_qa
    login_page.visit_login_page

    login_page.sign_in_with_automation_qa
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
