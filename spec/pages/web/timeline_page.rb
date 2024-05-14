require_relative './base_page'
require_relative './login_page'

class TimelinePage < BasePage
  def go_to_message
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
  end

  def go_to_task
    login_to_app
    within('.Sidebar') do
      find('span', text: 'ADD NEW').click
    end

    # Verify a drop-down menu displays
    page.has_css?('div[role="menu"]')
    div = find('div[role="menu"]')

    page.has_css?('div[role="menuitem"]')
    sleep(2)
    div.find('div[role="menuitem"]', text: 'Task').click
    find('div[role="menuitem"]', text: 'Request Information').click
  end

  def go_to_files
    login_to_app
    within('.Sidebar') do
      find('span', text: 'FILES').click
    end
  end


  def sync_messages_contacts
    sleep(2)
    # Verify a RECIPIENT + ACCOUNT search box displays
    find('button[data-testid="message__to_field"]').click
    page.has_selector?('div[data-value]')
    recipient = fill_in 'messageRecipient', with: 'adnan ghaffar'
    sleep(2)

    # Click the Recipient dropdown list then choose the contact to assign.
    page.has_text?('Adnan Ghaffar')
    recipient.send_keys(:enter)

    # Click the Account dropdown list then choose account then click the OK button.
    click_on 'Ok'

    # Click the Subject field then input the subject for the message.
    find_by_id('NewMessage__SelectTemplate').click
    page.send_keys('Testing Message')
    page.send_keys(:tab)

    # Click the Description field then input the description for the message.
    iframe = find('iframe[id^="tiny-react_"]')
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('Testing')
      page.send_keys(:tab)
    end

    # Click Send button to send the message.
    click_on "Send"

    # Go to Contacts tab, search the recipient in search field.
    sleep(2)
    within('.Sidebar') do
      find('span', text: 'CONTACTS').click
    end
    find_by_id('contact-search').click
    send_keys('adnan ghaffar')
    sleep(2)
    # Open the contacts details then go to messages to check if the message was reflected.
    find_all('.row').last.click
    click_button 'Messages'

    # Go to the Timeline tab check if message was reflected.
    click_button 'Timeline'

    page.current_path
  end

  def sync_messages_from_tasks
    find_by_id('react-select-3-input').click
    page.send_keys('Abc testing')
    page.has_text?('ABC Testing Inc.')
    page.send_keys(:tab)

    find_by_id('react-select-5-input').click
    page.send_keys('qa tests uat mail')
    page.has_text?('QA Tests UAT Mail')
    page.send_keys(:enter)

    find_by_id('react-select-7-input').click
    page.send_keys('Testing')
    page.send_keys(:tab)

    iframe = find('iframe[id^="tiny-react_"]')
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('Testing')
      page.send_keys(:tab)
    end

    click_on "Create Task"

    sleep(2)
    within('.Sidebar') do
      find('span', text: 'CONTACTS').click
    end
    find_by_id('contact-search').click
    page.send_keys('qa tests uat mail')
    sleep(2)
    find_all('.row').last.click
    click_button 'Messages'

    # Go to the Timeline tab check if message was reflected.
    click_button 'Timeline'
    page.current_path
  end

  def sync_messages_from_files
    sleep(3)
    page_refresh
    # Click on UPLOAD FILES in the File List.
    click_link "Upload File"
    modal = find('.modal')
    within(modal) do
      find_all('.labelValue').first.click
      # Click the Recipient dropdown list then choose the contact to assign.
      find_by_id('react-select-5-input').click
      page.send_keys('adnan qa qa')
      page.has_text?('Adnan QA QA')
      page.send_keys(:tab)

      click_on "Ok"

      # Click the MONTH dropdown list the select desired month.
      find_by_id('react-select-2-input').click
      page.send_keys('2023')
      page.has_text?('2023')
      page.send_keys(:tab)

      # Click the MONTH dropdown list the select desired month.
      find_by_id('react-select-3-input').click
      page.send_keys('october')
      page.has_text?('October')
      page.send_keys(:tab)

      # Click TAGS to enter the tag name.
      find_by_id('tagId').click
      page.send_keys('Test')
      page.has_text?('Test')
      find('.dropdown-item').click

      # Click the Subject field then input the subject for the upload file.
      iframe = find('iframe[id^="tiny-react_"]')
      within_frame(iframe) do
        page.has_selector?('#tinymce')
        find_by_id('tinymce').click
        page.send_keys('Testing')
        page.send_keys(:tab)
      end

      # Click browse file section to browse and attach file.
      file_input = find('input[id="upload_doc"]', visible: :all)
      file_input.attach_file(fixtures_path.join('images', '404.png'))
      sleep(2)

      # Click on the Upload button.
      click_on "Upload"

    end
    page.current_path
  end

  def ensure_notes_reflected
    sleep(2)
    find('button[data-testid="message__to_field"]').click
    page.has_selector?('div[data-value]')
    recipient = fill_in 'messageRecipient', with: 'adnan ghaffar'
    sleep(2)

    page.has_text?('Adnan Ghaffar')
    recipient.send_keys(:enter)

    click_on 'Ok'

    find_by_id('NewMessage__SelectTemplate').click
    page.send_keys('Testing Message')
    page.send_keys(:tab)

    iframe = find('iframe[id^="tiny-react_"]')
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('Testing')
      page.send_keys(:tab)
    end

    click_on "Send"

    sleep(2)
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
