require_relative './base_page'
require_relative './login_page'

class AdminPage < BasePage
  def go_to_admin_users
    sleep(2)
    page_refresh
    # From Home Dashboard, click on the three dots (...) at the bottom left corner of the left nav menu > Admin > Templates
    horiz_icon_selector = 'div[data-testid="sidebar__more_horiz_icon"]'
    horiz_icon_selector_button = find(horiz_icon_selector)
    wait_for_selector(horiz_icon_selector)
    horiz_icon_selector_button.click

    page.has_selector?('div[role="menu"]')
    div = find('div[role="menu"]')

    # First pop up consisting of Admin and Logout
    page.has_selector?('div[aria-haspopup="menu"]')
    div.find('div[aria-haspopup="menu"]').hover

    # Click on the ellipses button (**...**) > Admin > Users
    admin_dropdown_container = 'div[data-testid="admin__dropdown"]'
    admin_dropdown = find(admin_dropdown_container)
    wait_for_selector(admin_dropdown_container)
    within admin_dropdown do
      users_menu = 'div[data-testid="users"]'
      users = find(users_menu)
      wait_for_selector(users_menu)
      users.click
    end
  end

  def go_to_accounts
    login_to_app
    sleep 4
    within('.Sidebar') do
      click_on 'ACCOUNTS'
    end
  end

  def login_as_other_account
    login_to_app
    go_to_admin_users

    # Verify list of firm employees displays
    page.has_selector?('.tRow--body')

    # Click the Login as button for any other active firm user such as test user “D’andre Carroll”
    page.has_selector?('#users-search')
    search_box = find_by_id('users-search')
    search_box.send_keys('test user')

    # Verify a Liscio loading animation displays
    page.has_css?('#loading')
    page.has_selector?('.tdBtn')
    record = find('.tdBtn')
    record.hover

    find(:css, '[id^="Tooltip-login"]').click

    # Verify firm admin is brought to other user's account
    expect(page).to have_current_path(root_path)
    page.has_text?('DERICK USER')

    # Verify D’ANDRE CARROLL and matching profile picture appear in bottom left corner of dashboard
    # Click on the EMAILS tab
    within('.Sidebar') do
      click_on 'EMAILS'
    end

    # Verify “Nothing to See Here” message displays
    page.has_selector?('h3')
    email_page_text = find('h3').text
    expect(email_page_text).to include('Nothing to See Here')
    page.current_path
  end

  def ensure_visibility
    login_to_app
    # Verify firm admin sees all features in dashboard nav: + ADD NEW, HOME, INBOX, TASKS, EMAILS, ACCOUNTS, CONTACTS, FILES,  EDOCS, BULK ACTIONS, BILLING, and NOTIFICATIONS
    page.has_selector?('.Sidebar')
    sidebar = find('.Sidebar')
    sidebar_selector = 'div[data-testid="sidebar"]'
    wait_for_selector(sidebar_selector)
    sidebar = find(sidebar_selector)
    sidebar_menus = sidebar.text.split("\n")

    sidebar_options = ['ADD NEW', 'HOME', 'INBOX', 'TASKS', 'REQUESTS', 'EMAILS', 'SMS', 'ACCOUNTS',
                       'CONTACTS', 'FILES', 'BULK ACTIONS', 'EDOCS', 'BILLING', 'NOTIFICATIONS']

    # main_array = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    # subset_array = [3, 5, 7]

    # # Check if subset_array is a subset of main_array
    # is_subset = (subset_array & main_array) == subset_array

    expect(sidebar_options & sidebar_menus).to eq(sidebar_options)

    # Click on ACCOUNTS
    account_selector = 'div[data-testid="sidebar__accounts"]'
    account_button = find(account_selector)
    wait_for_selector(account_selector)
    account_button.click

    expect(page).to have_current_path('/accounts')

    search_account_selector = 'input[data-testid="account__search_input"]'
    if !page.has_selector?(search_account_selector)
      page_refresh
    end

    page.has_selector?('#account-search')
    search_box = find_by_id('account-search')
    # Begin typing restricted account name "Beatles"
    search_box.send_keys('beatles')

    # Verify full account name displays
    page.has_text?('The Beatles')
    page.has_css?('#loading')
    table = find('.tab-content')
    table.first('a').click
    # Click on “The Beatles” and verify firm admin sees account is checked as a "Restricted Account" under the "Details" tab
    page.has_text?('Timeline')
    find('.nav-link', text: 'Details').click

    label = find('label[for="restrictaccount"]')
    container_class = label.find('i')[:class]
    expect(container_class).to eq('checkmark')

    # Verify firm admin sees all account tabs including "Timeline", "Details", "In Focus", "Contacts", "Tasks", "Messages", "Notes", "Files", "Emails", and "Billing"
    account_tabs = ['Timeline', 'Details', 'In Focus', 'Contacts', 'Tasks',
                    'Messages', 'Notes', 'Files', 'Emails', 'Billing']
    account_tabs.each do |tab|
      page.has_text?(tab)
    end

    # Verify firm admin can click on ellipses (**...**) > Admin tab
    go_to_admin_users

    page.has_selector?('#users-search')
    search_box = find_by_id('users-search')
    search_box.send_keys('test user')

    # Verify a Liscio loading animation displays
    page.has_css?('#loading')
    page.has_selector?('.tdBtn')
    record = find('.tdBtn')
    record.hover

    find(:css, '[id^="Tooltip-login"]').hover
    page.has_text?('Login as')

    page.current_path
  end

  def go_to_users_from_admin
    login_to_app
    # From Home Dashboard, click on the three dots (...) at the bottom left corner of the left nav menu > Admin > Templates
    within('.Sidebar') do
      find_all('div[role="button"]').last.click
    end

    page.has_selector?('div[role="menu"]')
    div = find('div[role="menu"]')

    # First pop up consisting of Admin and Logout
    page.has_selector?('div[aria-haspopup="menu"]')
    div.find('div[aria-haspopup="menu"]').hover

    # Click on the ellipses button (**...**) > Admin > Users
    page.has_selector?('div[data-radix-popper-content-wrapper]')
    pop_up = find_all('div[data-radix-popper-content-wrapper]').last
    pop_up.find('div[role="menuitem"]', text: 'Users').click
  end

  def use_log_me_as_feature
    sleep 2
    page_refresh
    find_all('.row')[1].hover
    find('button[id^="Tooltip-login"]').click
    page.current_path
  end

  def ensure_user_visibility
    page.has_selector?('#account-search')
    search_box = find_by_id('account-search')
    # Begin typing restricted account name "Beatles"
    search_box.send_keys('beatles')

    # Verify full account name displays
    page.has_text?('The Beatles')
    page.has_css?('#loading')
    table = find('.tab-content')
    table.first('a').click
    # Click on “The Beatles” and verify firm admin sees account is checked as a "Restricted Account" under the "Details" tab
    page.has_text?('Timeline')

    within('.Sidebar') do
      find_all('div[role="button"]').last.click
    end

    page.has_selector?('div[role="menu"]')
    div = find('div[role="menu"]')

    # First pop up consisting of Admin and Logout
    page.has_selector?('div[aria-haspopup="menu"]')
    div.find('div[aria-haspopup="menu"]').hover

    # After hovering on Admin pop_up: Consisting of Users, Preferences, Integration, Templates
    page.has_selector?('div[data-radix-popper-content-wrapper]')
    pop_up = find_all('div[data-radix-popper-content-wrapper]').last
    pop_up.find('div[role="menuitem"]', text: 'Preferences').click

    within('.Sidebar') do
      find_all('div[role="button"]').last.click
    end

    page.has_selector?('div[role="menu"]')
    div = find('div[role="menu"]')

    # First pop up consisting of Admin and Logout
    page.has_selector?('div[aria-haspopup="menu"]')
    div.find('div[aria-haspopup="menu"]').hover

    # After hovering on Admin pop_up: Consisting of Users, Preferences, Integration, Templates
    page.has_selector?('div[data-radix-popper-content-wrapper]')
    pop_up = find_all('div[data-radix-popper-content-wrapper]').last
    pop_up.find('div[role="menuitem"]', text: 'Users').click
    page.current_path
  end

  def ensure_user_visibility_as_employee
    page.has_selector?('#account-search')
    search_box = find_by_id('account-search')
    # Begin typing restricted account name "Beatles"
    search_box.send_keys('beatles')

    # Verify full account name displays
    page.has_text?('The Beatles')
    page.has_css?('#loading')

    page.current_path
  end

  def ensure_user_visibility_as_specialist
    page.has_selector?('#account-search')
    search_box = find_by_id('account-search')
    # Begin typing restricted account name "Beatles"
    search_box.send_keys('beatles')

    # Verify full account name displays
    page.has_text?('The Beatles')
    page.has_css?('#loading')
    table = find('.tab-content')
    table.first('a').click
    # Click on “The Beatles” and verify firm admin sees account is checked as a "Restricted Account" under the "Details" tab
    page.has_text?('Timeline')
    find('.nav-link', text: 'Details').click

    page.current_path
  end

  def edit_a_message_template
    # Create a template with an attachment with unique subject
    template_title = create_a_unique_template_with_pdf

    sleep 3
    # Search box for searching that specific template
    search_box = find_by_id('tag-search')

    # Begin typing restricted Template subject
    template_title.chars.each { |char|
      search_box.send_keys(char)
      sleep(1)
    }

    wait_for_loading_animation
    # Verify full account name displays
    page.has_text?(template_title)

    remove_attachment_from_uniquely_created_template

    # Verify Template updated successfully" toast displays
    wait_for_text(page, 'Template updated successfully.')
    page.current_path
  end

  def send_edited_template_to_a_recipient
    # Create a template with an attachment that later could be sent to recipient
    template_title = create_a_unique_template_with_pdf

    sleep 3
    # Search box for searching that specific created template
    search_box = find_by_id('tag-search')

    # Begin typing restricted Template subject
    template_title.chars.each { |char|
      search_box.send_keys(char)
      sleep(1)
    }

    wait_for_loading_animation
    # Verify full account name displays
    page.has_text?(template_title)

    remove_attachment_from_uniquely_created_template

    sleep 5
    send_this_template_to_recipients(template_title)
  end

  private

  def remove_attachment_from_uniquely_created_template
    table = find('tbody')

    # Hover of the edit button and verify on "Edit" popover text displays
    table.find_all('tr').first.hover

    # Click on the "Edit" button
    table.find_all('tr').first.find_all('button')[0].click

    # Click on the "x" button of the "404.png"
    find('.icon-close2').click

    delete_attachment_confirmation_modal = find('.modalContent--inner')

    within delete_attachment_confirmation_modal do
      heading = find('h5').text

      # Verify a prompt displays with "You are about to delete the attached file."
      expect(heading).to eq('You are about to delete the attached file.')

      # Click on the "Yes" button
      click_on 'Yes'
    end

    # Verify "Attachment removed successfully" toast displays
    wait_for_text(page, 'Attachment removed successfully.')

    # Click on the "Update Template" button
    click_on 'Update Template'
  end

  def send_this_template_to_recipients(template)
    add_new_selector = 'div[data-testid="sidebar__add_new"]'
    wait_for_selector(add_new_selector)

    # In Landing Page, click the + Add New button at the left sidebar
    find(add_new_selector).click

    # Click Request in the dropdown menu
    request_selector = 'div[data-testid="message"]'
    wait_for_selector(request_selector)
    find(request_selector).click

    expect(page).to have_current_path('/message/new')

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
    template.chars.each { |char|
      page.send_keys(char)
      sleep(1)
    }

    find_all('span', text: template).last.click
    wait_for_loading_animation

    click_on 'Send'

    page.current_path
  end

  def goto_admin_templates
    # From Home Dashboard, click on the three dots (...) at the bottom left corner of the left nav menu > Admin > Templates
    within('.Sidebar') do
      find_all('div[role="button"]').last.click
    end

    page.has_selector?('div[role="menu"]')
    div = find('div[role="menu"]')

    # First pop up consisting of Admin and Logout
    page.has_selector?('div[aria-haspopup="menu"]')
    div.find('div[aria-haspopup="menu"]').hover

    # Click on the ellipses button (**...**) > Admin > Templates
    page.has_selector?('div[data-radix-popper-content-wrapper]')
    pop_up = find_all('div[data-radix-popper-content-wrapper]').last
    pop_up.find('div[role="menuitem"]', text: 'Templates').click

    expect(page).to have_current_path('/templates')
  end

  def create_a_unique_template_with_pdf
    login_to_app
    goto_admin_templates

    time_stamp = Time.now.to_i
    template_title = "Template_#{time_stamp}"

    find('a', text: '+ Template').click

    fill_in 'title', with: template_title

    # Type 'This is just a test message.' in the body of email
    iframe = find('iframe[id^="tiny-react_"]')
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('This is just a test description.')
      page.send_keys(:tab)
    end

    click_on 'Browse'

    wait_for_selector('.modalContent--inner')
    upload_file_modal = find('.modalContent--inner')
    within upload_file_modal do
      find_by_id('tagId').click
      page.send_keys('Test')
      page.has_text?('Test')
      find('.dropdown-item').click

      # Click on Browse link in File section
      file_input = find('input[id="upload_doc"]', visible: :all)
      file_input.attach_file(fixtures_path.join('images', '404.png'))
      # Select file to attach and upload
      wait_for_text(page, 'Preview')

      click_on 'Upload'
    end

    wait_for_text(page, 'Updated successfully.')

    click_on 'Create Template'
    wait_for_text(page, 'Created template successfully')
    template_title
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
