require_relative './base_page'
require_relative './login_page'

class AccountPage < BasePage
  def go_to_account
    login_to_app
    click_on_sidebar_account_menu

    # If page is not loaded properly refresh it
    unless page.has_selector?('#account-search')
      page_refresh
      wait_for_loading_animation
    end
  end

  def go_to_account_with_client
    # login_to_app_as_client
    login_to_app_as_active_liscio_client
    click_on_sidebar_account_menu
  end

  def go_to_account_as_employee
    login_to_app_as_employee
    click_on_sidebar_account_menu
  end

  def go_to_files
    login_to_app
    click_on_sidebar_files_menu
  end

  def go_to_message_from_add_new_as_firm_admin
    login_to_app
    within('.Sidebar') do
      find('span', text: 'ADD NEW').click
    end

    # Verify a drop-down menu displays
    page.has_css?('div[role="menu"]')
    div = find('div[role="menu"]')

    page.has_css?('div[role="menuitem"]')
    sleep 2
    div.find('div[role="menuitem"]', text: 'Message').click
    page_refresh
  end

  def go_to_message_from_add_new
    login_to_app
    within('.Sidebar') do
      find('span', text: 'ADD NEW').click
    end

    # Verify a drop-down menu displays
    page.has_css?('div[role="menu"]')
    div = find('div[role="menu"]')

    page.has_css?('div[role="menuitem"]')
    sleep 2
    div.find('div[role="menuitem"]', text: 'Message').click
    page_refresh
  end

  def go_to_contact
    login_to_app
    contact_selector = 'div[data-testid="sidebar__contacts"]'
    contact_button = find(contact_selector)
    wait_for_selector(contact_selector)
    contact_button.click

    expect(page).to have_current_path('/contacts')
    sleep(3)
    page_refresh
  end

  def go_to_account_from_add_new
    login_to_app
    within('.Sidebar') do
      find('span', text: 'ADD NEW').click
    end

    # Verify a drop-down menu displays
    page.has_css?('div[role="menu"]')
    div = find('div[role="menu"]')

    page.has_css?('div[role="menuitem"]')
    sleep 2
    div.find('div[role="menuitem"]', text: 'Account').click
    sleep 3
    page_refresh
  end

  def click_on_sidebar_account_menu
    account_selector = 'div[data-testid="sidebar__accounts"]'
    account_button = find(account_selector)
    wait_for_selector(account_selector)
    account_button.click
  end

  def click_on_sidebar_files_menu
    files_selector = 'div[data-testid="sidebar__files"]'
    files_button = find(files_selector)
    wait_for_selector(files_selector)
    files_button.click
  end

  def click_on_sidebar_notification
    notification_selector = 'div[data-testid="sidebar__notifications"]'
    notification_button = find(notification_selector)
    wait_for_selector(notification_selector)
    notification_button.click
  end

  def close_expanded_mail
    # Click on first account for testing
    expect(page).to have_current_path('/accounts')

    search_account_selector = 'input[data-testid="account__search_input"]'
    if !page.has_selector?(search_account_selector)
      page_refresh
    end

    account_search = find(search_account_selector)
    account_search.send_keys('abc testing in')
    page.has_text?('ABC TESTING INC.')
    wait_for_selector('.tdBtn')
    find_all('.tdBtn').first.click

    # Click one email
    nav_email_menu_selector = 'button[data-testid="inbox__emails"]'
    wait_for_selector(nav_email_menu_selector)
    find(nav_email_menu_selector).click

    # Open up the first email for testing
    first_email_selector = 'div[data-testid="email_0"]'
    wait_for_selector(first_email_selector)
    find(first_email_selector).click

    # Expand the loaded email
    page.has_css?('.email-tool-bar')
    tool_bar = find('.email-tool-bar')
    tool_bar.find_all('.button-icon').last.click

    # Close the expended view
    page.has_css?('#CLOSE')
    find_by_id('CLOSE').click

    # Close button should disappeaer
    expect(page).not_to have_css('#CLOSE')
    page.current_path
  end

  def unable_to_view_as_firm_user
    # Look for ABC Testing Inc. and click it
    click_link "ABC Testing Inc."

    # Go to Details tab
    contact_detail_path = page.current_path
    page.has_css?('.nav')
    nav = find('.nav')
    page.has_text?('Details')
    nav_links = find_all('.nav-link')
    nav_links.find { |n| n.text == 'Details' }.click

    # Click on the more options (...) button on the upper right corner
    find('.icon-more').click

    # Click Edit Account
    click_on "Edit Account"

    # Check the Restricted Account? checkbox
    find_all('.checkbox').first.click

    # Click Update Account button
    find_all('button', text: "Update Account").first.click

    # Click Accounts tab from left nav menu
    within('.Sidebar') do
      click_on 'ACCOUNTS'
    end
    expect(page).to have_current_path('/accounts')

    # Look for ABC Testing Inc.
    click_link "ABC Testing Inc."

    page.current_path
  end

  def able_to_view_restricted_account
    # Look for ABC Testing Inc.
    click_link "ABC Testing Inc."
    page.current_path
  end

  def unable_to_view_as_employee_user
    go_to_account
    # Look for ABC Testing Inc. and click it
    expect(page).to have_current_path('/accounts')

    sleep 2
    search_account_selector = 'input[data-testid="account__search_input"]'
    if !page.has_selector?(search_account_selector)
      page_refresh
    end

    sleep 2
    wait_for_selector(search_account_selector)
    account_search = find(search_account_selector)
    'abcd testing inc'.chars.each { |ch| account_search.send_keys(ch) }
    wait_for_text(page, 'ABCD Testing Inc')
    click_on 'ABCD Testing Inc.'

    # Go to Details tab
    nav_detail_menu_selector = 'button[data-testid="inbox__details"]'
    wait_for_selector(nav_detail_menu_selector)
    find(nav_detail_menu_selector).click

    # Click on the more options (...) button on the upper right corner
    find('.icon-more').click

    # Click Edit Account
    click_on "Edit Account"

    # Restrict/ Unrestrict this account
    expect(page.current_path).to include('/account/edit/')
    find_all('div.checkbox').first.click

    # Click Update Account button
    find_all('button', text: "Update Account").first.click

    login_page.logout
    go_to_account_as_employee

    # Look for ABC Testing Inc. and click it
    expect(page).to have_current_path('/accounts')

    search_account_selector = 'input[data-testid="account__search_input"]'
    if !page.has_selector?(search_account_selector)
      page_refresh
    end

    wait_for_selector(search_account_selector)
    account_search = find(search_account_selector)
    account_search.send_keys('abcd test')
    wait_for_loading_animation
    expect(page).to have_content('No Records Found')
    expect(page).not_to have_content('ABCD Testing Inc')

    # Todo unrestirct that account
    login_page.logout
    go_to_account
    # Look for ABC Testing Inc. and click it
    expect(page).to have_current_path('/accounts')

    search_account_selector = 'input[data-testid="account__search_input"]'
    if !page.has_selector?(search_account_selector)
      page_refresh
    end

    sleep 2
    wait_for_selector(search_account_selector)
    account_search = find(search_account_selector)
    'abcd testing inc'.chars.each { |ch| account_search.send_keys(ch) }
    page.has_text?('ABCD Testing Inc')
    click_on 'ABCD Testing Inc.'

    # Go to Details tab
    nav_detail_menu_selector = 'button[data-testid="inbox__details"]'
    wait_for_selector(nav_detail_menu_selector)
    find(nav_detail_menu_selector).click

    # Click on the more options (...) button on the upper right corner
    find('.icon-more').click

    # Click Edit Account
    click_on "Edit Account"

    # Restrict/ Unrestrict this account
    expect(page.current_path).to include('/account/edit/')
    find_all('div.checkbox').first.click

    # Click Update Account button
    find_all('button', text: "Update Account").first.click

    page.current_path
  end

  def view_restricted_account_as_employee
    # Look for ABC Testing Inc.
    expect(page).to have_current_path('/accounts')

    search_account_selector = 'input[data-testid="account__search_input"]'
    if !page.has_selector?(search_account_selector)
      page_refresh
    end

    account_search = find(search_account_selector)
    'abc inc'.chars.each { |ch| page.send_keys(ch) }
    page.has_text?('ABC Inc')
    find_all('.row').first.click
    page.current_path
  end

  def receive_message_notification
    find('button[data-testid="message__to_field"]').click
    find('input[id="messageRecipient"]').click

    page.send_keys('automation qa')
    page.has_text?('Automation QA')
    page.send_keys(:enter)

    find('input[id="messageAccount"]').click
    'abc inc'.chars.each { |ch| page.send_keys(ch) }
    page.has_text?('ABC Inc')

    page.send_keys(:enter)

    click_on "Ok"

    find('input[id="NewMessage__SelectTemplate"]').click
    page.send_keys("Testing")
    page.send_keys(:tab)
    iframe = find('iframe[id^="tiny-react_"]')
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('This is just a test message.')
      page.send_keys(:tab)
    end

    click_on "Send"
    login_page.logout
    go_to_notifications
  end

  def go_to_notifications
    login_to_app_as_automation_qa
    click_on_sidebar_notification
    page.current_path
  end

  def receive_message_notification_on_update
    sleep 4
    page_refresh

    sleep 3
    find_all('.row')[1].hover
    find('button[id^="Tooltip-edit"]').click
    sleep 3
    find_by_id('website').click
    page.send_keys('www.example.com')
    page.send_keys(:tab)

    find_all('.btn.btn-primary').first.click
    login_page.logout
    go_to_notifications
  end

  def receive_message_notification_on_employee
    page_refresh
    sleep 4

    find_all('.row')[1].hover
    find('button[id^="Tooltip-edit"]').click

    find_by_id('website').click
    page.send_keys('')
    page.send_keys(:tab)

    find_all('.btn.btn-primary').first.click
    login_page.logout
    go_to_notifications
  end

  def receive_message_notification_on_client
    page_refresh
    sleep 4

    find_all('.row')[1].hover
    find('button[id^="Tooltip-edit"]').click

    find_by_id('website').click
    fill_in 'website', with: ''
    fill_in 'website', with: 'www.example.com'

    find_all('.btn.btn-primary').first.click
    login_page.logout
    go_to_notifications
  end

  def receive_message_notification_as_employee
    wait_for_selector('.row')
    find_all('.row')[1].hover
    find('button[id^="Tooltip-edit"]').click

    find_by_id('website').click
    fill_in 'website', with: ''
    fill_in 'website', with: 'www.example.com'

    find_all('button', text: 'Update Account').first.click
    login_page.logout
    go_to_notifications
  end

  def receive_message
    sleep 2
    page_refresh
    sleep 2

    find('button[data-testid="message__to_field"]').click
    find('input[id="messageRecipient"]').click

    page.send_keys('automation qa')
    page.has_text?('Automation QA')
    page.send_keys(:enter)

    find('input[id="messageAccount"]').click
    page.send_keys('ABC Inc')
    page.send_keys(:enter)

    click_on "Ok"

    find('input[id="NewMessage__SelectTemplate"]').click
    page.send_keys("Testing")
    page.send_keys(:tab)
    iframe = find('iframe[id^="tiny-react_"]')
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('This is just a test message.')
      page.send_keys(:tab)
    end

    click_on 'Send'

    login_page.logout
    go_to_notifications
  end

  def receive_message_not_cst
    sleep 2
    page_refresh
    sleep 2

    find('button[data-testid="message__to_field"]').click
    find('input[id="messageRecipient"]').click

    page.send_keys('automation qa')
    page.has_text?('Automation QA')
    page.send_keys(:enter)

    find('input[id="messageAccount"]').click
    'abc inc'.chars.each { |ch| page.send_keys(ch) }
    page.has_text?('ABC Inc')
    page.send_keys(:enter)

    click_on "Ok"

    find('input[id="NewMessage__SelectTemplate"]').click
    page.send_keys("Testing")
    page.send_keys(:tab)
    iframe = find('iframe[id^="tiny-react_"]')
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('This is just a test message.')
      page.send_keys(:tab)
    end

    click_on 'Send'

    login_page.logout
    go_to_notifications
  end

  def account_contact_uploaded_file
    sleep 2
    page_refresh
    sleep 2

    sleep 2
    page_refresh
    sleep 2

    find('a[data-testid="files__upload_file_btn"]').click

    to_field_selector = '.cstRtags'
    wait_for_selector(to_field_selector)
    find(to_field_selector).click
    'adnan ghaffar'.chars.each { |ch| page.send_keys(ch) }
    page.send_keys(:enter)
    click_on 'Ok'
    find_by_id('tagId').click
    page.send_keys('Test')
    page.has_text?('Test')
    find('.dropdown-item').click

    # Click on Browse link in File section
    file_input = find('input[id="upload_doc"]', visible: :all)
    file_input.attach_file(fixtures_path.join('images', '404.png'))

    # Select file to attach and upload
    wait_for_text(page, 'Preview')

    # Click on the Upload button.
    click_on "Upload"

    login_page.logout
    go_to_notifications
  end

  def account_contact_uploaded_file_employee
    sleep 2
    page_refresh
    sleep 2

    find('a[data-testid="files__upload_file_btn"]').click

    to_field_selector = '.cstRtags'
    wait_for_selector(to_field_selector)
    find(to_field_selector).click
    'adnan ghaffar'.chars.each { |ch| page.send_keys(ch) }
    page.send_keys(:enter)
    click_on 'Ok'
    find_by_id('tagId').click
    page.send_keys('Test')
    page.has_text?('Test')
    find('.dropdown-item').click

    # Click on Browse link in File section
    file_input = find('input[id="upload_doc"]', visible: :all)
    file_input.attach_file(fixtures_path.join('images', '404.png'))

    # Select file to attach and upload
    wait_for_text(page, 'Preview')

    # Click on the Upload button.
    click_on "Upload"

    login_page.logout
    go_to_notifications
  end

  def create_account_from_add_new
    find('input[data-testid="account__account_name"]').click
    page.send_keys("Testing Account")
    page.send_keys(:tab)

    find("#react-select-2-input").click
    page.send_keys("Individual")
    page.send_keys(:tab)

    find("#react-select-3-input").click
    page.send_keys("Client")
    page.send_keys(:tab)

    click_on "Create Account"

    within('.Sidebar') do
      find('span', text: 'ACCOUNTS').click
    end
    page.current_path
  end

  def create_account_from_accounts
    sleep 3
    find('a[data-testid="account__create_account"]').click
    find('input[data-testid="account__account_name"]').click
    page.send_keys("Testing Account")
    page.send_keys(:tab)

    find("#react-select-2-input").click
    page.send_keys("Individual")
    page.send_keys(:tab)

    find("#react-select-3-input").click
    page.send_keys("Client")
    page.send_keys(:tab)

    click_on "Create Account"

    within('.Sidebar') do
      find('span', text: 'ACCOUNTS').click
    end
    page.current_path
  end

  def create_account_from_contacts
    find_all('.row')[2].click
    click_on "Accounts"

    find('.btn.dropdown-toggle.btn-primary').click
    click_on "New Account"

    find('#react-select-2-input').click
    page.send_keys("Primary")
    page.send_keys(:tab)

    find('input[data-testid="account__account_name"]').click
    page.send_keys("Testing Account")
    page.send_keys(:tab)

    find('div[data-testid="account__entity_type"]').click
    page.send_keys("Individual")
    page.send_keys(:tab)

    find("#react-select-4-input").click
    page.send_keys("Client")
    page.send_keys(:tab)
    find('.close').click

    within('.Sidebar') do
      find('span', text: 'ACCOUNTS').click
    end
    page.current_path
  end

  def ensure_visibility_is_restricted
    go_to_account

    # Click on the SEARCH BAR then type "ANGUS ADVENTURES".
    search_account_selector = 'input[data-testid="account__search_input"]'
    account_search = find(search_account_selector)
    account_search.send_keys('ANGUS ADVE')
    wait_for_loading_animation
    wait_for_text(page, 'Angus Adventures')
    sleep(3)

    # Click on any part of the row / line item to show the TIMELINE
    table = find('.tab-content')
    table.first('a').click

    # Verify alert message display.
    alert_text = find('.custom-firm-alert').text
    expect(alert_text).to eq('Payment for this account has failed. Contact client.')

    # Click on DETAILS tab.
    details_tab_selector = 'button[data-testid="inbox__details"]'
    wait_for_selector(details_tab_selector)
    find(details_tab_selector).click

    page.current_path
  end

  def ensure_user_visibility
    page.has_selector?('#account-search')
    search_box = find_by_id('account-search')
    # Begin typing restricted account name "Beatles"
    search_box.send_keys('beatles')

    # Verify full account name displays
    page.has_text?('The Beatles')

    table = find('.tab-content')
    table.first('a').click
    # Click on “The Beatles” and verify firm admin sees account is checked as a "Restricted Account" under the "Details" tab
    page.has_text?('Timeline')
    find('.nav-link', text: 'Details').click

    label = find('label[for="restrictaccount"]')
    container_class = label.find('i')[:class]
    expect(container_class).to eq('checkmark')
    page.current_path
  end

  def view_account_information
    go_to_account_with_client

    wait_for_selector('.tdBtn.row')
    find_all('.tdBtn.row').first.click

    wait_for_text(page, 'EXPAND SECTIONS BELOW TO VIEW DETAILS')

    wait_for_selector('.MuiAccordionSummary-expandIconWrapper')
    find_all('.MuiAccordionSummary-expandIconWrapper').each(&:click)
    page.current_path
  end

  def edit_organization_information
    go_to_account_with_client

    sleep 2
    wait_for_selector('.tdBtn.row')
    find_all('.tdBtn.row').first.click

    wait_for_selector('.icon-more')
    find('.icon-more').click
    click_on 'Edit Account'

    find_by_id('website').click
    fill_in 'website', with: ''
    fill_in 'website', with: 'www.example.com'
    find_all('.btn.btn-primary').first.click

    wait_for_text(page, 'Account updated successfully.')
    page.current_path
  end

  def edit_additional_details
    go_to_account_with_client

    sleep 2
    wait_for_selector('.tdBtn.row')
    find_all('.tdBtn.row').first.click

    wait_for_selector('.icon-more')
    find('.icon-more').click
    click_on 'Edit Account'

    wait_for_selector('#co_ein')
    tax_input = find('#co_ein')
    sleep 0.5
    find_all('.icon-close-eye').first.click

    tax_input.value.length.times { tax_input.send_keys [:backspace] }
    sleep 0.5
    '123456784'.chars.each { |ch| tax_input.send_keys(ch) }
    sleep 0.5
    find_all('.btn.btn-primary').first.click

    wait_for_text(page, 'Account updated successfully.')

    # Fetch again with updated values
    wait_for_selector('.MuiAccordionSummary-expandIconWrapper')
    find_all('.MuiAccordionSummary-expandIconWrapper').first.click

    find_all('.icon-close-eye').first.click
    wait_for_text(page, '12-3456784')
    page.current_path
  end

  def edit_technology_section
    # Log in active Liscio Client account set as an Account Owner
    # From Home Dashboard, click on Accounts tab fro the left nav menu
    go_to_account_with_client

    # Click an Account under the All Accounts page
    sleep 2
    wait_for_selector('.tdBtn.row')
    find_all('.tdBtn.row').first.click

    # Click on the three dots (...) on the right corner
    wait_for_selector('.icon-more')
    find('.icon-more').click

    # Click on Edit Account
    click_on 'Edit Account'

    # Scroll down to Technology Solutions section
    wait_for_text(page, 'Technology Solutions')
    section = find('h5', text: 'Technology Solutions')
    page.execute_script('arguments[0].scrollIntoView();', section.native)

    wait_for_selector('#co_tech_payroll')
    payroll_input = find('#co_tech_payroll')

    # Empty the payroll field if already populated
    payroll_input.value.length.times { payroll_input.send_keys [:backspace] }

    # Put data input in Payroll field
    'My payroll data'.chars.each { |ch| payroll_input.send_keys(ch) }
    sleep 0.5

    # Click on Update Account button
    find_all('.btn.btn-primary').first.click

    # User should be able to see a success banner saying the Account has been updated successfully
    wait_for_text(page, 'Account updated successfully.')

    sleep 2
    # User should be redirected back to Account > Details tab page
    expect(page.current_path).to include('accountdetails')
    page.current_path
  end

  def edit_bank_account_details
    # Log in active Liscio Client account set as an Account Owner
    # From Home Dashboard, click on Accounts tab fro the left nav menu
    go_to_account_with_client

    # Click an Account under the All Accounts page
    sleep 2
    wait_for_selector('.tdBtn.row')
    find_all('.tdBtn.row').first.click

    # Click on the three dots (...) on the right corner
    wait_for_selector('.icon-more')
    find('.icon-more').click

    # Click on Edit Account
    click_on 'Edit Account'

    # Scroll down to Bank Account Details section
    wait_for_text(page, 'Bank Account Details')
    bank_detail_section = find('h5', text: 'Bank Account Details')
    page.execute_script('arguments[0].scrollIntoView();', bank_detail_section.native)

    wait_for_selector('#bankaccount0bank_name')
    bank_name_input = find('#bankaccount0bank_name')

    # Empty the Bank Name field if already populated
    bank_name_input.value.length.times { bank_name_input.send_keys [:backspace] }

    # Put/Change data input in Bank Name field
    'Cubicle Gigglers'.chars.each { |ch| bank_name_input.send_keys(ch) }
    sleep 0.5

    # Click on Update Account button
    find_all('.btn.btn-primary').first.click

    # User should be able to see a success banner saying the Account has been updated successfully
    wait_for_text(page, 'Account updated successfully.')

    sleep 2
    # User should be redirected back to Account > Details tab page
    expect(page.current_path).to include('accountdetails')
    page.current_path
  end

  def add_log_details
    # Log in active Liscio Client account set as an Account Owner
    # From Home Dashboard, click on Accounts tab fro the left nav menu
    go_to_account_with_client

    # Click an Account under the All Accounts page
    sleep 2
    wait_for_selector('.tdBtn.row')
    find_all('.tdBtn.row').first.click

    # Scroll down to Login Details section and click *expand (+) button
    wait_for_selector('.MuiAccordionSummary-expandIconWrapper')
    find_all('.MuiAccordionSummary-expandIconWrapper')[1].click

    # Click on + Login button
    find('button', text: '+ Login').click

    # Put data for. Account name, account ID, User name, Password
    modal = find('.modal-content')

    account_name = 'My First Account'
    account_id = 'my_first_account@liscio.me'
    username = 'myfirstaccount_liscio'
    password = 'Test@12345'

    within modal do
      wait_for_selector('#account_name')
      account_name_input = find('#account_name')
      account_name.chars.each { |ch| account_name_input.send_keys(ch) }
      sleep 0.5

      wait_for_selector('#login_account_id')
      account_id_input = find('#login_account_id')
      account_id.chars.each { |ch| account_id_input.send_keys(ch) }
      sleep 0.5

      wait_for_selector('#namname')
      username_input = find('#namname')
      username.chars.each { |ch| username_input.send_keys(ch) }
      sleep 0.5

      wait_for_selector('#password')
      password_input = find('#password')
      password.chars.each { |ch| password_input.send_keys(ch) }
      sleep 0.5

      # Click on Save button
      click_on 'Save'
    end

    # User should be able to see a success banner saying the Account login created successfully
    wait_for_text(page, 'Account Login created successfully')

    sleep 2
    # TODO: Uncomment the assertions, Disabled due to bug
    # User should be redirected back to Account > Details tab page
    # expect(page.current_path).to include('accountdetails')
    page.current_path
  end

  def edit_payroll_details
    # Log in active Liscio Client account set as an Account Owner
    # From Home Dashboard, click on Accounts tab fro the left nav menu
    go_to_account_with_client

    # Click an Account under the All Accounts page
    sleep 2
    wait_for_selector('.tdBtn.row')
    find_all('.tdBtn.row').first.click

    # Scroll down to Payroll Details section and click *expand (+) button
    wait_for_selector('.MuiAccordionSummary-expandIconWrapper')
    find_all('.MuiAccordionSummary-expandIconWrapper')[2].click

    payroll_label = find('label', text: 'PAY FREQUENCY')
    page.execute_script('arguments[0].scrollIntoView();', payroll_label.native)

    # Click on Edit button
    find('button', text: 'Edit').click

    # Select Pay Frequency: Bi-Weekly
    find_all('input')[0].click
    'bi-weekly'.chars.each { |ch| page.send_keys(ch) }
    page.send_keys(:enter)
    sleep 2

    # Click on Save button
    save_button = find('button', text: 'Save')
    page.execute_script('arguments[0].scrollIntoView();', save_button.native)
    click_on 'Save'

    # User should be able to see a success banner saying the Account has been updated successfully
    wait_for_text(page, 'Account updated successfully')
    page.current_path
  end

  def share_file_via_add_new_file
    # Login as a firm or client user
    login_to_app
    wait_for_loading_animation
    page_refresh
    sleep 2

    # Click on + ADD NEW > "File" from the left-hand navigation menu
    goto_file_from_add_new

    # Verify "Upload File" modal displays
    wait_for_selector('div.modal-dialog')

    # Click on TO field
    to_field_selector = '.cstRtags'
    wait_for_selector(to_field_selector)
    find(to_field_selector).click

    # Verify RECIPIENT + ACCOUNT fields display
    # Click on contact named "Andrew QA Naylor" in "Select a Recipient" box
    client_initials.chars.each { |ch| page.send_keys(ch) }
    wait_for_text(page, client_full_name)
    page.send_keys(:enter)

    # Click on Ok button
    click_on 'Ok'

    # Click on TAGS field and select "Test" option
    find_by_id('tagId').click
    page.send_keys('Test')
    page.has_text?('Test')
    find('.dropdown-item').click

    # Click on Browse link in File section
    # Under FILE, click on Browse link
    # Select file(s) to upload in acceptable formats
    # Verify file(s) upload to Liscio with a Preview link
    file_input = find('input[id="upload_doc"]', visible: :all)
    file_input.attach_file(fixtures_path.join('images', '404.png'))

    # Select file to attach and upload
    wait_for_text(page, 'Preview')

    # Click on Upload button
    click_on 'Upload'

    # Verify a loading animation displays
    wait_for_loading_animation

    # Verify a "File uploaded successfully" toast displays
    wait_for_text(page, 'Files uploaded successfully')
    page.current_path
  end

  def share_file_from_dashboard
    # Login as a firm or client user
    login_to_app

    # Click on FILES from the left-hand navigation menu
    file_selector = 'div[data-testid="sidebar__files"]'
    wait_for_selector(file_selector)
    find(file_selector).click

    # Verify ALL FILES list view page displays
    expect(page).to have_current_path('/files')

    sleep 3
    page_refresh

    # Click on the + Upload File button
    upload_file_button_selector = 'a[data-testid="files__upload_file_btn"]'
    wait_for_selector(upload_file_button_selector)
    find(upload_file_button_selector).click

    # Verify "Upload File" modal displays
    wait_for_selector('div.modal-dialog')

    # Click on TO field
    to_field_selector = '.cstRtags'
    wait_for_selector(to_field_selector)
    find(to_field_selector).click

    # Verify RECIPIENT + ACCOUNT fields display
    # Click on contact named "Andrew QA Naylor" in "Select a Recipient" box
    client_initials.chars.each { |ch| page.send_keys(ch) }
    wait_for_text(page, client_full_name)
    page.send_keys(:enter)

    # Click on Ok button
    click_on 'Ok'

    # Click on TAGS field and select "Test" option
    find_by_id('tagId').click
    page.send_keys('Test')
    page.has_text?('Test')
    find('.dropdown-item').click

    # Click on Browse link in File section
    # Under FILE, click on Browse link
    # Select file(s) to upload in acceptable formats
    # Verify file(s) upload to Liscio with a Preview link
    file_input = find('input[id="upload_doc"]', visible: :all)
    file_input.attach_file(fixtures_path.join('images', '404.png'))

    # Select file to attach and upload
    wait_for_text(page, 'Preview')

    # Click on Upload button
    click_on 'Upload'

    # Verify a loading animation displays
    wait_for_loading_animation

    # Verify a "File uploaded successfully" toast displays
    wait_for_text(page, 'Files uploaded successfully')
    page.current_path
  end

  def share_file_from_accounts
    # Login as a firm or client user
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

    sleep 2
    wait_for_selector('.tdBtn')
    find_all('.tdBtn').first.click

    files_tab_selector = 'button[data-testid="inbox__files"]'
    wait_for_selector(files_tab_selector)
    find(files_tab_selector).click

    # Click on the + Upload File button
    upload_file_button_selector = 'a[data-testid="files__upload_file_btn"]'
    wait_for_selector(upload_file_button_selector)
    find(upload_file_button_selector).click

    # Verify "Upload File" modal displays
    wait_for_selector('div.modal-dialog')

    # Click on TO field
    to_field_selector = '.cstRtags'
    wait_for_selector(to_field_selector)
    find(to_field_selector).click

    # Verify RECIPIENT + ACCOUNT fields display
    # Click on contact named "Andrew QA Naylor" in "Select a Recipient" box
    client_initials.chars.each do |char|
      page.send_keys(char)
      sleep(0.1)
    end

    wait_for_text(page, client_full_name)
    page.send_keys(:enter)

    # Verify "Angus Adventures" auto fills in ACCOUNT field
    wait_for_text(page, client_associated_account)

    # Click on Ok button
    click_on 'Ok'

    # Click on TAGS field and select "Test" option
    find_by_id('tagId').click
    page.send_keys('Test')
    page.has_text?('Test')
    find('.dropdown-item').click

    # Click on Browse link in File section
    # Under FILE, click on Browse link
    # Select file(s) to upload in acceptable formats
    # Verify file(s) upload to Liscio with a Preview link
    file_input = find('input[id="upload_doc"]', visible: :all)
    file_input.attach_file(fixtures_path.join('images', '404.png'))

    # Select file to attach and upload
    wait_for_text(page, 'Preview')

    # Click on Upload button
    click_on 'Upload'

    # Verify a loading animation displays
    wait_for_loading_animation

    # Verify a "File uploaded successfully" toast displays
    wait_for_text(page, 'Files uploaded successfully')
    page.current_path
  end

  def share_file_from_contacts
    # Login as a firm or client user
    login_to_app

    # Click on CONTACTS tab from the left-hand navigation menu
    contacts_selector = 'div[data-testid="sidebar__contacts"]'
    wait_for_selector(contacts_selector)
    find(contacts_selector).click

    # Verify ALL CONTACTS list view page displays
    expect(page).to have_current_path('/contacts')

    sleep 2
    page_refresh

    search_contact_selector = 'input[data-testid="contact__search_input"]'
    if !page.has_selector?(search_contact_selector)
      page_refresh
    end

    sleep 2
    contact_search = find(search_contact_selector)
    # Begin typing contact name "Aquifa Tron Halbert" in search bar
    'aquifa tron halbert'.chars.each { |ch| contact_search.send_keys(ch) }
    # Click on full contact name "Halbert, Aquifa Tron"
    page.has_text?('Halbert, Aquifa Tron')

    # Verify a logo loading animation displays
    wait_for_loading_animation

    sleep 2
    wait_for_selector('.tdBtn')
    find_all('.tdBtn').first.click

    # Click on Files tab
    files_tab_selector = 'button[data-testid="inbox__files"]'
    wait_for_selector(files_tab_selector)
    find(files_tab_selector).click

    # Click on + Upload File button
    upload_file_button_selector = 'a[data-testid="files__upload_file_btn"]'
    wait_for_selector(upload_file_button_selector)
    find(upload_file_button_selector).click

    # Verify "Upload File" modal displays
    wait_for_selector('div.modal-dialog')

    # Click on TO field
    to_field_selector = '.cstRtags'
    wait_for_selector(to_field_selector)
    find(to_field_selector).click

    # Verify RECIPIENT + ACCOUNT fields display
    # Click on contact named "Aquifa Tron Halbert" in "Select a Recipient" box

    # Click on Ok button
    click_on 'Ok'

    # Click on TAGS field and select "Test" option
    find_by_id('tagId').click
    page.send_keys('Test')
    page.has_text?('Test')
    find('.dropdown-item').click

    # Click on Browse link in File section
    # Under FILE, click on Browse link
    # Select file(s) to upload in acceptable formats
    # Verify file(s) upload to Liscio with a Preview link
    file_input = find('input[id="upload_doc"]', visible: :all)
    file_input.attach_file(fixtures_path.join('images', '404.png'))

    # Select file to attach and upload
    wait_for_text(page, 'Preview')

    # Click on Upload button
    click_on 'Upload'

    # Verify a loading animation displays
    wait_for_loading_animation

    # Verify a "File uploaded successfully" toast displays
    wait_for_text(page, 'Files uploaded successfully')
    page.current_path
  end

  def ensure_visibility_granted
    page.has_selector?('.tableWrap')
    table = find('.tableWrap')

    within table do
      page.has_selector?('.tbBtn')
      second_contact = table.find_all('.tdBtn')[1]
      second_contact.click
    end

    page.has_css?('.nav')
    nav = find('.nav')
    page.has_text?('Details')
    nav_links = find_all('.nav-link')
    nav_links.find { |n| n.text == 'Details' }.click

    page.current_path
  end

  def send_edoc_to_multiple
    create_account_from_contacts
  end

  def receive_notification_as_cst_admin
    read_all_notification_as_admin

    edit_account_as_client

    check_for_notification
  end

  private

  def check_for_notification
    login_to_app

    notification_selector = 'div[data-testid="sidebar__notifications"]'
    wait_for_selector(notification_selector)
    find(notification_selector).click

    page.has_selector?('div[role="dialog"]')
    div = find('div[role="dialog"]')
    within div do
      wait_for_selector('.Notification__Title')
      find('div.Notification__Title').click
    end

    wait_for_text(page, 'Angus Adventures')
    wait_for_text(page, 'Aquifa Halbert')
    wait_for_text(page, 'me')
    page.current_path
  end

  def edit_account_as_client
    go_to_account_with_client

    sleep 2
    wait_for_selector('.tdBtn.row')
    find_all('.tdBtn.row').first.click

    wait_for_selector('.icon-more')
    find('.icon-more').click
    click_on 'Edit Account'

    time_stamp = Time.now.to_i
    website = "www.example_#{time_stamp}.com"

    find_by_id('website').click
    fill_in 'website', with: ''
    fill_in 'website', with: website
    find_all('.btn.btn-primary').first.click

    wait_for_text(page, 'Account updated successfully.')
    login_page.logout
  end


  def read_all_notification_as_admin
    login_to_app

    notification_selector = 'div[data-testid="sidebar__notifications"]'
    wait_for_selector(notification_selector)
    find(notification_selector).click

    page.has_selector?('div[role="dialog"]')
    div = find('div[role="dialog"]')
    within div do
      page.has_text?('FETCHING NOTIFICATIONS...')
      mark_all_as_read = div.find('div[role="button"]', text: 'MARK ALL AS READ').click
    end
    login_page.logout
  end

  def goto_file_from_add_new
    sleep 2
    within('.Sidebar') do
      find('span', text: 'ADD NEW').click
    end

    # Verify a drop-down menu displays
    page.has_css?('div[role="menu"]')
    div = find('div[role="menu"]')
    sleep 1
    page.has_css?('div[role="menuitem"]')
    sleep 1
    div.find('div[role="menuitem"]', text: 'File').click
    sleep 1
  end

  def login_to_app
    login_page.ensure_login_page_rendered

    login_page.sign_in_with_valid_user
    login_page.ensure_correct_credientials
    login_page
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

  def login_to_app_as_active_liscio_client
    login_page.ensure_login_page_rendered

    login_page.sign_in_with_valid_active_liscio_client
    login_page.ensure_correct_credientials
    login_page
  end

  def login_to_app_as_automation_qa
    login_page.visit_login_page

    login_page.sign_in_with_automation_qa
    login_page.ensure_correct_credientials
    login_page
  end

  def login_page
    @login_page ||= LoginPage.new
  end
end
