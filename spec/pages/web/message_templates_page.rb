require_relative 'base_page'
require_relative 'login_page'

class MessageTemplatesPage < BasePage
  def goto_templates_from_admin
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

    # After hovering on Admin pop_up: Consisting of Users, Preferences, Integration, Templates
    page.has_selector?('div[data-radix-popper-content-wrapper]')
    pop_up = find_all('div[data-radix-popper-content-wrapper]').last
    pop_up.find('div[role="menuitem"]', text: 'Templates').click
  end

  def goto_preferences_from_admin
    # From Home Dashboard, click on the three dots (...) at the bottom left corner of the left nav menu > Admin > Templates
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
  end

  def goto_users_from_admin
    # From Home Dashboard, click on the three dots (...) at the bottom left corner of the left nav menu > Admin > Templates
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
    sleep(2)
    div.find('div[role="menuitem"]', text: 'Message').click
    page_refresh
  end

  def go_to_accounts
    login_to_app
    # Verify firm admin sees all features in dashboard nav: + ADD NEW, HOME, INBOX, TASKS, EMAILS, ACCOUNTS, CONTACTS, FILES,  EDOCS, BULK ACTIONS, BILLING, and NOTIFICATIONS
    page.has_selector?('.Sidebar')
    sidebar = find('.Sidebar')

    sidebar_menus = [
      'ADD NEW',
      'HOME',
      'INBOX',
      'TASKS',
      'REQUESTS',
      'EMAILS',
      'SMS',
      'ACCOUNTS',
      'CONTACTS',
      'FIELS',
      'BULK ACTIONS',
      'EDOC',
      'BILLINGS',
      'NOTIFICATIONS'
    ]

    sidebar_menus.each do |menu|
      page.has_text?(menu)
    end
    # Click on ACCOUNTS
    within('.Sidebar') do
      click_on 'ACCOUNTS'
    end
    sleep(3)
  end

  def create_new_template_from_admin
    click_link '+ Template'
    sleep 3
    subject = find('input[data-testid="title"]')
    subject.click

    page.send_keys("Testing template")
    page.send_keys(:enter)
    sleep 3
    iframe = find('iframe[id^="tiny-react_"]')
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('Testing')
      page.send_keys(:tab)
    end

    click_on "Create Template"

    page.current_path
  end

  def edit_existing_template_from_admin
    find_all('.tdBtn').first.click
    button = find('button[id^="Tooltip-edit"]')
    button.hover
    button.click

    sleep 3
    subject = find('input[data-testid="title"]')
    subject.click

    page.send_keys("")

    subject.click
    page.send_keys("Testing template")
    page.send_keys(:enter)

    sleep 3
    iframe = find('iframe[id^="tiny-react_"]')
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('')
      find_by_id('tinymce').click
      page.send_keys('Testing')
      page.send_keys(:tab)
    end

    click_on "Update Template"

    page.current_path
  end

  def delete_template_from_admin
    sleep 3
    find_all('.tdBtn').first.click
    button = find('button[id^="Tooltip-delete"]')
    button.hover
    button.click

    click_on "Proceed"
    page.current_path
  end

  def sort_template_from_admin
    find_all('.tdBtn').first.click
    button = find('span[id^="dragbutton"]')

    target = find_all('.tdBtn')[2]
    button.drag_to(target)

    page.current_path
  end

  def use_templates_on_subject
    find('input[id="NewMessage__SelectTemplate"]').click
    sleep 3
    page.current_path
  end

  def clear_templates_on_subject
    find('input[id="NewMessage__SelectTemplate"]').click
    sleep 3

    page.send_keys("Welcome to liscio")
    page.send_keys(:enter)
    sleep 3

    find('button[data-testid="clearBtn"]').click
    click_on "Yes"
    page.current_path
  end

  def type_anyword_on_subject
    find('input[id="NewMessage__SelectTemplate"]').click
    sleep 3
    page.send_keys("Testing subject")
    page.current_path
  end

  def ensure_visibility_properly_granted
    page.has_selector?('#account-search')
    search_box = find_by_id('account-search')
    # Begin typing restricted account name "Beatles"
    search_box.send_keys('beatles')

    # Verify full account name displays
    page.has_text?('The Beatles')
    page.has_css?('#loading')
    page.has_selector?('.tdBtn')
    record = find_all('.tdBtn').first
    # Click on “The Beatles” and verify firm admin sees account is checked as a "Restricted Account" under the "Details" tab
    record.click
    sleep 3

    goto_preferences_from_admin
    sleep 3
    goto_users_from_admin
    page.current_path
  end

  def ensure_visibility_properly_restricted
    page.has_selector?('#account-search')
    search_box = find_by_id('account-search')
    # Begin typing restricted account name "Beatles"
    search_box.send_keys('beatles')
    page.has_text?('The Beatles')

    page.current_path
  end

  def ensure_details_visibility
    page.has_selector?('#account-search')
    search_box = find_by_id('account-search')
    # Begin typing restricted account name "Beatles"
    search_box.send_keys('beatles')

    # Verify full account name displays
    page.has_text?('The Beatles')
    page.has_css?('#loading')
    page.has_selector?('.tdBtn')
    record = find_all('.tdBtn').first
    # Click on “The Beatles” and verify firm admin sees account is checked as a "Restricted Account" under the "Details" tab
    record.click
    sleep 3

    find('button[data-testid="inbox__details"]').click
    page.current_path
  end

  def ensure_emails_visibility
    page.has_selector?('#account-search')
    search_box = find_by_id('account-search')
    # Begin typing restricted account name "Beatles"
    search_box.send_keys('beatles')

    # Verify full account name displays
    page.has_text?('The Beatles')
    page.has_css?('#loading')
    page.has_selector?('.tdBtn')
    record = find_all('.tdBtn').first
    # Click on “The Beatles” and verify firm admin sees account is checked as a "Restricted Account" under the "Details" tab
    record.click
    sleep 3

    find('button[data-testid="inbox__emails"]').click
    page.current_path
  end

  private

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
