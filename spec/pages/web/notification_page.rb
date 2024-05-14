require_relative './base_page'
require_relative './login_page'

class NotificationPage < BasePage
  def go_to_notification
    login_to_app
    within('.Sidebar') do
      find('span', text: 'NOTIFICATIONS').click
    end
  end

  def mark_as_read
    page.has_selector?('div[role="dialog"]')
    div = find('div[role="dialog"]')
    within div do
      page.has_text?('FETCHING NOTIFICATIONS...')
      mark_all_as_read = div.find('div[role="button"]', text: 'MARK ALL AS READ').click
    end

    page_refresh
    within('.Sidebar') do
      find('span', text: 'NOTIFICATIONS').click
    end
    page.has_selector?('div[role="dialog"]')

    div = find('div[role="dialog"]')
    within div do
      # Fetching notification might take few miliseconds
      # FETCHING NOTIFICATIONS...
      page.has_text?('NO NOTIFICATIONS FOUND')
      expect(div.text).to include('NO NOTIFICATIONS FOUND')
    end
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

  def check_all_filters
    view_all_notifications
    check_date_filter
    check_notification_type_filter
  end

  def check_date_filter
    div = find('.sortBy')
    within div do
      date_filter = find('.select-custom-class')
      date_filter.find('div[data-value]').click
      # TODO: Select Ascending or Descending
    end
  end

  def check_notification_type_filter
    div = find('.filterBy')
    within div do
      type_filter = find('.select-custom-class')
      type_filter.find('div[data-value]').click
      # TODO: Select All or Unread
      # type_filter.send_keys(:arrow_down)
      # type_filter.send_keys(:enter)
    end
  end

  def view_all_notifications
    find('a', text: 'VIEW ALL NOTIFICATIONS', wait: 10).click
  end

  def redirect_to_message
    find('button[data-testid="message__to_field"]').click
    find('input[id="messageRecipient"]').click

    'automation qa'.chars.each { |ch| page.send_keys(ch) }
    wait_for_text(page, "Automation QA")
    page.send_keys(:enter)

    find('input[id="messageAccount"]').click
    'abc inc'.chars.each { |ch| page.send_keys(ch) }
    wait_for_text(page, "ABC Inc")
    page.send_keys(:enter)

    click_on "Ok"
    find('input[id="NewMessage__SelectTemplate"]').click
    page.send_keys("Testing")
    page.send_keys(:tab)

    click_on "Send"
    go_to_notifications
    page.current_path
  end

  def go_to_notifications
    click_on_sidebar_notification
    page.current_path
  end

  def click_on_sidebar_notification
    notification_selector = 'div[data-testid="sidebar__notifications"]'
    notification_button = find(notification_selector)
    wait_for_selector(notification_selector)
    notification_button.click
  end

  def view_new_and_unread_notifications
    # Sign into Liscio as firm-side user
    login_to_app

    # Generate and/or send tasks, messages, etc. to user to result in new notifications
    message = send_message_to_generate_notification

    login_page.logout
    login_to_app_as_automation_qa

    # Click on NOTIFICATIONS on the left-hand dashboard navigation
    notifcation_selector = 'div[data-testid="sidebar__notifications"]'
    wait_for_selector(notifcation_selector)
    find(notifcation_selector).click

    view_all_notifications

    # Verify "NOTIFICATIONS" page displays
    expect(page).to have_current_path('/notifications')

    # Verify "Filter by" field is set to "Unread"
    wait_for_text(page, 'Unread')

    # Verify a pink dot displays for each unread notification
    recent_notification = find_all('.listRow__list').first
    recent_notification.has_selector?('.rounded.status.visible')

    expect(recent_notification.text).to include(message[:subject])
    expect(recent_notification.text).to include(message[:body])
    page.current_path
  end

  def view_old_notifications
    login_to_app_as_automation_qa

    # Click on NOTIFICATIONS on the left-hand dashboard navigation
    notifcation_selector = 'div[data-testid="sidebar__notifications"]'
    wait_for_selector(notifcation_selector)
    find(notifcation_selector).click

    page.has_selector?('div[role="dialog"]')
    div = find('div[role="dialog"]')
    within div do
      page.has_text?('FETCHING NOTIFICATIONS...')
      mark_all_as_read = div.find('div[role="button"]', text: 'MARK ALL AS READ').click
    end

    view_all_notifications

    # Verify "NOTIFICATIONS" page displays
    expect(page).to have_current_path('/notifications')

    wait_for_text(page, 'Nothing to See Here')

    # Verify "Filter by" field is set to "Unread"
    wait_for_text(page, 'Unread')

    page.current_path
  end

  private

  def send_message_to_generate_notification
    page.has_text?('+ Message')
    click_link '+ Message'

    find('button[data-testid="message__to_field"]').click
    # Verify a RECIPIENT + ACCOUNT search box displays
    page.has_selector?('div[data-value]')
    recipient = fill_in 'messageRecipient', with: 'automation q'
    sleep(2)

    # Verify a CONTACTS box displays with the full name of the recipient' full name
    page.has_text?('Automation QA')
    recipient.send_keys(:enter)

    # Verify the recipient's name displays in the TO field
    click_on 'Ok'

    time_stamp = Time.now.to_i
    subject = "Message_#{time_stamp}"

    page.has_selector?('labelValue')
    subject_div = find_all('.labelValue')[1].click
    page.send_keys(subject)
    page.send_keys(:tab)

    body = 'A quick brown fox jumps over the lazy dog'
    page.has_selector?('iframe')
    iframe = find_all('iframe')
    within_frame iframe[0] do
      body_div = find_by_id('tinymce').click
      body_div.send_keys(body)
    end

    click_on 'Send'

    { subject: subject, body: body }
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
