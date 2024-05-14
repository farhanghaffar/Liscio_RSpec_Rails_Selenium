require_relative './base_page'
require_relative './login_page'

class ContactPage < BasePage
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

  def go_to_accounts
    login_to_app
    account_selector = 'div[data-testid="sidebar__accounts"]'
    account_button = find(account_selector)
    wait_for_selector(account_selector)
    account_button.click

    expect(page).to have_current_path('/accounts')
    sleep(3)
    page_refresh
    # No way to bypass this modal rather refreshing and waiting for 3 seconds
    # page.find('h5').text == "This Feature is not allowed\n(Unauthorized access)"
  end

  def goto_contact_from_add_new
    login_to_app
    within('.Sidebar') do
      find('span', text: 'ADD NEW').click
    end

    # Verify a drop-down menu displays
    page.has_css?('div[role="menu"]')
    div = find('div[role="menu"]')

    page.has_css?('div[role="menuitem"]')
    sleep(2)
    div.find('div[role="menuitem"]', text: 'Contact').click
  end

  def go_to_contact_details
    page.has_selector?('.tableWrap')
    table = find('.tableWrap')

    within table do
      page.has_selector?('.tbBtn')
      second_contact = table.find_all('.tdBtn')[1]
      second_contact.click
    end

    contact_detail_path = page.current_path
    page.has_css?('.nav')
    nav = find('.nav')
    page.has_text?('Details')
    nav_links = find_all('.nav-link')
    nav_links.find { |n| n.text == 'Details' }.click

    page.has_css?('.icon-more')
    find('.icon-more').click

    page.has_text?('Edit Contact')
    click_on 'Edit Contact'
    update_email
    page.has_css?('.icon-more')
    find('.icon-more').click

    page.has_text?('Edit Contact')
    click_on 'Edit Contact'
    revert_changes
    contact_detail_path
  end

  def update_email
    fill_in 'primary_email', with: 'new_firm_user@example.com'
    click_on 'Update Contact'
  end

  def revert_changes
    previous_email = find_by_id('primary_email').value
    fill_in 'primary_email', with: previous_email
    click_on 'Update Contact'
  end

  def archive_contact
    create_a_contact_with_timestamp

    page.has_css?('.icon-more')
    find('.icon-more').click

    page.has_text?('Archive Contact')
    click_on 'Archive Contact'

    page.has_text?('Attention: The contact deactivation process will close all open tasks related. Proceed?')
    click_on "Proceed"

    page.has_selector?('.is-status--away')

    within('.Sidebar') do
      click_on 'CONTACTS'
    end

    page.current_path
  end

  def unarchive_contact
    contact_email = create_a_contact_with_timestamp

    page.has_css?('.icon-more')
    find('.icon-more').click

    page.has_text?('Archive Contact')
    click_on 'Archive Contact'

    page.has_text?('Attention: The contact deactivation process will close all open tasks related. Proceed?')
    click_on "Proceed"

    page.has_selector?('.is-status--away')

    within('.Sidebar') do
      click_on 'CONTACTS'
    end

    sleep(3)
    click_on "Archived"

    fill_in 'contact-search', with: contact_email

    page.has_selector?('.tableWrap')
    table = find('.tableWrap')

    within table do
      page.has_selector?('.tbBtn')
      second_contact = table.find_all('.tdBtn').first
      second_contact.click
    end

    contact_detail_path = page.current_path
    page.has_css?('.nav')
    nav = find('.nav')
    page.has_text?('Details')
    nav_links = find_all('.nav-link')
    nav_links.find { |n| n.text == 'Details' }.click

    click_on "Reactivate Contact"

    page.current_path
  end

  def ensure_features_visibility
    sleep(2)
    find_all('.row')[1].click

    nav_detail_menu_selector = 'button[data-testid="inbox__details"]'
    wait_for_selector(nav_detail_menu_selector)
    find(nav_detail_menu_selector).click

    nav_contact_menu_selector = 'button[data-testid="inbox__relationships"]'
    wait_for_selector(nav_contact_menu_selector)
    find(nav_contact_menu_selector).click

    nav_files_menu_selector = 'button[data-testid="inbox__files"]'
    wait_for_selector(nav_files_menu_selector)
    find(nav_files_menu_selector).click

    page.current_path
  end

  def create_a_contact_with_timestamp
    time_stamp = Time.now.to_i
    email = "adnan+#{time_stamp}@liscio.me"

    create_contact_button = find('a[data-testid="contact__create_btn"]', visible: true)
    create_contact_button.click

    expect(page).to have_current_path('/contact/new')
    fill_in 'first_name', with: 'first'
    fill_in 'last_name', with: 'last'
    fill_in 'email', with: email

    click_on 'Create Contact', visible: true
    email
  end

  def create_contact_from_add_new
    f_name = find('input[data-testid="contact__first_name"]')
    f_name.click

    page.send_keys("Adnan")
    page.send_keys(:tab)

    m_name = find('input[data-testid="contact__middle_name"]')
    m_name.click

    page.send_keys("Testing")
    page.send_keys(:tab)

    l_name = find('input[data-testid="contact__last_name"]')
    l_name.click

    page.send_keys("Ghaffar")
    page.send_keys(:tab)


    job_title = find('input[data-testid="contact__job_title"]')
    job_title.click

    page.send_keys("Employee")
    page.send_keys(:tab)


    email = find('input[data-testid="contact__primary_email"]')
    email.click

    page.send_keys("test2#{SecureRandom.hex(4)}@mailinator.com")
    page.send_keys(:tab)

    click_on "Create Contact"

    within('.Sidebar') do
      find('span', text: 'CONTACTS').click
    end

    page.current_path
  end

  def create_contact_from_contacts
    sleep 3
    page_refresh
    find('a[data-testid="contact__create_btn"]').click

    f_name = find('input[data-testid="contact__first_name"]')
    f_name.click

    page.send_keys("Adnan")
    page.send_keys(:tab)

    m_name = find('input[data-testid="contact__middle_name"]')
    m_name.click

    page.send_keys("Testing")
    page.send_keys(:tab)

    l_name = find('input[data-testid="contact__last_name"]')
    l_name.click

    page.send_keys("Ghaffar")
    page.send_keys(:tab)


    job_title = find('input[data-testid="contact__job_title"]')
    job_title.click

    page.send_keys("Employee")
    page.send_keys(:tab)


    email = find('input[data-testid="contact__primary_email"]')
    email.click

    page.send_keys("test2#{SecureRandom.hex(4)}@mailinator.com")
    page.send_keys(:tab)

    click_on "Create Contact"

    within('.Sidebar') do
      find('span', text: 'CONTACTS').click
    end

    page.current_path
  end

  def create_contact_from_accounts
    sleep 3
    find_all('.row')[2].click
    click_on "Contacts"

    find('.btn.dropdown-toggle.btn-primary').click
    click_on "New Contact"

    find('#react-select-2-input').click
    page.send_keys("Primary")
    page.send_keys(:tab)

    f_name = find('input[data-testid="contact__first_name"]')
    f_name.click

    page.send_keys("Adnan")
    page.send_keys(:tab)

    m_name = find('input[data-testid="contact__middle_name"]')
    m_name.click

    page.send_keys("Testing")
    page.send_keys(:tab)

    l_name = find('input[data-testid="contact__last_name"]')
    l_name.click

    page.send_keys("Ghaffar")
    page.send_keys(:tab)


    job_title = find('input[data-testid="contact__job_title"]')
    job_title.click

    page.send_keys("Employee")
    page.send_keys(:tab)


    email = find('input[data-testid="contact__primary_email"]')
    email.click

    page.send_keys("test2#{SecureRandom.hex(4)}@mailinator.com")
    page.send_keys(:tab)

    click_on "Create Contact"

    within('.Sidebar') do
      find('span', text: 'CONTACTS').click
    end

    page.current_path
  end

  def deactivate_contact_from_contacts
    find('input[data-testid="contact__search_input"]').click
    page.send_keys("ghaffar")
    sleep 3

    find_all('.row')[2].click
    click_on "Details"

    find('.btn.btn-link.btn--onlyicon.dropdown-toggle').click
    click_on "Archive Contact"
    click_on "Proceed"

    within('.Sidebar') do
      find('span', text: 'CONTACTS').click
    end

    page.current_path
  end

  def re_activate_contact_from_contacts
    find('button[data-testid="contact__archived"]').click
    find('input[data-testid="contact__search_input"]').click
    page.send_keys("ghaffar")
    sleep 3

    find_all('.row')[1].click
    click_on "Details"

    find('.btn.btn-outline-light').click

    within('.Sidebar') do
      find('span', text: 'CONTACTS').click
    end

    page.current_path
  end


  def invite_a_contact
    # Login as a firm
    # Click on CONTACTS
    go_to_contact

    # Click on a contact name
    find('input[data-testid="contact__search_input"]').click
    page.send_keys("ghaffar")
    sleep 3

    find_all('.row')[2].click
    click_on "Details"

    # On the contact "OVERVIEW" screen, mouse over the gray dot and verify it says "New"
    page.has_css?('.icon-more')
    find('.icon-more').click

    # Click on the "..." button next to "+ Message" button
    page.has_text?('Resend Invite')

    # Click on "Send Invite"
    click_on 'Resend Invite'
    wait_for_text(page, 'Invitation Sent Successfully')
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
