require_relative './base_page'
require_relative './login_page'

class FilePage < BasePage
  def go_to_files
    login_to_app
    within('.Sidebar') do
      click_on 'FILES', visible: true
    end
  end

  def go_to_files_as_client
    login_to_app_as_client
    within('.Sidebar') do
      click_on 'FILES'
    end
  end

  def go_to_messages_from_home
    login_to_app
    within('.Sidebar') do
      click_on 'HOME'
    end
    page.has_text?('+ Message')
    click_link '+ Message'
  end

  def go_to_tasks_from_add_new
    login_to_app
    within('.Sidebar') do
      find('span', text: 'ADD NEW').click
    end

    # Verify a drop-down menu displays
    page.has_css?('div[role="menu"]')
    div = find('div[role="menu"]')

    page.has_css?('div[role="menuitem"]')
    div.find('div[role="menuitem"]', text: 'Task').click
    find('div[role="menuitem"]', text: 'Request Information').click
    sleep(1)
  end

  def go_to_file_from_add_new
    login_to_app
    sleep(2)
    within('.Sidebar') do
      find('span', text: 'ADD NEW').click
    end

    # Verify a drop-down menu displays
    page.has_css?('div[role="menu"]')
    div = find('div[role="menu"]')

    page.has_css?('div[role="menuitem"]')
    sleep(2)
    div.find('div[role="menuitem"]', text: 'File').click
  end

  def go_to_message
    login_to_app
    sleep(3)
    find_all('.row')[1].click
  end

  def go_to_tasks
    login_to_app
    within('.Sidebar') do
      find('span', text: 'HOME').click
    end
  end


  def go_to_accounts
    login_to_app
    within('.Sidebar') do
      click_on 'ACCOUNTS'
    end
  end

  def go_to_contacts
    login_to_app
    within('.Sidebar') do
      click_on 'CONTACTS'
    end
  end

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

  def goto_new_message_from_bulk_action
    login_to_app

    within('.Sidebar') do
      find('span', text: 'BULK ACTIONS').click
    end
    sleep(2)
    div = find('div[role="menu"]')
    within div do
      page.has_text?('Send Message')
      div.find('div[role="menuitem"]', text: 'Send Message').click
    end
  end

  def goto_get_sign_from_bulk_action
    login_to_app

    within('.Sidebar') do
      find('span', text: 'BULK ACTIONS').click
    end
    sleep(2)
    div = find('div[role="menu"]')
    within div do
      page.has_text?('Send Message')
      div.find('div[role="menuitem"]', text: 'Get Signature').click
    end
  end

  def goto_send_edoc_from_bulk_action
    login_to_app

    within('.Sidebar') do
      find('span', text: 'BULK ACTIONS').click
    end
    sleep(2)
    div = find('div[role="menu"]')
    within div do
      page.has_text?('Send Message')
      div.find('div[role="menuitem"]', text: 'Send eDocs').click
    end
  end

  def go_to_billing
    login_to_app
    within('.Sidebar') do
      find('span', text: 'BILLING').click
    end
  end

  def go_to_emails
    login_to_app
    within('.Sidebar') do
      click_on 'EMAILS'
    end
  end

  def upload_file_while_creating_template
    goto_templates_from_admin

    # Click on + Template button
    click_link '+ Template'

    # Click on the SUBJECT field
    fill_in 'title', with: 'test'

    # Click on Browse link under Attachments section
    click_on 'Browse'


    # Type random message in DESCRIPTION field
    file_input = find('input[id="upload_doc"]', visible: :all)
    file_input.attach_file(fixtures_path.join('images', '404.png'))
    sleep(2)

    # Fill in Tags Field
    find_by_id('tagId').click
    page.send_keys('Test')
    find('.dropdown-item').click
    click_on "Upload"
    page.has_text?('Updated successfully.')
    page.has_text?('404.pdf')
    page.current_path
  end

  def upload_file_in_existing_template
    goto_templates_from_admin

    # Verify a Liscio loading animation displays
    wait_for_loading_animation

    expect(page).to have_current_path('/templates')

    page.has_selector?('tr.tdBtn')

    draggable_id = find_all('tr.tdBtn').first['data-rbd-draggable-id']
    find_all('tr.tdBtn').first.hover
    edit_button_id = "Tooltip-edit#{draggable_id}"
    page.has_selector?("##{edit_button_id}")
    find("##{edit_button_id}").click

    expect(page).to have_current_path("/templates/#{draggable_id}")

    click_on 'Browse'

    # Type random message in DESCRIPTION field
    file_input = find('input[id="upload_doc"]', visible: :all)
    file_input.attach_file(fixtures_path.join('images', '404.png'))
    wait_for_text(page, 'Preview')

    # Fill in Tags Field
    find_by_id('tagId').click
    page.send_keys('Test')
    find('.dropdown-item').click
    click_on "Upload"
    page.has_text?('Updated successfully.')
    page.has_text?('404.pdf')
    page.current_path
  end

  def go_to_edoc_from_add_new
    login_to_app
    within('.Sidebar') do
      find('span', text: 'ADD NEW').click
    end

    # Verify a drop-down menu displays
    page.has_css?('div[role="menu"]')
    div = find('div[role="menu"]')

    page.has_css?('div[role="menuitem"]')
    sleep(2)
    div.find('div[role="menuitem"]', text: 'eDoc').click
  end

  def ensure_content_are_not_blocked
    wait_for_selector('article')
    sleep(3)
    page_refresh
    expect(page).to have_current_path('/files')
    page.has_selector?('.tRow--body')
    table_body = find('.tRow--body')
    first_record = table_body.find_all('.row').first
    first_record.click

    expect(page).to have_current_path('/files')

    page.has_selector?('iframe[title="selected attachment"]')
    iframe = find('iframe[title="selected attachment"]')

    within_frame iframe do
      body = find('body').text
      expect(body).not_to include('This content is blocked. Contact the site owner to fix the issue.')
    end
    page.current_path
  end

  def fill_info_in_new_message_home
    page.has_css?('.inputHelper')
    find('.inputHelper').click
    # Verify a RECIPIENT + ACCOUNT search box displays
    page.has_selector?('div[data-value]')

    # Select Recipient
    page.send_keys('angus')
    page.has_text?('Angus McFife')
    page.send_keys(:enter)

    # Select Account
    page.send_keys(:tab)
    page.send_keys('angus')
    page.has_text?('Angus Adventures')
    page.send_keys(:enter)


    click_on 'Ok'

    page.has_selector?('labelValue')
    subject_div = find_all('.labelValue')[1].click
    page.send_keys("Test")
    page.send_keys(:tab)

    page.has_selector?('iframe')
    iframe = find_all('iframe')
    within_frame iframe[0] do
      body_div = find_by_id('tinymce').click
      body_div.send_keys("Testing new message with file attachment")
    end
  end

  def attach_files_with_task
    page.has_text?('CREATE TASK')

    # Click on FOR ACCOUNT field “Select…” bar

    account = find_all('input[role="combobox"]')[0].click
    page.send_keys('angus')
    page.has_text?('Angus Adventures')
    page.send_keys(:tab)
    sleep(1)

    # Click on FOR CONTACT field “Select…” bar
    contact = find_by_id('react-select-5-input').click
    page.send_keys('aquifa')
    page.has_text?('Aquifa Tron Halbert')
    page.send_keys(:tab)

    # Click on the SUBJECT field
    subject = find_all('input[role="combobox"]')[1].click
    page.send_keys('Attached Files')
    page.send_keys(:tab)

    # Type random message in DESCRIPTION field
    page.has_selector?('iframe')
    iframe = find_all('iframe')
    within_frame iframe[0] do
      body_div = find_by_id('tinymce').click
      body_div.send_keys("Testing new message from task with file attachment")
    end

    find('.fileContainer.text-capitalize a', text: 'Browse').click
    file_input = find('input[id="upload_doc"]', visible: :all)
    file_input.attach_file(fixtures_path.join('images', '404.png'))
    sleep(2)
    find_by_id('tagId').click
    page.send_keys('Test')
    find('.dropdown-item').click
    click_on "Upload"

    # Click on Create Task button
    click_on "Create Task"
  end


  def attach_files_with_message
    fill_info_in_new_message_home
    find('.fileContainer.text-capitalize a', text: 'Browse').click
    find_by_id('tagId').click
    page_refresh
    fill_info_in_new_message_home
    find('.fileContainer.text-capitalize a', text: 'Browse').click
    find_by_id('tagId').click
    page.send_keys('Test')
    find('.dropdown-item').click
    file_input = find('input[id="upload_doc"]', visible: :all)
    file_input.attach_file(fixtures_path.join('pdfs', 'dummy.pdf'))
    click_on "Upload"
    sleep(3)
    click_on 'Send'
  end

  def attach_files_with_edoc
    # Click on FOR ACCOUNT field “Select…” bar
    page.has_css?('.inputHelper')
    find('.inputHelper').click
    # Verify a RECIPIENT + ACCOUNT search box displays
    page.has_selector?('div[data-value]')

    # Select Recipient
    page.send_keys('aquifa')
    page.has_text?('Aquifa Tron Halbert')
    page.send_keys(:tab)

    click_on "Ok"

    agreemnet = find_all('input[role="combobox"]')[0].click
    page.send_keys('Proposal')

    find_all('span', text: 'Proposal').last.click
    sleep(1)
    click_on 'Prepare Doc for Signing'
    document_iframe = find('iframe[title="Authoring Page"]')
    within_frame document_iframe do
      signature_field = find('.field-signature')
      document = find('img[data-src]')

      signature_field.drag_to document
      click_on 'Send'
    end
    sleep(3)
  end

  def upload_file_from_home
    modal = find('.modal')
    within(modal) do
      find_all('.labelValue').first.click
      # Click the Recipient dropdown list then choose the contact to assign.
      find_by_id('react-select-5-input').click
      page.send_keys('adnan ghaffar')
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

      # Check the Do not send Message checkbox
      find_all('.checkbox')[1].click

      # Click browse file section to browse and attach file.
      file_input = find('input[id="upload_doc"]', visible: :all)
      file_input.attach_file(fixtures_path.join('images', '404.png'))

      # Click on the Upload button.
      click_on "Upload"
    end
    page.current_path
  end

  def upload_file_from_reply_section
    # Click on the Reply section to expand field and see Attachments section
    find('textarea[name="description"]').click

    # Click on Browse link in Attachments section
    find('.fileContainer.text-capitalize a', text: 'Browse').click

    # Fill in Tags Field
    find_by_id('tagId').click
    page.send_keys('Test')
    find('.dropdown-item').click

    # Click on Browse link in File section
    file_input = find('input[id="upload_doc"]', visible: :all)
    file_input.attach_file(fixtures_path.join('images', '404.png'))
    sleep(2)

    # Select file to attach and upload
    click_on "Upload"

    page.current_path
  end

  def upload_file_from_tasks
    page_refresh
    # Click on Browse link in Attachments section
    find('.fileContainer.text-capitalize a', text: 'Browse').click

    # Click on Browse link in File section
    file_input = find('input[id="upload_doc"]', visible: :all)
    file_input.attach_file(fixtures_path.join('images', '404.png'))
    sleep(2)

    # Fill in Tags Field
    find_by_id('tagId').click
    page.send_keys('Test')
    find('.dropdown-item').click

    # Select file to attach and upload
    click_on "Upload"

    page.current_path
  end

  def upload_file_from_existing_tasks
    # From Home Dashboard, click on an existing Task under Tasks section
    task_selector = 'div[data-testid="row-0"]'
    wait_for_selector(task_selector)
    find(task_selector).click

    # Click on Browse link in Attachments section
    find('.fileContainer.text-capitalize', text: 'Browse').click

    # Fill in Tags Field
    find_by_id('tags').click
    page.send_keys('Test')
    find('.dropdown-item').click

    # Click on Browse link in File section
    file_input = find('input[id="upload_doc"]', visible: :all)
    file_input.attach_file(fixtures_path.join('images', '404.png'))

    # Select file to attach and upload
    wait_for_text(page, 'Preview')
    click_on "Upload"

    page.current_path
  end

  def upload_file_account_infocus
    # Click on ABC Testing Inc
    find('div.tRow.tRow--body a', text: 'ABC Testing Inc.').click

    # Click on In Focus tab
    click_on "In Focus"
    sleep(2)
    # Scroll down to Files section and click on + File button
    find_all('button', text: "File")[1].click

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

    # Check the Do not send Message checkbox
    find_all('.checkbox')[1].click

    # Click browse file section to browse and attach file.
    file_input = find('input[id="upload_doc"]', visible: :all)
    file_input.attach_file(fixtures_path.join('images', '404.png'))

    # Click on the Upload button.
    click_on "Upload"

    page.current_path
  end

  def upload_file_account_files
    # Click on ABC Testing Inc
    find('div.tRow.tRow--body a', text: 'ABC Testing Inc.').click

    # Click on In Files tab
    click_on "Files"
    sleep(2)

    # Click on + Upload File button
    click_link "Upload File"

    # Fill in To (Recipient) field, Subject and Tags Field
    find_all('.labelValue').first.click

    # Click the Recipient dropdown list then choose the contact to assign.
    find_by_id('react-select-5-input').click
    page.send_keys('adnan ghaffar')
    sleep(2)
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

    # Check the Do not send Message checkbox
    find_all('.checkbox').last.click

    # Click browse file section to browse and attach file.
    file_input = find('input[id="upload_doc"]', visible: :all)
    file_input.attach_file(fixtures_path.join('images', '404.png'))
    sleep(6)

    # Click on the Upload button.
    click_on "Upload"

    page.current_path
  end

  def upload_file_contact_files
    sleep(3)
    page_refresh

    # Search for "QA" and click on UAT Mail, QA Test
    find_by_id('contact-search').click
    page.send_keys('qa tests uat mail')
    sleep(3)
    find_all('.row').last.click

    # Click on Files tab
    click_on "Files"

    # Click on + Upload File button
    click_link "Upload File"

    # Click the YEAR dropdown list the select desired month.
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

    # Click browse file section to browse and attach file.
    file_input = find('input[id="upload_doc"]', visible: :all)
    file_input.attach_file(fixtures_path.join('images', '404.png'))
    wait_for_text(page, 'Preview')

    # Click on the Upload button.
    click_on "Upload"

    page.current_path
  end

  def upload_file_bulk_actions
    # Click on the Select all checkbox to Select all Contacts in the current page
    find_by_id('selectallcheckbox', visible: :all).check

    # Scroll down and click on Next Step button
    click_on "Next Step"

    # Fill in Message Title Field
    find_by_id('react-select-2-input').click
    page.send_keys('Testing')
    page.send_keys(:tab)

    # Click on Browse link in Attachments section
    find('.fileContainer.text-capitalize', text: 'Browse').click

    # Fill in Tags Field
    find_by_id('tags').click
    page.send_keys('Test')
    page.has_text?('Test')
    find('.dropdown-item').click

    # Click browse file section to browse and attach file.
    file_input = find('input[id="upload_doc"]', visible: :all)
    file_input.attach_file(fixtures_path.join('images', '404.png'))
    sleep(4)

    # Click on the Upload button.
    click_on "Upload"

    page.current_path
  end

  def upload_file_get_sign
    # Click on the Select all checkbox to Select all Contacts in the current page
    find_by_id('selectallcheckbox', visible: :all).check

    # Scroll down and click on Next Step button
    click_on "Next Step"

    # Click on Browse link in Attachments section
    find('.fileContainer.text-capitalize', text: 'Browse').click

    # Fill in Tags Field
    find_by_id('tags').click
    page.send_keys('Test')
    page.has_text?('Test')
    find('.dropdown-item').click

    # Click browse file section to browse and attach file.
    file_input = find('input[id="upload_doc"]', visible: :all)
    file_input.attach_file(fixtures_path.join('images', '404.png'))
    sleep(4)

    # Click on the Upload button.
    click_on "Upload"

    page.current_path
  end

  def upload_file_send_edocs
    sleep(2)
    page_refresh
    # Click on the Select all checkbox to Select all Contacts in the current page
    find_by_id('selectallcheckbox', visible: :all).check

    # Scroll down and click on Next Step button
    click_on "Next Step"

    find_by_id('agreementTitle').click
    page.send_keys('Testing')
    page.send_keys(:tab)

    # Click on Browse link in Attachments section
    find('.fileContainer.text-capitalize', text: 'Templates').click
    sleep(3)
    page.current_path
  end

  def upload_file_billing
    # Click on S.P.E.W Design Charges invoice
    find_by_id('message-search').click
    page.send_keys('Design Charges')
    wait_for_text(page, 'S.P.E.W')
    find_all('.BillingTableRow').first.click

    sleep(2)
    page_refresh
    # Click on Browse link in Attachments section
    find('.fileContainer.text-capitalize', text: 'Browse').click

    # Fill in Tags Field
    find_by_id('tags').click
    page.send_keys('Test')
    page.has_text?('Test')
    find('.dropdown-item').click

    # Click browse file section to browse and attach file.
    file_input = find('input[id="upload_doc"]', visible: :all)
    file_input.attach_file(fixtures_path.join('images', '404.png'))
    wait_for_text(page, 'Preview')

    # Click on the Upload button.
    click_on "Upload"

    page.current_path
  end

  def upload_adding_reply
    # Open an existing email sent to your account
    find_all('.EmOne__Border').first.click

    # Reply to that conversation
    find('div[title="Reply"]').click

    # Click browse file section to browse and attach file.
    file_input = find('input.upload_doc', visible: false)
    file_input.attach_file(fixtures_path.join('images', '404.png'))
    sleep(4)

    page.current_path
  end

  def upload_firm_only_file
    # Click on the Firm Only checkbox
    find_all('.checkbox').first.click

    # Fill in To (Recipient) field, select Recipient
    page.has_selector?('labelValue')
    subject_div = find_all('.labelValue').first.click
    page.send_keys('adnan ghaff')
    wait_for_text(page, 'Adnan Ghaffar')
    page.send_keys(:tab)
    click_on "Ok"

    # Select Financial tag
    find_by_id('tagId').click
    page.send_keys('Financial')
    find('.dropdown-item').click

    # Click browse file section to browse and attach file.
    file_input = find('input[id="upload_doc"]', visible: :all)
    file_input.attach_file(fixtures_path.join('images', '404.png'))
    sleep(4)

    # Click on the Upload button.
    click_on "Upload"

    # Go to Files Tab by clicking it from the left nav menu and check latest file uploaded
    within('.Sidebar') do
      click_on 'FILES'
    end
    page.has_text?('404.pdf')

    # Go to Accounts tab from Left nav menu
    within('.Sidebar') do
      click_on 'ACCOUNTS'
    end

    # Search for the account you used for the recipient
    find_by_id('account-search').click
    page.send_keys('abc testing')
    sleep(3)

    # Click on that account
    find_all('.row').last.click

    # Go to Files tab, check latest file uploaded
    click_on "Files"
    page.has_text?('404.pdf')

    page.current_path
  end

  def check_files_under_files
    login_to_app

    # From Home Dashboard, click Files from the left nav menu
    within('.Sidebar') do
      click_on 'FILES'
    end
    sleep(3)
    page_refresh
    page.has_text?('ACTIVE')
    page.has_text?('ALL FILES')
    page.has_text?('CLIENT UPLOAD')

    page.current_path
  end

  def check_files_under_accounts
    login_to_app

    # From Home Dashboard, click Accounts from the left nav menu
    within('.Sidebar') do
      click_on 'ACCOUNTS'
    end

    # Go to Files tab
    find_all('.row')[1].click
    find('button[data-testid="inbox__files"]').click

    page.current_path
  end

  def check_files_restricted_accounts
    login_to_app

    # From Home Dashboard, click Accounts from the left nav menu
    within('.Sidebar') do
      click_on 'ACCOUNTS'
    end
    sleep 3
    page_refresh

    find_all('.checkbox.checkbox-primary.check-container').first.click

    find_all('.row')[1].click

    find('button[data-testid="inbox__files"]').click
    page.current_path
  end

  def only_see_files_under_accounts
    login_to_app

    # From Home Dashboard, click Accounts from the left nav menu
    within('.Sidebar') do
      click_on 'ACCOUNTS'
    end
    sleep 3
    page_refresh
    sleep 2

    # Go to Files tab
    page.has_selector?('.row')
    find_all('.row')[1].click
    find('button[data-testid="inbox__files"]').click

    page.current_path
  end

  def check_files_under_contacts
    login_to_app

    # From Home Dashboard, click Accounts from the left nav menu
    within('.Sidebar') do
      click_on 'CONTACTS'
    end
    sleep(2)
    page_refresh

    # Go to Files tab
    find_all('.row')[1].click
    click_on "Files"

    page.current_path
  end

  def edit_file_via_click_filename
    sleep(3)
    page_refresh

    # Select a file from the file list by clicking its file name
    page.has_selector?('.filename')
    find_all('.fileName').first.click

    # Click on the Edit button located at the upper right corner of the file preview screen
    page.has_selector?('button[data-for=edit_icon]')
    edit_button = find('button[data-for=edit_icon]')
    edit_button.click

    # Make changes on the current file name
    page.has_selector?('input[name="filename"]')
    file_name_field = find('input[name="filename"]')
    file_name_field.click
    file_name_field.set('')
    page.send_keys("Testing")
    page.send_keys(:tab)

    # Change current tag to a different one
    find('#multitags').click
    close_buttons = all('.icon-close2.remove')
    close_buttons.each(&:click)
    find('#multitags').click
    find_all('.dropdown-item').last.click

    # Add a Year
    page.has_selector?('#react-select-2-input')
    find('#react-select-2-input').click
    page.send_keys('2023')
    page.send_keys(:tab)

    # Add a Month
    page.has_selector?('#react-select-3-input')
    find('#react-select-3-input').click
    page.send_keys('April')
    page.send_keys(:tab)

    # Click Save Changes button
    click_on "Save Changes"
    page.current_path
  end

  def not_able_to_edit_file
    sleep(3)
    page_refresh

    # Select a file from the file list by clicking its file name
    page.has_selector?('.filename')
    find_all('.fileName')[1].click

    # Click on the Edit button located at the upper right corner of the file preview screen
    page.has_selector?('button[data-for=edit_icon]')
    edit_button = find('button[data-for=edit_icon]')
    edit_button.click

    # Remove current File name
    page.has_selector?('input[name="filename"]')
    file_name_field = find('input[name="filename"]')
    file_name_field.click
    file_name_field.set('')

    # Remove current tag
    close_buttons = all('.icon-close2.remove')
    close_buttons.each(&:click)

    # Click Save Changes button
    click_on "Save Changes"
    page.current_path
  end

  def edit_bulk_file
    sleep(3)
    page_refresh

    # Select multiple files by clicking on the checkbox beside the file name
    page.has_selector?('.checkbox')
    find_all('.checkbox')[1].click
    find_all('.checkbox')[2].click

    # Click on the Tag icon located at the bottom of the files list
    find('.icon-tag').click

    # Select Add & Remove Tags
    click_on "Add & Remove Tags"

    # Select these tags: Agreements, Financial tags
    find('#react-select-2-input').click
    page.send_keys('Financial')
    page.send_keys(:tab)

    page.send_keys('Agreements')
    page.send_keys(:tab)

    # Click on Add Tag button
    click_on "Add Tag"

    page.current_path
  end

  def edit_bulk_file_year
    sleep(3)
    page_refresh

    # Select multiple files by clicking on the checkbox beside the file name
    page.has_selector?('.checkbox')
    find_all('.checkbox')[1].click
    find_all('.checkbox')[2].click

    # Click on the Tag icon located at the bottom of the files list
    find('.icon-tag').click

    # Select Add & Remove Tags
    click_on "Add & Remove Tags"

    # Toggle Year radio button
    find('input#Year', visible: :all).click

    # Select a Year
    page.has_selector?('#react-select-3-input')
    find('#react-select-3-input').click
    page.send_keys('2023')
    page.send_keys(:tab)

    # Click on Replace button
    click_on "Replace"

    page.current_path
  end

  def edit_bulk_file_month
    sleep(3)
    page_refresh

    # Select multiple files by clicking on the checkbox beside the file name
    page.has_selector?('.checkbox')
    find_all('.checkbox')[1].click
    find_all('.checkbox')[2].click

    # Click on the Tag icon located at the bottom of the files list
    find('.icon-tag').click

    # Select Add & Remove Tags
    click_on "Add & Remove Tags"

    # Toggle Month radio button
    find('input#Month', visible: :all).click

    # Select a Month
    page.has_selector?('#react-select-3-input')
    find('#react-select-3-input').click
    page.send_keys('March')
    page.send_keys(:tab)

    # Click on Replace button
    click_on "Replace"

    page.current_path
  end

  def remove_tag_bulk_files
    sleep(3)
    page_refresh

    # Select multiple files by clicking on the checkbox beside the file name
    page.has_selector?('.checkbox')
    find_all('.checkbox')[1].click
    find_all('.checkbox')[2].click

    # Click on the Tag icon located at the bottom of the files list
    find('.icon-tag').click

    # Select Add & Remove Tags
    click_on "Add & Remove Tags"

    # Select these tags: Agreements, Financial tags
    find('#react-select-2-input').click
    page.send_keys('Financial')
    page.send_keys(:tab)

    page.send_keys('Agreements')
    page.send_keys(:tab)

    # Click on Remove Tag button
    click_on "Remove Tag"

    page.current_path
  end

  def remove_year_bulk_files
    sleep(3)
    page_refresh

    # Select multiple files by clicking on the checkbox beside the file name
    page.has_selector?('.checkbox')
    find_all('.checkbox')[1].click
    find_all('.checkbox')[2].click

    # Click on the Tag icon located at the bottom of the files list
    find('.icon-tag').click

    # Select Add & Remove Tags
    click_on "Add & Remove Tags"

    # Toggle Year radio button
    find('input#Year', visible: :all).click

    # Select Blank under Year dropdown
    page.has_selector?('#react-select-3-input')
    find('#react-select-3-input').click
    page.send_keys('Blank')
    page.send_keys(:tab)

    # Click on Replace button
    click_on "Replace"

    page.current_path
  end

  def remove_month_bulk_files
    sleep(3)
    page_refresh

    # Select multiple files by clicking on the checkbox beside the file name
    page.has_selector?('.checkbox')
    find_all('.checkbox')[1].click
    find_all('.checkbox')[2].click

    # Click on the Tag icon located at the bottom of the files list
    find('.icon-tag').click

    # Select Add & Remove Tags
    click_on "Add & Remove Tags"

    # Toggle Month radio button
    find('input#Month', visible: :all).click

    # Select Blank under Month dropdown
    page.has_selector?('#react-select-3-input')
    find('#react-select-3-input').click
    page.send_keys('Blank')
    page.send_keys(:tab)

    # Click on Replace button
    click_on "Replace"

    page.current_path
  end

  def attach_multiple_tags_to_file
    sleep(3)
    page_refresh

    # Select a file from the file list by clicking its file name
    page.has_selector?('.filename')
    sleep(3)
    find_all('.fileName')[1].click

    # Click on the Edit button located at the upper right corner of the file preview screen
    page.has_selector?('button[data-for=edit_icon]')
    edit_button = find('button[data-for=edit_icon]')
    edit_button.click

    # Select three different tags
    find('#multitags').click
    close_buttons = all('.icon-close2.remove')
    close_buttons.each(&:click)

    find('#multitags').click
    find_all('.dropdown-item').last.click
    find('#multitags').click
    find_all('.dropdown-item').last(2).first.click
    find('#multitags').click
    find_all('.dropdown-item').last(3).first.click

    # Click Save Changes button
    click_on "Save Changes"
    page.current_path
  end

  def remove_multiple_tags_to_file
    sleep(3)
    page_refresh

    # Select a file from the file list by clicking its file name
    page.has_selector?('.filename')
    find_all('.fileName')[1].click

    # Click on the Edit button located at the upper right corner of the file preview screen
    page.has_selector?('button[data-for=edit_icon]')
    edit_button = find('button[data-for=edit_icon]')
    edit_button.click

    # Remove Invoice, eDoc, Client Upload, Liscio Vault in selected tags
    find('#multitags').click
    close_buttons = all('.icon-close2.remove')
    close_buttons.each(&:click)

    # Click Save Changes button
    click_on "Save Changes"
    page.current_path
  end

  def redirect_task_via_source
    sleep(2)
    page_refresh
    # Click on SOURCE button to filter Files list
    page.has_selector?('button')
    sleep(2)
    find_all('button', text: "SOURCES").first.click

    # In source dropdown, check Task
    page.has_selector?('span')
    page.has_text?('Task')
    find_all('span', text: "Task").first.click

    # Click anywhere outside dropdown list
    page.driver.browser.action.send_keys(:escape).perform
    sleep(3)
    # Click any file on the list
    page.has_selector?('.row')
    row = find_all('.row')[1].click
    sleep(3)
    # From file preview, look at the right side and look for Source information
    page.has_text?('Task')
    page.current_path
  end

  def redirect_message_via_source
    sleep(2)
    page_refresh
    # Click on SOURCE button to filter Files list
    page.has_selector?('button')
    find_all('button', text: "SOURCES").first.click

    # In source dropdown, check Message
    page.has_selector?('span')
    page.has_text?('Message')
    find_all('span', text: "Message").first.click

    # Click anywhere outside dropdown list
    page.driver.browser.action.send_keys(:escape).perform
    sleep(3)
    # Click any file on the list
    page.has_selector?('.row')
    row = find_all('.row')[1].click
    sleep(3)
    # From file preview, look at the right side and look for Source information
    page.has_text?('Message')
    page.current_path
  end

  def redirect_note_via_source
    sleep(2)
    page_refresh
    # Click on SOURCE button to filter Files list
    page.has_selector?('button')
    find_all('button', text: "SOURCES").first.click

    # In source dropdown, check Note
    page.has_selector?('span')
    page.has_text?('Note')
    find_all('span', text: "Note").first.click

    # Click anywhere outside dropdown list
    page.driver.browser.action.send_keys(:escape).perform
    sleep(3)
    # Click any file on the list
    page.has_selector?('.row')
    row = find_all('.row')[1].click
    sleep(3)
    # From file preview, look at the right side and look for Source information
    page.has_text?('Note')
    page.current_path
  end

  def redirect_note_via_source_client
    sleep(2)
    page_refresh
    # Click on SOURCE button to filter Files list
    page.has_selector?('button')
    find_all('button', text: "SOURCES").first.click

    # Click any file on the list
    page.driver.browser.action.send_keys(:escape).perform
    sleep(3)
    page.has_selector?('.row')
    row = find_all('.row')[1].click
    sleep(3)
    # From file preview, look at the right side and look for Source information
    page.has_text?('Note')
    page.current_path
  end

  def redirect_bill_via_source
    sleep(2)
    page_refresh
    # Click on SOURCE button to filter Files list
    page.has_selector?('button')
    source_filter = find_all('button', text: "SOURCES").first
    source_filter.click

    # In source dropdown, check Bill
    page.has_selector?('span')
    page.has_text?('Bill')
    find_all('span', text: "Bill").first.click

    # Click anywhere outside dropdown list
    page.driver.browser.action.send_keys(:escape).perform
    sleep(3)
    # Click any file on the list
    page.has_selector?('.row')
    row = find_all('.row')[1].click
    sleep(3)
    # From file preview, look at the right side and look for Source information
    page.has_text?('Bill')
    page.current_path
  end

  def redirect_bill_via_source_client
    sleep(2)
    page_refresh
    # Click on SOURCE button to filter Files list
    page.has_selector?('button')
    source_filter = find_all('button', text: "SOURCES").first
    source_filter.click

    # In source dropdown, check Bill
    page.has_selector?('span')
    page.has_text?('Bill')
    find_all('span', text: "Bill").first.click

    # Click anywhere outside dropdown list
    page.driver.browser.action.send_keys(:escape).perform
    sleep(3)
    # Click any file on the list
    page.has_selector?('.row')
    row = find_all('.row')[1].click
    sleep(3)
    # From file preview, look at the right side and look for Source information
    page.has_text?('Bill')
    page.current_path
  end

  def view_more_details_via_manual
    sleep(2)
    page_refresh
    # Click on SOURCE button to filter Files list
    page.has_selector?('button')
    find_all('button', text: "SOURCES").first.click

    # In source dropdown, check Manual
    page.has_selector?('span')
    page.has_text?('Manual')
    find_all('span', text: "Manual").first.click
    sleep(3)
    # Click anywhere outside dropdown list
    page.driver.browser.action.send_keys(:escape).perform

    # Click any file on the list
    page.has_selector?('.row')
    row = find_all('.row')[1].click
    sleep(3)
    # From file preview, look at the right side and look for Source information
    page.has_text?('Manual')
    page.current_path
  end

  def view_more_details_via_multiple_source
    sleep(3)
    page_refresh

    # Click on +Upload File
    click_on "Upload File", visible: true

    # Fill in To (Recipient) field, Subject and Tags Field
    find_all('.customTags__input').first.click
    find('#react-select-5-input').click
    page.send_keys('Adnan QA QA')
    page.send_keys(:enter)

    click_on "Ok", visible: true

    find_by_id('tagId').click
    page.send_keys('Test')
    page.has_text?('Test')
    find('.dropdown-item').click

    iframe = find('iframe[id^="tiny-react_"]')
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('Testing')
      page.send_keys(:tab)
    end

    # Click on Browse link under File section
    file_input = find('input[id="upload_doc"]', visible: :all)
    file_input.attach_file(fixtures_path.join('images', '404.png'))
    wait_for_text(page, 'Preview')

    # Click Upload button
    click_on "Upload", visible: true

    # Click on Tasks from left nav menu
    within('.Sidebar') do
      click_on 'TASKS'
    end

    # Click on +Task button
    find_all('a', text: "Task")[1].click

    # Select Task Type: Request Information
    page.has_text?('Request Information')

    # Select For Contact: QA Test UAT Mail
    find('#react-select-13-input').click
    page.send_keys('qa tests uat mail')
    page.has_text?('QA Tests UAT Mail')
    page.send_keys(:enter)

    # Select For Account: Anime World
    find('#react-select-11-input').click
    page.send_keys('anime world')
    page.has_text?('Anime World')
    page.send_keys(:enter)


    # Click on Liscio Vault link under Attachments section
    find('.fileContainer.text-capitalize a', text: 'Browse').click

    find_by_id('tagId').click
    page.send_keys('test')
    page.has_text?('Test')
    find('.dropdown-item').click

    file_input = find('input[id="upload_doc"]', visible: :all)
    file_input.attach_file(fixtures_path.join('images', '404.png'))
    sleep 4

    click_on "Upload", visible: true

    # Click on + Create Task button
    click_on "Create Task", visible: true

    # Click on Files from the left nav menu
    within('.Sidebar') do
      click_on 'FILES'
    end

    # Look for the exact file you uploaded from earlier steps and view it
    page.has_selector?('.row')
    row = find_all('.row')[1].click

    page.current_path
  end

  def view_details_via_multiple_source_client
    sleep(6)
    page_refresh

    # Click on +Upload File
    click_on "Upload File", visible: true

    # Fill in To (Recipient) field, Subject and Tags Field
    find_all('.customTags__input').first.click

    # Click on Browse link under File section
    file_input = find('input[id="upload_doc"]', visible: :all)
    file_input.attach_file(fixtures_path.join('images', '404.png'))
    sleep 4
    # Click Upload button
    click_on "Upload", visible: true

    # Click on Tasks from left nav menu
    within('.Sidebar') do
      click_on 'TASKS'
    end

    # Click on Files from the left nav menu
    within('.Sidebar') do
      click_on 'FILES'
    end

    # Look for the exact file you uploaded from earlier steps and view it
    page.has_selector?('.row')
    row = find_all('.row')[1].click

    page.current_path
  end

  def attach_files_with_existing_templates
    find_all('.tdBtn').first.click
    button = find('button[id^="Tooltip-edit"]')
    button.hover
    button.click
    find('a[data-testid="attachments__browse"]').click

    find_by_id('tagId').click
    page.send_keys('Test')
    page.has_text?('Test')
    find('.dropdown-item').click

    file_input = find('input[id="upload_doc"]', visible: :all)
    file_input.attach_file(fixtures_path.join('images', '404.png'))
    sleep(2)
    click_on "Upload"

    sleep(2)
    click_on "Update Template"
    page.current_path
  end

  def attach_files_with_edoc_template
    find('button[data-testid="inbox__edoc_template"]').click
    sleep(3)

    click_on "+ Template"

    find('input[data-testid="title"]').click
    page.send_keys("Testing file")

    iframe = find('iframe[id^="tiny-react_"]')
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('Testing')
      page.send_keys(:tab)
    end

    find('a[data-testid="attachments__browse"]').click

    find_by_id('tagId').click
    page.send_keys('Test')
    page.has_text?('Test')
    find('.dropdown-item').click

    file_input = find('input[id="upload_doc"]', visible: :all)
    file_input.attach_file(fixtures_path.join('images', '404.png'))
    sleep(2)
    click_on "Upload"

    click_on "Create Template"
    page.current_path
  end

  def attach_files_with_message_template
    click_on "+ Template"

    find('input[data-testid="title"]').click
    page.send_keys("Testing file")

    iframe = find('iframe[id^="tiny-react_"]')
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('Testing')
      page.send_keys(:tab)
    end

    find('a[data-testid="attachments__browse"]').click

    find_by_id('tagId').click
    page.send_keys('Test')
    page.has_text?('Test')
    find('.dropdown-item').click

    file_input = find('input[id="upload_doc"]', visible: :all)
    file_input.attach_file(fixtures_path.join('images', '404.png'))
    sleep(2)
    click_on "Upload"

    click_on "Create Template"
    page.current_path
  end

  def attach_files_with_task_template
    find('button[data-testid="inbox__task_template"]').click
    sleep(3)

    click_on "+ Template"

    find('input[data-testid="title"]').click
    page.send_keys("Testing file")

    iframe = find('iframe[id^="tiny-react_"]')
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('Testing')
      page.send_keys(:tab)
    end

    find('a[data-testid="attachments__browse"]').click

    find_by_id('tagId').click
    page.send_keys('Test')
    page.has_text?('Test')
    find('.dropdown-item').click

    file_input = find('input[id="upload_doc"]', visible: :all)
    file_input.attach_file(fixtures_path.join('images', '404.png'))
    sleep(2)
    click_on "Upload"

    click_on "Create Template"
    page.current_path
  end

  def attach_files_with_invoice_template
    find('button[data-testid="inbox__invoice_template"]').click
    sleep(3)

    click_on "+ Template"

    find('input[data-testid="title"]').click
    page.send_keys("Testing file")

    iframe = find('iframe[id^="tiny-react_"]')
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('Testing')
      page.send_keys(:tab)
    end

    find('a[data-testid="attachments__browse"]').click

    find_by_id('tagId').click
    page.send_keys('Test')
    page.has_text?('Test')
    find('.dropdown-item').click

    file_input = find('input[id="upload_doc"]', visible: :all)
    file_input.attach_file(fixtures_path.join('images', '404.png'))
    sleep(2)
    click_on "Upload"

    click_on "Create Template"
    page.current_path
  end

  def attach_files_with_existing_attachment
    find_all('.tdBtn').first.click
    button = find('button[id^="Tooltip-edit"]')
    button.hover
    button.click
    find('a[data-testid="attachments__browse"]').click

    find_by_id('tagId').click
    page.send_keys('Test')
    page.has_text?('Test')
    find('.dropdown-item').click

    file_input = find('input[id="upload_doc"]', visible: :all)
    file_input.attach_file(fixtures_path.join('images', '404.png'))
    sleep(2)
    click_on "Upload"

    sleep(2)
    click_on "Update Template"
    page.current_path
  end

  def files_list_sorted_by_added_date
    sleep 3
    page_refresh
    find('a[data-testid="files__upload_file_btn"]').click
    modal = find('.modal')
    within(modal) do
      find_all('.labelValue').first.click

      find_by_id('react-select-5-input').click
      page.send_keys('adnan ghaffar')
      page.send_keys(:tab)
      click_on "Ok"

      find_by_id('tagId').click
      page.send_keys('Test')
      page.has_text?('Test')
      find('.dropdown-item').click

      file_input = find('input[id="upload_doc"]', visible: :all)
      file_input.attach_file(fixtures_path.join('images', '404.png'))
      sleep(3)

      # Click on the Upload button.
      click_on "Upload"
    end
    page.current_path
  end

  def files_list_keyword_search
    sleep 3
    page_refresh
    find('input[data-testid="files__search_input"]').click
    page.send_keys("Test")
    page.current_path
  end

  def files_filter_via_type
    sleep 3
    page_refresh
    find_all('button[id="title-button"]').first.click
    find('span', text: "Firm Only File").click
    sleep 3
    page.current_path
  end

  def files_filter_via_source
    sleep 3
    page_refresh
    find('button', text: "SOURCES").click
    find('span', text: "Message").click
    sleep 3
    find('span', text: "Note").click
    page.current_path
  end

  def files_restricted_accounts
    expect(page).to have_current_path('/accounts')

    search_account_selector = 'input[data-testid="account__search_input"]'
    if !page.has_selector?(search_account_selector)
      page_refresh
    end

    account_search = find(search_account_selector)
    account_search.send_keys('abc')
    page.has_text?('ABC Inc')
    table = find('.tab-content')
    table.first('a').click

    click_on "Details"
    find('.btn.btn-link.btn--onlyicon.dropdown-toggle').click

    click_on "Edit Account"
    find_all('.checkbox.checkbox-primary.check-container').first.click
    find_all('.btn.btn-primary').first.click

    within('.Sidebar') do
      click_on 'FILES'
    end

    page.current_path
  end

  def verify_engagment_letter_on_accounts
    sleep 3

    find_by_id('account-search').click
    page.send_keys('abc testing')
    sleep(3)

    # Click on that account
    find_all('.row').last.click

    # Go to Files tab, check latest file uploaded
    click_on "Files"

    page.current_path
  end

  def verify_engagment_letter_on_contacts
    sleep(3)
    page_refresh

    find_by_id('contact-search').click
    page.send_keys('qa tests uat mail')
    sleep(3)
    find_all('.row').last.click

    click_on "Files"

    page.current_path
  end

  def verify_engagment_letter_on_files
    sleep(3)
    page_refresh

    find_all('.row')[2].click
    page.has_text?("FILE NAME")
    page.current_path
  end

  def verify_release_doc_on_files
    sleep(3)
    page_refresh

    find_all('.row')[2].click
    page.has_text?("Invoice")
    page.current_path
  end

  def manually_upload_file_large_size
    modal = find('.modal')
    within(modal) do
      find_all('.labelValue').first.click
      find_by_id('react-select-5-input').click
      page.send_keys('adnan ghaffar')
      page.send_keys(:tab)
      click_on "Ok"

      find_by_id('react-select-2-input').click
      page.send_keys('2023')
      page.has_text?('2023')
      page.send_keys(:tab)

      find_by_id('react-select-3-input').click
      page.send_keys('october')
      page.has_text?('October')
      page.send_keys(:tab)

      find_by_id('tagId').click
      page.send_keys('Test')
      page.has_text?('Test')
      find('.dropdown-item').click

      find_all('.checkbox')[1].click

      file_input = find('input[id="upload_doc"]', visible: :all)
      file_input.attach_file(fixtures_path.join('images', '404.png'))

      click_on "Upload"
    end
    page.current_path
  end

  private

  def login_to_app
    login_page.ensure_login_page_rendered

    login_page.sign_in_with_valid_user
    login_page.ensure_correct_credientials
    login_page
  end

  def login_to_app_as_client
    login_page.ensure_login_page_rendered

    login_page.sign_in_with_valid_client
    login_page.ensure_correct_credientials
    login_page
  end

  def login_page
    @login_page ||= LoginPage.new
  end
end
