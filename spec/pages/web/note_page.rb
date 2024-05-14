require_relative './base_page'
require_relative './login_page'

class NotePage < BasePage
  def go_to_note_from_add_new
    login_to_app
    within('.Sidebar') do
      find('span', text: 'ADD NEW').click
    end

    # Verify a drop-down menu displays
    page.has_css?('div[role="menu"]')
    div = find('div[role="menu"]')

    page.has_css?('div[role="menuitem"]')
    sleep 2
    div.find('div[role="menuitem"]', text: 'Note').click
  end

  def go_to_home
    login_to_app
  end

  def create_note_from_add_new
    # Click on ADD NEW from the left side nav of the dashboard screen
    # Verify a drop-down menu displays
    # Click on "Note" option on the drop-down menu
    go_to_note_from_add_new

    # Verify "CREATE NOTES" page loads
    wait_for_text(page, 'CREATE NOTE')
    expect(page).to have_current_path('/note/new')
    sleep(3)

    # Click on the "FOR ACCOUNT" field
    find_all('div[data-value]').first.click

    # Verify user can scroll through alphabetical list of accounts for selection
    # Begin typing the partial name of an account
    # Verify an ACCOUNTS box displays with the account full name
    # Click on the account name
    page.send_keys('abc testing')
    wait_for_text(page, 'ABC Testing Inc.')
    page.send_keys(:enter)

    # Verify a loading animation displays
    wait_for_loading_animation

    # Click on "FOR CONTACT" field
    find_all('div[data-value]').last.click

    # Verify "No options" displays
    page.send_keys('adnan qa')
    wait_for_text(page, 'Adnan QA QA')
    page.send_keys(:enter)

    # Click on the TITLE field
    title_selector = 'input[data-testid="notes__title"]'
    wait_for_selector(title_selector)
    find(title_selector).click

    # Type a title "From Add new"
    page.send_keys('Add New')

    # Click on the DESCRIPTION field
    # Type note description "Test"
    iframe = find('iframe[id^="tiny-react_"]')
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('This is just a test message.')
      page.send_keys(:tab)
    end

    # Click on "Create Notes" button
    click_on 'Create Note'
    wait_for_text(page, 'Notes Created Successfully')
    page.current_path
  end

  def create_note_from_dashboard_inbox_list_level
    # Create a test inbox message to user
    message = create_a_random_message
    login_page.logout

    # Click on HOME from the left side nav of the dashboard screen
    go_to_home

    # Verify message count displays
    wait_for_text(page, 'Liscio Messages')

    # Verify most recent inbox messages display
    wait_for_text(page, message)

    # Verify ellipses button displays for each message
    # Click on the ellipses button of message with subject titled "Multiple image"
    # Verify a drop-down menu displays
    # Click on "Create Note"
    find_all('i.icon-more').first.click
    2.times.each do |x|
      sleep 0.5
      page.send_keys(:arrow_down) # Click on Create Note
    end
    sleep 0.5
    page.send_keys(:enter)

    # Verify CREATE NOTES modal displays
    modal = find('.modal-body')
    # Verify associated account name displays automatically in FOR ACCOUNT field
    # Verify message subject "Multiple image" displays in the TITLE field
    wait_for_text(page, message)

    # Click on the "FOR ACCOUNT" field
    find_all('div[data-value]').first.click

    # Verify user can scroll through alphabetical list of accounts for selection
    # Begin typing the partial name of an account
    # Verify an ACCOUNTS box displays with the account full name
    # Click on the account name
    page.send_keys('abc testing')
    wait_for_text(page, 'ABC Testing Inc.')
    page.send_keys(:enter)

    # Verify a loading animation displays
    wait_for_loading_animation

    # Click on "FOR CONTACT" field
    find_all('div[data-value]').last.click

    # Verify "No options" displays
    page.send_keys('adnan qa')
    wait_for_text(page, 'Adnan QA QA')
    page.send_keys(:enter)

    # Click on "Create Notes" button
    click_on 'Create Note'
    wait_for_text(page, 'Notes Created Successfully')
    page.current_path
  end

  def delete_message
    # Generate a message
    message = create_a_random_message

    # click on sent and recently sent message
    sent_selector = 'button[data-testid="inbox__sent"]'
    wait_for_selector(sent_selector)
    find(sent_selector).click

    # In messages, verify recipient sees the email subject
    wait_for_text(page, message)

    # Click on the message, verify the email body displays
    find('span', text: message).click

    # Verify trash icon button displays next to message date and time
    trash_icon_container = find('.messageAction')
    trash_icon = trash_icon_container.find_all('a').first

    # Click on trash icon
    trash_icon.click

    # Verify a confirmation prompt displays titled "Are you sure you want to delete this message?"
    wait_for_text(page, 'Are you sure want to delete this message?')

    # Click on the "Yes" button
    click_on 'Yes'

    # Verify "Message removed successfully" toast displays
    wait_for_text(page, 'Message removed successfully')

    inbox_selector = 'div[data-testid="sidebar__inbox"]'
    wait_for_selector(inbox_selector)
    find(inbox_selector).click

    # Refresh the browser
    page_refresh

    # Verify deleted message is no longer on message list
    expect(page).not_to have_content(message)
    page.current_path
  end

  def create_note_without_duplicates
    # Log in to Firm User/Client Account
    login_to_app

    # From Home Dashboard, click on Accounts from Left Nav menu
    account_selector = 'div[data-testid="sidebar__accounts"]'
    wait_for_selector(account_selector)
    find(account_selector).click
    sleep 2
    page_refresh

    page.has_selector?('#account-search')
    search_box = find_by_id('account-search')
    # Begin typing restricted account name "Beatles"
    search_box.send_keys('abc testing')

    # Verify full account name displays
    page.has_text?('ABC Testing Inc')

    # Click on ABC Testing Inc
    wait_for_selector('.tdBtn.row')
    find('.tdBtn.row').click

    # Click on Notes tab
    notes_tab_selector = 'button[data-testid="inbox__notes"]'
    wait_for_selector(notes_tab_selector)
    find(notes_tab_selector).click

    # Click on + Note button
    wait_for_selector('a.btn')
    find('a.btn').click

    # Select For Contact: adnan qa qa
    find('input[id^="react-select-"]').click
    'adnan qa'.chars.each { |char| page.send_keys(char) }
    wait_for_text(page, 'Adnan QA QA')
    page.send_keys(:tab)

    # Enter valid description
    iframe = find('iframe[id^="tiny-react_"]')
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('This is just a test message.')
      page.send_keys(:tab)
    end

    # Click on Create Note button
    click_on 'Create Note'
    wait_for_text(page, 'Notes Created Successfully.')
    page.current_path
  end

  def create_note_from_inbox_message_level
    message = create_a_random_message
    login_page.logout

    # Click on HOME from the left side nav of the dashboard screen
    go_to_home

    # Verify message count displays
    wait_for_text(page, 'Liscio Messages')

    # Verify most recent inbox messages display
    wait_for_text(page, message)

    # Click to open the message thread titled "#{message}"
    wait_for_text(page, message)
    find('span', text: message).click

    # Verify ellipses button displays for each message
    # Click on the ellipses button of message with subject titled "Multiple image"
    # Verify a drop-down menu displays
    # Click on "Create Note"
    find_all('i.icon-more').first.click
    2.times.each do |x|
      sleep 0.5
      page.send_keys(:arrow_down) # Click on Create Note
    end
    sleep 0.5
    page.send_keys(:enter)

    fill_note_modal_with_account_and_contact

    # Click on "Create Notes" button
    click_on 'Create Note'
    wait_for_text(page, 'Notes Created Successfully')
    page.current_path
  end

  def fill_note_modal_with_account_and_contact
    # Click on the "FOR ACCOUNT" field
    find_all('div[data-value]').first.click

    # Verify user can scroll through alphabetical list of accounts for selection
    # Begin typing the partial name of an account
    # Verify an ACCOUNTS box displays with the account full name
    # Click on the account name
    page.send_keys('abc testing')
    wait_for_text(page, 'ABC Testing Inc.')
    page.send_keys(:enter)

    # Verify a loading animation displays
    wait_for_loading_animation

    # Click on "FOR CONTACT" field
    find_all('div[data-value]').last.click

    # Verify "No options" displays
    page.send_keys('adnan qa')
    wait_for_text(page, 'Adnan QA QA')
    page.send_keys(:enter)
  end

  def create_note_from_inbox_message_thread_level
    message_title = create_a_random_message
    login_page.logout

    # Click on HOME from the left side nav of the dashboard screen
    go_to_home

    # Verify message count displays
    wait_for_text(page, 'Liscio Messages')

    # Verify most recent inbox messages display
    wait_for_text(page, message_title)

    # Click to open the message thread titled "#{message}"
    wait_for_text(page, message_title)
    find('span', text: message_title).click

    # Verify "Create Note" button (note icon) displays in the top right corner of the page
    create_note_button = 'div[title="Create Note"]'
    wait_for_selector(create_note_button)

    # Click on "Create Note" button
    find(create_note_button).click

    fill_note_modal_with_account_and_contact

    # Click on "Create Notes" button
    click_on 'Create Note'
    wait_for_text(page, 'Notes Created Successfully')
    page.current_path
  end

  def create_note_from_account_notes
    login_to_app

    # Click on ACCOUNTS tab from the left-hand navigation menu
    accounts_selector = 'div[data-testid="sidebar__accounts"]'
    wait_for_selector(accounts_selector)
    find(accounts_selector).click

    # Verify ALL ACCOUNTS list view page displays
    expect(page).to have_current_path('/accounts')

    search_account_selector = 'input[data-testid="account__search_input"]'
    if !page.has_selector?(search_account_selector)
      page_refresh
    end

    account_search = find(search_account_selector)
    account_search.send_keys('angus adventures')
    page.has_text?('Angus Adventures')

    find('span', text: 'Angus Adventures').click

    # Go to Details tab
    nav_notes_menu_selector = 'button[data-testid="inbox__notes"]'
    wait_for_selector(nav_notes_menu_selector)
    find(nav_notes_menu_selector).click

    # Click on the "Notes" tab in the menu bar
    find('a', text: '+ Note').click

    # Verify CREATE NOTES page displays
    expect(page.current_path).to include('note/new')
    sleep 2

    fill_with_data_to_create_note

    # Click on the "Create Notes" button
    click_on 'Create Note'
    wait_for_text(page, 'Notes Created Successfully')
    page.current_path
  end

  def create_note_from_dashboard_accounts_messages
    goto_account_search_page
    # Go to Messages tab
    nav_notes_menu_selector = 'button[data-testid="inbox__messages"]'
    wait_for_selector(nav_notes_menu_selector)
    find(nav_notes_menu_selector).click
    sleep 2
    wait_for_loading_animation

    # Click on the ellipses button on the most recent message in the thread
    find_all('i.icon-more').first.click

    # Verify dropdown menu displays
    # Click on the "Create Note" option
    sleep 1
    page.send_keys(:arrow_down) # Click on Create Note
    sleep 1
    page.send_keys(:enter)

    sleep 2
    fill_with_data_to_create_note

    # Click on the "Create Notes" button
    click_on 'Create Note'
    wait_for_text(page, 'Notes Created Successfully')
    page.current_path
  end

  def create_note_from_dashboard_contacts_notes
    login_to_app

    # Click on CONTACTS tab from the left-hand navigation menu
    contacts_selector = 'div[data-testid="sidebar__contacts"]'
    wait_for_selector(contacts_selector)
    find(contacts_selector).click

    # Verify ALL ACCOUNTS list view page displays
    expect(page).to have_current_path('/contacts', ignore_query: true)

    search_contact_selector = 'input[data-testid="contact__search_input"]'
    if !page.has_selector?(search_contact_selector)
      page_refresh
    end

    contact_search = find(search_contact_selector)
    contact_search.send_keys('ole gunnar')
    page.has_text?('Solskjaer, Ole Gunnar')

    find('span', text: 'Solskjaer, Ole Gunnar').click

    # Click on the "Notes" tab in the top menu bar
    nav_notes_menu_selector = 'button[data-testid="inbox__notes"]'
    wait_for_selector(nav_notes_menu_selector)
    find(nav_notes_menu_selector).click

    # Click on the "Notes" tab in the menu bar
    find('a', text: '+ Note').click

    # Verify CREATE NOTES page displays
    expect(page.current_path).to include('note/new')
    sleep 2

    fill_with_data_to_create_note_with_preselected_contact

    # Click on the "Create Notes" button
    click_on 'Create Note'
    wait_for_text(page, 'Notes Created Successfully')
    page.current_path
  end

  def create_note_from_dashboard_contacts_messages
    goto_contact_search_page
    page.has_text?('Solskjaer, Ole Gunnar')

    find('span', text: 'Solskjaer, Ole Gunnar').click

    # Click on the "Messages" tab in the top menu bar
    nav_notes_menu_selector = 'button[data-testid="inbox__messages"]'
    wait_for_selector(nav_notes_menu_selector)
    find(nav_notes_menu_selector).click
    sleep 2
    message_search_selector = '#message-search'
    wait_for_selector(message_search_selector)

    # Click on the ellipses button on the most recent message in the thread
    find_all('i.icon-more').first.click

    # Verify dropdown menu displays
    # Click on the "Create Note" option
    sleep 1
    page.send_keys(:arrow_down) # Click on Create Note
    sleep 1
    page.send_keys(:enter)

    fill_with_data_to_create_note

    # Click on the "Create Notes" button
    click_on 'Create Note'
    wait_for_text(page, 'Notes Created Successfully')
    page.current_path
  end

  def edit_note_with_text_formatting
    login_to_app

    # Click on ACCOUNTS from the left side nav of the dashboard screen
    account_selector = 'div[data-testid="sidebar__accounts"]'
    wait_for_selector(account_selector)
    find(account_selector).click

    # Verify ALL ACCOUNTS list view page displays
    expect(page).to have_current_path('/accounts')

    # Reload page if search bar does not show up
    search_account_selector = 'input[data-testid="account__search_input"]'
    if !page.has_selector?(search_account_selector)
      page_refresh
    end

    account_search = find(search_account_selector)
    account_search.send_keys('angus adventures')
    page.has_text?('Angus Adventures')

    find('span', text: 'Angus Adventures').click

    # Go to Notes tab
    nav_notes_menu_selector = 'button[data-testid="inbox__notes"]'
    wait_for_selector(nav_notes_menu_selector)
    find(nav_notes_menu_selector).click

    wait_for_selector('.row.tdBtn')
    find_all('.row.tdBtn').first.click

    edit_a_note_with_formatting

    # Click on the "Update Notes" button
    click_on 'Update Note'

    # Verify a loading animation of the Liscio logo displays
    wait_for_loading_animation

    # Notes Updated Successfully
    wait_for_text(page, 'Notes Updated Successfully')
    page.current_path
  end

  private

  def goto_contact_search_page
    login_to_app

    # Click on CONTACTS tab from the left-hand navigation menu
    contacts_selector = 'div[data-testid="sidebar__contacts"]'
    wait_for_selector(contacts_selector)
    find(contacts_selector).click

    # Verify ALL ACCOUNTS list view page displays
    expect(page).to have_current_path('/contacts', ignore_query: true)

    search_contact_selector = 'input[data-testid="contact__search_input"]'
    if !page.has_selector?(search_contact_selector)
      page_refresh
    end

    contact_search = find(search_contact_selector)
    'ole gunnar'.chars.each { |char|
      contact_search.send_keys(char)
      sleep(1)
    }
  end

  def goto_account_search_page
    login_to_app

    # Click on ACCOUNTS tab from the left-hand navigation menu
    accounts_selector = 'div[data-testid="sidebar__accounts"]'
    wait_for_selector(accounts_selector)
    find(accounts_selector).click

    # Verify ALL ACCOUNTS list view page displays
    expect(page).to have_current_path('/accounts')

    search_account_selector = 'input[data-testid="account__search_input"]'
    if !page.has_selector?(search_account_selector)
      page_refresh
    end

    account_search = find(search_account_selector)
    account_search.send_keys('angus adventures')
    page.has_text?('Angus Adventures')

    find('span', text: 'Angus Adventures').click
  end

  def edit_a_note_with_formatting
    wait_for_selector('.modal-content')
    notes_modal = find('.modal-content')

    within notes_modal do
      # Click on the ellipses button on the most recent message in the thread
      find_all('i.icon-more').first.click

      2.times.each do |x|
        sleep 0.5
        page.send_keys(:arrow_down) # Click on Edit Note
      end
      sleep 0.5
      page.send_keys(:enter)
    end

    description_iframe = find('iframe[id^="tiny-react_"]')
    within_frame(description_iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys(:enter)
      page.send_keys(:enter)

      page.send_keys(:control, 'u')
      page.send_keys('underlined text')
      page.send_keys(:control, 'u')
      page.send_keys(:enter)
      page.send_keys(:control, 'b')
      page.send_keys('bold text')
      page.send_keys(:tab)
    end
  end

  def fill_with_data_to_create_note_with_preselected_contact
    page.send_keys(:tab)
    'angus adventures'.chars.each { |char| page.send_keys(char) }
    page.has_text?('Angus Adventures')
    page.send_keys(:enter)

    # Verify "Ole Gunnar Solskjaer" is prefilled in the FOR CONTACT field
    contact = find_all('.labelValue').last.text
    expect(contact).to include('Ole Gunnar Solskjaer')

    # Type title name "From Account Notes"
    fill_in 'taskTitle', with: 'From Account Notes'

    # Click on the DESCRIPTION field and type "Test"
    iframe = find('iframe[id^="tiny-react_"]')
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('This is just a test message.')
      page.send_keys(:tab)
    end
  end

  def fill_with_data_to_create_note
    # Verify "Angus Adventures" is prefilled in the FOR ACCOUNT field
    for_account_selector = 'div[data-testid="notes__for_account"]'
    wait_for_selector(for_account_selector)
    prefilled_account = find(for_account_selector).text
    expect(prefilled_account).to include('Angus Adventures')

    # Click on the Contact field
    find_all('div[data-value]').last.click
    'adnan qa'.chars.each { |char| page.send_keys(char) }
    page.has_text?('Adnan QA QA')
    page.send_keys(:enter)

    # Type title name "From Account Notes"
    fill_in 'taskTitle', with: 'From Account Notes'

    # Click on the DESCRIPTION field and type "Test"
    iframe = find('iframe[id^="tiny-react_"]')
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('This is just a test message.')
      page.send_keys(:tab)
    end
  end

  def create_a_random_message
    login_to_app_as_automation_qa

    inbox_selector = 'div[data-testid="sidebar__inbox"'
    wait_for_selector(inbox_selector)
    find(inbox_selector).click

    wait_for_text(page, '+ Message')
    click_link '+ Message'
    time_stamp = Time.now.to_i
    subject = "Message_#{time_stamp}"

    within('.modal-dialog') do
      find('a[data-testid="onFocusButton"]').click

      page.has_selector?('div[data-value]')
      recipient = fill_in 'messageRecipient', with: 'adnan ghaffar'
      # Verify the recipient's name displays in the TO field
      page.has_text?('Adnan Ghaffar')
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
        body_div.send_keys("body")
      end

      click_on 'Send'
    end
    subject
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
