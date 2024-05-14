require_relative './base_page'
require_relative './login_page'

class EdocPage < BasePage
  def go_to_edoc
    login_to_app
    click_on_sidebar_edoc_menu
  end

  def go_to_home
    login_to_app
    within('.Sidebar') do
      click_on 'HOME'
    end
  end

  def go_to_tasks
    login_to_app
    within('.Sidebar') do
      click_on 'TASKS'
    end
  end

  def go_to_bulk_actions
    login_to_app
    within('.Sidebar') do
      find('span', text: 'BULK ACTIONS').click
    end

    div = find('div[role="menu"]')
    within div do
      page.has_text?('Get Signature')
      div.find('div[role="menuitem"]', text: 'Invite to Download App').click
    end
    sleep 3
    page.current_path
  end

  def click_on_sidebar_edoc_menu
    edoc_selector = 'div[data-testid="sidebar__edocs"]'
    edoc_button = find(edoc_selector)
    wait_for_selector(edoc_selector)
    edoc_button.click
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
    sleep 1
    page_refresh
  end

  def goto_create_edoc
    sleep(3)
    page_refresh
    verify_tabs_displays
    page.has_selector?('.filter-wrapper')
    page.has_selector?('.tdBtn')
    filter = find('.filter-wrapper')
    filter.find('span', text: '+ eDoc').click

    page.has_selector?('a', text: 'Templates')
    find('a', text: 'Templates').click

    page.has_selector?('.modal-dialog')
    modal = find('.modal-dialog')

    within modal do
      page.has_text?('Templates List')
    end
  end

  def verify_tabs_displays
    status = ['In Progress', 'Completed', 'Cancelled', 'Draft']
    page.has_selector?('.nav-item')
    nav_items = find_all('.nav-item').each do |nav_item|
      # In Progress | Count
      nav_title = nav_item.text.split(' |').first
      expect(status).to include(nav_title)
    end
  end

  def sign_an_agreement
    mark_notifications_as_read
    page.has_text?('+ eDoc')
    click_on '+ eDoc'

    page.has_css?('.inputHelper')
    find('.inputHelper').click

    # Select Recipient
    page.send_keys('adnan ghaffar')
    page.has_text?('Adnan Ghaffar')
    page.send_keys(:enter)

    # Select Account
    page.send_keys(:tab)
    page.send_keys('3 mobiles')
    page.has_text?('3 Mobiles')
    page.send_keys(:enter)

    click_on 'Ok'

    to_field = find('.mailDrodown').text
    expect(to_field).to include('ADNAN GHAFFAR 3 MOBILES')

    page.has_selector?('div[data-value]')
    find('div[data-value]').click
    page.send_keys('ACH Authorization')

    find_all('span', text: 'ACH Authorization').last.click

    click_on 'Prepare Doc for Signing'
    sleep(8)
    page.has_selector?('iframe[title="Authoring Page"]')
    document_iframe = find('iframe[title="Authoring Page"]')
    sleep(5)
    header = find('header').text

    page.has_text?('PREPARE DOC FOR SIGNING')
    expect(header).to eq('PREPARE DOC FOR SIGNING')

    within_frame document_iframe do
      sleep(8)
      signature_field = find('.field-signature')
      document = find('img[data-src]')

      signature_field.drag_to document

      click_on 'Send'
    end
    page.current_path
  end

  def open_task_for_signature
    click_on_sidebar_edoc_menu

    page_refresh
    # click on first agreement
    page.has_css?('.tRow')
    table = find_all('.tRow').last
    page.has_css?('.tdBtn')
    first_account = table.find_all('.tdBtn').first.click

    page.has_css?('.modal-dialog')
    modal = find('.modal-dialog')
    modal.find('a[href]').click

    page.has_css?('.taskWrap')
    main_container = find('.taskWrap')
    sleep(3) # Adobe: gives invalid id otherwise!
    main_container.find('.TaskDetail__Description').find('a').click
    sleep(3)
    page_refresh
    page.has_selector?('iframe[id="signingiframe"]')
    signing_iframe = find('iframe[id="signingiframe"]')

    within_frame signing_iframe do
      term_of_use = find('.terms-of-use')
      click_on 'Continue'
    end

    within_frame signing_iframe do
      page.has_selector?('img[data-src]')
      find('.pdfFormField').click

      # modal appears verify those icons
      modal = find('.modal-dialog')

      # Verify a signature creation modal displays with options "Type", "Draw", "Image" and "Mobile"
      options = ['Type', 'Draw', 'Image', 'Mobile']
      within modal do
        icons = find_all('li.option')
        icons.each do |icon|
          expect(options).to include(icon.text)
        end
        # Type user signature "User" in the "Type your signature here" field
        page.has_css?('.signature-pad')
        pad = find('.signature-pad')
        pad.find('input').send_keys('adnan ghaffar')
        # Click on the "Apply" button
        click_on 'Apply'
      end

      # Click on "Click to Sign" button at bottom of page
      page.has_css?('.click-to-esign')
      find('.click-to-esign').click
    end

    page.has_selector?('iframe[id="signingiframe"]')
    signing_iframe = find('iframe[id="signingiframe"]')

    within_frame signing_iframe do
      # Verify "You’re all set" confirmation message displays
      page.has_selector?('h1')
      confirmation_message = find('h1').text
      expect(confirmation_message).to eq("You're all set")
    end
    # Click on "x" button to close out modal
    page.has_css?('.modal-content')
    modal = find('.modal-content')
    page.has_css?('.close')
    modal.find('.close').click

    # Go to task from notification! to get the updated page
    sleep(2)
    local_path = page.current_path
    go_to_task_from_notifications
    expect(page).to have_current_path(local_path)
    # Verify the "Review and Sign" banner no longer displays
    banner = find('.TaskDetail__Description').find('a').text
    expect(banner).to eq('Click here to review and sign ACH Authorization')
    # which implicates
    # expect(banner).not_to have_content('Review and Sign')

    # Verify "Click here to review and sign" option is now faded
    page.has_css?('.TaskDetail__Description')
    option = find('.TaskDetail__Description').find('a')
    option_text = option.text
    option_class = option['class']
    expect(option_text).to eq('Click here to review and sign ACH Authorization')
    expect(option_class).to include('disabled')

    # takes time in loading all the comments without any visable loading
    page_refresh
    # Verify update "User has signed the agreement" displays under "All Activity"
    status_first_comment = ""
    status_first_comment_div = find_all('.chatMsg--msg')[1]
    status_first_comment += status_first_comment_div.text.split("\n")[0]

    status_first_comment += ' '

    comment_iframe = status_first_comment_div.find('iframe')
    within_frame comment_iframe do
      status_first_comment += find('p').text
    end
    expect(status_first_comment).to eq('Adnan has signed the agreement')

    # This comment should be on first in "All Activities"
    # Verify update "User agreement has been signed by all signatories" with a a reference document link displays under "All Activity"
    status_second_comment = ""
    status_second_comment_div = find_all('.chatMsg--msg')[0]
    status_second_comment += status_second_comment_div.text.split("\n")[0]

    status_second_comment += ' '

    comment_iframe = status_second_comment_div.find('iframe')
    within_frame comment_iframe do
      status_second_comment += find('p').text
    end
    expect(status_second_comment).to eq('Adnan agreement has been signed by all signatories :reference document')
  end

  def mark_notifications_as_read
    within('.Sidebar') do
      find('span', text: 'NOTIFICATIONS').click
    end
    page.has_selector?('div[role="dialog"]')
    div = find('div[role="dialog"]')
    within div do
      page.has_text?('FETCHING NOTIFICATIONS...')
      mark_all_as_read = div.find('div[role="button"]', text: 'MARK ALL AS READ').click
    end
    click_on_sidebar_edoc_menu
  end

  def go_to_task_from_notifications
    page.has_css?('.MuiBadge-anchorOriginTopRight') # New notification

    notification_count = find('.MuiBadge-anchorOriginTopRight').text
    while notification_count == "0"
      notification_count = find('.MuiBadge-anchorOriginTopRight').text
      sleep(5)
    end

    page_refresh
    # click_on_sidebar_edoc_menu

    # page.has_css?('.tRow')
    # table = find_all('.tRow').last
    # page.has_css?('.tdBtn')
    # first_account = table.find_all('.tdBtn').first.click

    # page.has_css?('.modal-dialog')
    # modal = find('.modal-dialog')
    # modal.find('a[href]').click
  end

  def go_to_close_an_edoc
    click_on_sidebar_edoc_menu

    page.has_text?('+ eDoc')
    click_on '+ eDoc'

    page.has_css?('.inputHelper')
    find('.inputHelper').click

    # Select Recipient
    page.send_keys('adnan ghaffar')
    page.has_text?('Adnan Ghaffar')
    page.send_keys(:enter)

    # Select Account
    page.send_keys(:tab)
    page.send_keys('3 mobiles')
    page.has_text?('3 Mobiles')
    page.send_keys(:enter)

    click_on 'Ok'

    page.has_selector?('div[data-value]')
    find('div[data-value]').click
    page.send_keys('test title')

    file_input = find('input[data-testid="attachment__browse"]', visible: false)
    file_input.attach_file(fixtures_path.join('pdfs', 'dummy.pdf'))
    page.has_text?('Preview')

    click_on 'Prepare Doc for Signing'

    sleep(5)
    page.has_selector?('iframe[title="Authoring Page"]')
    document_iframe = find('iframe[title="Authoring Page"]')
    sleep(5)
    header = find('header').text

    page.has_text?('PREPARE DOC FOR SIGNING')
    expect(header).to eq('PREPARE DOC FOR SIGNING')

    within_frame document_iframe do
      sleep(5)
      signature_field = find('.field-signature')
      document = find('img[data-src]')
      signature_field.drag_to document
      click_on 'Send'
    end

    # After creating new edoc, redirect to edoc list
    expect(page).to have_current_path('/esign_list')


    page.has_css?('.tRow')
    table = find_all('.tRow').last
    page.has_css?('.tdBtn')
    first_account = table.find_all('.tdBtn').first.click

    page.has_css?('.modal-dialog')
    modal = find('.modal-dialog')
    modal.find('a[href]').click

    page.has_css?('.taskWrap')
    main_container = find('.taskWrap')
    sleep(3) # Adobe: gives invalid id otherwise!
    main_container.find('.TaskDetail__Description').find('a').click
    sleep(2)
    # if page.has_text?('Click here')
    #   click_on 'Click here'
    # end
    # page_refresh
    page.has_selector?('iframe[id="signingiframe"]')
    signing_iframe = find('iframe[id="signingiframe"]')

    within_frame signing_iframe do
      term_of_use = find('.terms-of-use')
      click_on 'Continue'
    end

    within_frame signing_iframe do
      page.has_selector?('img[data-src]')
      find('.pdfFormField').click

      # modal appears verify those icons
      modal = find('.modal-dialog')

      # Verify a signature creation modal displays with options "Type", "Draw", "Image" and "Mobile"
      options = ['Type', 'Draw', 'Image', 'Mobile']
      within modal do
        # Type user signature "User" in the "Type your signature here" field
        page.has_css?('.signature-pad')
        pad = find('.signature-pad')
        pad.find('input').send_keys('adnan ghaffar')
        # Click on the "Apply" button
        click_on 'Apply'
      end

      # Click on "Click to Sign" button at bottom of page
      page.has_css?('.click-to-esign')
      find('.click-to-esign').click
    end

    page_refresh
    sleep(3)

    if page.has_text?('Mark Complete')
      click_on 'Mark Complete'
      page.has_text?('You are about to mark this task as closed. Proceed?')
      click_on 'Proceed'
    else
      page_refresh
      sleep(3)
      click_on 'Mark Complete'
      page.has_text?('You are about to mark this task as closed. Proceed?')
      click_on 'Proceed'
    end
    page.current_path
  end

  def view_signing_tasks_in_order
    verify_tasks_tabs_displays
    page.has_selector?('.nav-item')
    find_all('.nav-item')[1].click
    find('.nav-link.active')
    find_all('.badge-onboard')[1]
    find_all('.nav-item')[0].click
    page.current_path
  end

  def verify_tasks_tabs_displays
    status = ['Open Tasks', 'Pending Review', 'Archived', 'Draft']
    page.has_selector?('.nav-item')
    nav_items = find_all('.nav-item').each do |nav_item|
      nav_title = nav_item.text.split(' |').first
      expect(status).to include(nav_title)
    end
  end

  def prepare_edoc_for_multiple_signatories
    # Verify "REQUEST EDOC" page displays
    page.has_selector?('header')
    header = find('header').text
    expect(header).to eq('REQUEST EDOC')

    page.has_css?('.inputHelper')
    find('.inputHelper').click

    # Select Recipient
    page.send_keys('aquifa tron')
    # Verify full contact name is suggested
    page.has_text?('Aquifa Tron Halbert')
    page.send_keys(:enter)

    # Verify contact card "Aquifa Tron Halbert" is now in the "RECIPIENT" field
    page.has_text?('Aquifa Tron Halbert')

    page.send_keys(:tab)
    page.send_keys('angus adventures')
    page.has_text?('Angus Adventures')
    page.send_keys(:enter)
    click_on 'Ok'

    sleep(5)

    page.has_css?('.inputHelper')
    find('.inputHelper').click

    # Select Recipient
    page.send_keys('angus mcfife')
    # Verify full contact name is suggested
    page.has_text?('Angus McFife')
    page.send_keys(:enter)

    # Verify contact card “Angus McFife” is now in the “RECIPIENT” field
    page.has_text?('Angus McFife')
    click_on 'Ok'

    # Verify the agreement "DUE DATE" is pre-filled as "09/04/2023"
    current_date = Date.today
    expected_date = current_date + 7 # Assuming a 7-day difference
    due_date = find('.react-datepicker-wrapper').find('input')['value']
    expect(due_date).to eq(expected_date.strftime('%m/%d/%Y'))

    page.has_selector?('div[data-value]')
    find('div[data-value]').click
    page.send_keys('ACH Authorization')

    find_all('span', text: 'ACH Authorization').last.click

    click_on 'Prepare Doc for Signing'
    sleep(5)
    page.has_selector?('iframe[title="Authoring Page"]')
    document_iframe = find('iframe[title="Authoring Page"]')
    sleep(5)
    header = find('header').text

    # Verify "PREPARE DOC FOR SIGNING" page displays powered by Adobe Sign
    page.has_text?('PREPARE DOC FOR SIGNING')
    expect(header).to eq('PREPARE DOC FOR SIGNING')

    within_frame document_iframe do
      sleep(5)
      signature_field = find('.field-signature')
      document = find('img[data-src]')

      signature_field.drag_to document
    end

    within_frame document_iframe do
      page.has_css?('.role-link')
      find('.role-link').click
      page.has_selector?('li.roleOption')
      find_all('li.roleOption')[2].click
    end

    within_frame document_iframe do
      sleep(5)
      signature_field = find('.field-signature')
      document = find('img[data-src]')

      signature_field.drag_to document
      click_on 'Send'
    end

    # Verify a Liscio loading animation displays
    wait_for_loading_animation

    # Verify user is returned to EDOCS list level
    expect(page).to have_current_path('/esign_list')

    # Verify agreement "ACH Authorization" is listed at top with two contacts under "SIGNERS" field
    page.has_css?('.tRow')
    table = find_all('.tRow').last
    page.has_css?('.tdBtn')
    first_account = table.find_all('.tdBtn').first.click

    page.has_selector?('form')
    form = find('form').text

    page.has_css?('.icon-close2')
    find('.icon-close2').click

    page.current_path
  end

  def ensure_edoc_are_not_struck
    wait_for_selector('.nav-item')
    nav_items = find_all('.nav-item')
    nav_items.each do |nav_item|
      nav_item.click if nav_item.text.include?('Draft')
    end

    sleep 2
    wait_for_selector('.tRow--body')
    table_body = find('.tRow--body')
    first_record = table_body.find_all('.row').first
    first_record.click

    sleep 2
    page_refresh

    iframe = find('iframe[title="Authoring Page"]')
    within_frame iframe do
      page.has_selector?('.authoring-right-pane')
      menu = find('.authoring-right-pane').text
      expect(menu).to include('RECIPIENTS')
      expect(menu).to include('Signature Fields')
      expect(menu).to include('Signer Info Fields')
      expect(menu).to include('Data Fields')
      expect(menu).to include('More Fields')
    end
    page.current_path
  end

  def signer_with_one_signing_field
    # Verify a REQUEST EDOC page displays
    page.has_text?('REQUEST EDOC')

    page.has_css?('.inputHelper')
    find('.inputHelper').click

    # Select Recipient
    page.send_keys('angus mcFife')
    page.has_text?('Angus McFife')
    page.send_keys(:enter)

    # Select Account
    page.send_keys(:tab)
    page.send_keys('angus')
    page.has_text?('Angus Adventures')
    page.send_keys(:enter)

    click_on 'Ok'

    to_field = find('.mailDrodown').text
    expect(to_field).to include('ANGUS MCFIFE ANGUS ADVENTURES')

    # Click on the AGREEMENT TITLE field
    page.has_selector?('div[data-value]')
    find('div[data-value]').click
    page.send_keys('ACH Authorization')

    find_all('span', text: 'ACH Authorization').last.click

    # Click on the “Templates” hyperlink in the ATTACHMENTS field
    find('.fileContainer.text-capitalize a', text: 'Templates').click
    find_all('.tdBtn').first.click

    # Click on “Prepare Doc for Signing” button
    click_on 'Prepare Doc for Signing'
    sleep(5)
    page.has_selector?('iframe[title="Authoring Page"]')
    document_iframe = find('iframe[title="Authoring Page"]')
    sleep(5)
    header = find('header').text

    page.has_text?('PREPARE DOC FOR SIGNING')
    expect(header).to eq('PREPARE DOC FOR SIGNING')


    within_frame document_iframe do
      sleep(5)
      signature_field = find('.field-signature')

      document = find_all('img[data-src]')[1]
      signature_field.drag_to document

    end

    # click_on 'Prepare Doc for Signing'
    page.current_path
  end

  def confirm_signed_agreement
    mark_notifications_as_read
    page.has_text?('+ eDoc')
    click_on '+ eDoc'

    page.has_css?('.inputHelper')
    find('.inputHelper').click

    # Select Recipient
    page.send_keys('adnan ghaffar')
    page.has_text?('Adnan Ghaffar')
    page.send_keys(:enter)

    # Select Account
    page.send_keys(:tab)
    page.send_keys('3 mobiles')
    page.has_text?('3 Mobiles')
    page.send_keys(:enter)

    click_on 'Ok'

    to_field = find('.mailDrodown').text
    expect(to_field).to include('ADNAN GHAFFAR 3 MOBILES')

    page.has_selector?('div[data-value]')
    find('div[data-value]').click
    page.send_keys('ACH Authorization')

    find_all('span', text: 'ACH Authorization').last.click

    click_on 'Prepare Doc for Signing'
    sleep(5)
    page.has_selector?('iframe[title="Authoring Page"]')
    document_iframe = find('iframe[title="Authoring Page"]')
    sleep(5)
    header = find('header').text

    page.has_text?('PREPARE DOC FOR SIGNING')
    expect(header).to eq('PREPARE DOC FOR SIGNING')

    within_frame document_iframe do
      sleep(5)
      signature_field = find('.field-signature')
      document = find('img[data-src]')

      signature_field.drag_to document

      click_on 'Send'

    end
    within('.Sidebar') do
      click_on 'HOME'
    end
    sleep(3)
    find('div[data-testid="row-0"]').click
    page.has_text?('Click here')
    click_on 'Click here'
    # wait for the iframe
    wait_for_loading_animation
    page.has_text?('Loading')
    page.has_selector?('iframe[id="signingiframe"]')
    signing_iframe = find('iframe[id="signingiframe"]')

    if signing_iframe.text == ""
      page_refresh
      sleep(5) # Invalid Adobe ID, bypass this by waiting
      page.has_text?('Click here')
      click_on 'Click here'
      page.has_selector?('iframe[id="signingiframe"]')
      signing_iframe = find('iframe[id="signingiframe"]')
    end

    within_frame signing_iframe do
      term_of_use = find('.terms-of-use')
      click_on 'Continue'
    end
    page.current_path
  end

  def should_direct_to_authoring_page
    # Click on EDOCS from the left-hand navigation bar
    go_to_edoc

    # Verify page with tabs "In Progress", "Completed", "Cancelled", and "Draft" with relevant counts displays
    ['In Progress', 'Completed', 'Cancelled', 'Draft'].each do |tab|
      wait_for_text(page, tab)
    end

    # Click on the "+ eDoc" button in the top right corner of the screen
    click_on '+ eDoc'

    # Click on the "Drop files to attach, Liscio Vault, or Templates or Browse or OneDrive" button under the ATTACHMENTS field
    vault_selector = 'a[data-testid="attachment__liscio_vault"]'
    wait_for_selector(vault_selector)
    find(vault_selector).click

    modal = find('.modal-body')
    header = modal.find('header').text
    expect(header).to eq('LISCIO VAULT')
    page.current_path
  end

  def click_on_edoc_tabs
    click_on "Completed"

    click_on "Cancelled"

    click_on "Draft"

    click_on "In Progress"
  end

  def filter_by_requestor
    click_on_edoc_tabs

    click_on "REQUESTOR"
    find_all('.dropdown-item')[1].click

    click_on "Completed"
    sleep 2

    click_on "Cancelled"

    click_on "Draft"
    page.current_path
  end

  def filter_by_account
    click_on_edoc_tabs

    click_on "ACCOUNT"
    sleep 3
    find_all('.dropdown-item').first.click

    click_on_edoc_tabs
    page.current_path
  end

  def filter_by_signer
    click_on_edoc_tabs

    click_on "SIGNERS"
    sleep 3
    find_all('.dropdown-item').first.click

    click_on_edoc_tabs
    page.current_path
  end

  def filter_by_search_bar
    click_on_edoc_tabs

    find_by_id('edoc-search').click
    page.send_keys("ACH")
    find_all('.row')[1].click

    page.current_path
  end

  def remove_or_combine_filters
    click_on_edoc_tabs

    page.current_path
  end

  def send_an_edoc
    go_to_edoc

    draft_selector = 'button[data-testid="undefined__draft"]'
    wait_for_selector(draft_selector)
    find(draft_selector).click

    wait_for_selector('.tdBtn.row')
    find_all('.tdBtn.row').first.click

    sleep 2
    page_refresh

    # Click on “Prepare Doc for Signing” button
    page.has_selector?('iframe[title="Authoring Page"]')
    sleep(5)
    document_iframe = find('iframe[title="Authoring Page"]')
    header = find('header').text

    page.has_text?('PREPARE DOC FOR SIGNING')
    expect(header).to eq('PREPARE DOC FOR SIGNING')

    sleep 5
    within_frame document_iframe do
      page.has_text?('A Note About This Document')
      page.send_keys(:escape)
      sleep 1
    end

    sleep 1
    within_frame document_iframe do
      sleep(5)
      signature_field = find('.field-signature')

      document = find_all('img[data-src]')[1]
      signature_field.drag_to document
      sleep 1
      click_on 'Send'
    end

    page.current_path
  end

  def create_template_from_edocs_section
    # Log into Liscio Firm Admin account
    # From Home Dashboard, go to eDocs tab
    go_to_edoc

    # Click on Template Library button
    wait_for_text(page, 'Template Library')
    find('span', text: 'Template Library').click
    expect(page).to have_current_path('/esign_templates')

    # Click on + Add Template to Library button
    wait_for_text(page, '+ Add Template to Library')
    find('a', text: '+ Add Template to Library').click
    expect(page).to have_current_path('/esign_templates/new')

    # Enter Unique Template Name
    time_stamp = Time.now.to_i
    template_name = "template_#{time_stamp}"
    fill_in 'template_name', with: template_name

    # Click on Browse link under Add Files section
    # Select a PDF file to upload and attach
    file_input = find('input[data-testid="attachment__browse"]', visible: false)
    file_input.attach_file(fixtures_path.join('pdfs', 'dummy.pdf'))
    wait_for_selector('.previewFile')
    wait_for_text(page, 'Preview')

    # Click on Preview and Add Fields button
    click_on 'Preview and Add Fields'
    wait_for_text(page, 'Added template successfully')
    sleep(7)

    # Edit the PDF form on your preference
    page.has_selector?('iframe[title="Authoring Page"]')
    iframe = find('iframe[title="Authoring Page"]')
    within_frame iframe do
      page.has_selector?('.authoring-right-pane')
      menu = find('.authoring-right-pane').text
      expect(menu).to include('Signature Fields')
      signature_field = find('.field-signature')
      document = find('img[data-src]')
      signature_field.drag_to document

      # Click on Save button
      click_on 'Save'
    end

    expect(page).to have_current_path('/esign_templates')
    wait_for_text(page, template_name)
    page.current_path
  end

  def send_edoc_using_a_template
    # Log into Liscio Firm Admin account
    # From Home Dashboard, go to eDocs tab
    go_to_edoc

    # Click on +eDoc button
    wait_for_text(page, '+ eDoc')
    find('span', text: '+ eDoc').click
    expect(page).to have_current_path('/new_esign')

    # Select a Recipient by clicking on TO field
    page.has_css?('.inputHelper')
    find('.inputHelper').click

    # Select a Recipient and Account then click Ok button
    # Select Recipient
    page.send_keys('adnan ghaffar')
    page.has_text?('Adnan Ghaffar')
    page.send_keys(:enter)

    # Select Account
    page.send_keys(:tab)
    page.send_keys('3 mobiles')
    page.has_text?('3 Mobiles')
    page.send_keys(:enter)

    click_on 'Ok'

    to_field = find('.mailDrodown').text
    expect(to_field).to include('ADNAN GHAFFAR 3 MOBILES')

    # Type 'Test' in the Agreement Title field
    page.has_selector?('div[data-value]')
    find('div[data-value]').click
    page.send_keys('Test')
    page.send_keys(:tab)

    # Type 'Test' in Description field
    description_iframe = find('iframe[id^="tiny-react_"]')
    within_frame(description_iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('Test')
      page.send_keys(:tab)
    end

    # Click on the Templates link under Attachments section
    wait_for_selector('a[data-testid="attachment_templates"]')
    find('a[data-testid="attachment_templates"]').click

    # Select an existing template from the list
    template_modal = find('.modal-dialog')
    within template_modal do
      find_all('.row.tdBtn').first.click
    end

    # Click on Prepare Doc for Signing button
    click_on 'Prepare Doc for Signing'
    wait_for_loading_animation

    expect(page).not_to have_current_path('/esign_templates')

    heading = find('h1.pageHeading').text
    page.has_text?('PREPARE DOC FOR SIGNING')
    sleep 3

    expect(heading).to eq('PREPARE DOC FOR SIGNING')
    page.has_selector?('iframe[title="Authoring Page"]')
    document_iframe = find('iframe[title="Authoring Page"]')
    sleep 5

    within_frame document_iframe do
      sleep 5
      page.send_keys(:escape)
    end

    within_frame document_iframe do
      # Click on Send button
      click_on 'Send'
    end

    within_frame document_iframe do
      modal = find('.modal-dialog ')
      within modal do
        # Click on Save button
        click_on 'Send'
      end
    end

    expect(page).to have_current_path('/esign_list')
    page.current_path
  end

  def send_edoc_using_multiple_templates
    # Log into Liscio Firm Admin account
    # From Home Dashboard, go to eDocs tab
    go_to_edoc

    # Click on +eDoc button
    wait_for_text(page, '+ eDoc')
    find('span', text: '+ eDoc').click
    expect(page).to have_current_path('/new_esign')

    # Select a Recipient by clicking on TO field
    page.has_css?('.inputHelper')
    find('.inputHelper').click

    # Select a Recipient and Account then click Ok button
    # Select Recipient
    page.send_keys('adnan ghaffar')
    page.has_text?('Adnan Ghaffar')
    page.send_keys(:enter)

    # Select Account
    page.send_keys(:tab)
    page.send_keys('3 mobiles')
    page.has_text?('3 Mobiles')
    page.send_keys(:enter)

    click_on 'Ok'

    to_field = find('.mailDrodown').text
    expect(to_field).to include('ADNAN GHAFFAR 3 MOBILES')

    # Type 'Test' in the Agreement Title field
    page.has_selector?('div[data-value]')
    find('div[data-value]').click
    page.send_keys('Test')
    page.send_keys(:tab)

    # Type 'Test' in Description field
    description_iframe = find('iframe[id^="tiny-react_"]')
    within_frame(description_iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('Test')
      page.send_keys(:tab)
    end

    # Click on the Templates link under Attachments section
    wait_for_selector('a[data-testid="attachment_templates"]')
    find('a[data-testid="attachment_templates"]').click

    # Select an existing template from the list
    template_modal = find('.modal-dialog')
    within template_modal do
      find_all('.row.tdBtn').first.click
    end

    find('a[data-testid="attachment_templates"]').click

    # Select another existing template from the list
    template_modal = find('.modal-dialog')
    within template_modal do
      find_all('.row.tdBtn')[1].click
    end

    # Click on Prepare Doc for Signing button
    click_on 'Prepare Doc for Signing'
    wait_for_loading_animation

    expect(page).not_to have_current_path('/esign_templates')

    heading = find('h1.pageHeading').text
    page.has_text?('PREPARE DOC FOR SIGNING')
    sleep 3

    expect(heading).to eq('PREPARE DOC FOR SIGNING')
    page.has_selector?('iframe[title="Authoring Page"]')
    document_iframe = find('iframe[title="Authoring Page"]')
    sleep 5

    within_frame document_iframe do
      sleep 5
      page.send_keys(:escape)
    end

    within_frame document_iframe do
      # Click on Send button
      click_on 'Send'
    end

    within_frame document_iframe do
      modal = find('.modal-dialog ')
      within modal do
        # Click on Save button
        click_on 'Send'
      end
    end

    expect(page).to have_current_path('/esign_list')
    page.current_path
  end

  def using_text_formatting_in_creating_edoc
    # Log into Liscio Firm Admin account
    # From Home Dashboard, go to eDocs tab
    go_to_edoc

    # Click on +eDoc button
    wait_for_text(page, '+ eDoc')
    find('span', text: '+ eDoc').click
    expect(page).to have_current_path('/new_esign')

    # Select a Recipient by clicking on TO field
    page.has_css?('.inputHelper')
    find('.inputHelper').click

    # Select a Recipient and Account then click Ok button
    # Select Recipient
    page.send_keys('adnan ghaffar')
    page.has_text?('Adnan Ghaffar')
    page.send_keys(:enter)

    # Select Account
    page.send_keys(:tab)
    page.send_keys('3 mobiles')
    page.has_text?('3 Mobiles')
    page.send_keys(:enter)

    click_on 'Ok'

    to_field = find('.mailDrodown').text
    expect(to_field).to include('ADNAN GHAFFAR 3 MOBILES')

    # Type 'Test' in the Agreement Title field
    page.has_selector?('div[data-value]')
    find('div[data-value]').click

    edoc_template_title = insert_formated_data_iframe

    sleep 5
    expect(page).not_to have_current_path('/esign_templates')

    heading = find('h1.pageHeading').text
    page.has_text?('PREPARE DOC FOR SIGNING')
    sleep 3

    expect(heading).to eq('PREPARE DOC FOR SIGNING')
    page.has_selector?('iframe[title="Authoring Page"]')
    document_iframe = find('iframe[title="Authoring Page"]')
    sleep 5

    within_frame document_iframe do
      sleep 5
      page.send_keys(:escape)
    end

    within_frame document_iframe do
      # Click on Send button
      click_on 'Send'
    end

    within_frame document_iframe do
      modal = find('.modal-dialog ')
      within modal do
        # Click on Save button
        click_on 'Send'
      end
    end
    sleep 5

    # Verify edoc created
    expect(page).to have_current_path('/esign_list')
    fill_in 'edoc-search', with: edoc_template_title
    sleep 2
    wait_for_loading_animation

    # Verify Title
    created_record = find_all('.tdBtn.row').first
    expect(created_record.text).to include(edoc_template_title)
    created_record.click
    expect(page).to have_current_path('/esign_list')

    # Verify Description
    wait_for_selector('iframe[id^="tiny-react_"]')
    description_iframe = find('iframe[id^="tiny-react_"]')
    within_frame(description_iframe) do
      page.has_selector?('#tinymce')
      description = find_by_id('tinymce')
      description_body = description.text
      expect(description_body).to include('use bulleted list')
      expect(description_body).to include('use bold list')

      styled_text = description.find_all('div').last.find('strong').text
      expect(styled_text).to include('use bold list')
    end
    page.current_path
  end

  def attach_templates_and_attachments
    # Log into Liscio Firm Admin account
    # From Home Dashboard, go to eDocs tab
    go_to_edoc

    # Click on +eDoc button
    wait_for_text(page, '+ eDoc')
    find('span', text: '+ eDoc').click
    expect(page).to have_current_path('/new_esign')

    # Select a Recipient by clicking on TO field
    page.has_css?('.inputHelper')
    find('.inputHelper').click

    # Select a Recipient and Account then click Ok button
    # Select Recipient
    page.send_keys('adnan ghaffar')
    page.has_text?('Adnan Ghaffar')
    page.send_keys(:enter)

    # Select Account
    page.send_keys(:tab)
    page.send_keys('3 mobiles')
    page.has_text?('3 Mobiles')
    page.send_keys(:enter)

    click_on 'Ok'

    to_field = find('.mailDrodown').text
    expect(to_field).to include('ADNAN GHAFFAR 3 MOBILES')

    # Type 'Test' in the Agreement Title field
    page.has_selector?('div[data-value]')
    find('div[data-value]').click

    # Enter Unique eDoc Agreement Title
    time_stamp = Time.now.to_i
    edoc_template_title = "edoc_#{time_stamp}"
    page.send_keys(edoc_template_title)
    page.send_keys(:tab)

    # Type 'Test' in Description field
    description_iframe = find('iframe[id^="tiny-react_"]')
    within_frame(description_iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('a quick brown fox jumps over the lazy dog')
      page.send_keys(:tab)
    end

    # Click on the Templates link under Attachments section
    wait_for_selector('a[data-testid="attachment_templates"]')
    find('a[data-testid="attachment_templates"]').click

    # Select an existing template from the list
    template_modal = find('.modal-dialog')

    within template_modal do
      find_all('.row.tdBtn').first.click
    end

    # Click on Liscio Vault link
    wait_for_selector('a[data-testid="attachment__liscio_vault"]')
    find('a[data-testid="attachment__liscio_vault"]').click

    # Select a file to attach and click Attach files button
    vault_modal = find('.modal-dialog')
    within vault_modal do
      find_all('.checkbox')[1].find('label').click
      click_on 'Attach Files'
    end

    # Click on Prepare Doc for Signing button
    click_on 'Prepare Doc for Signing'
    wait_for_loading_animation

    sleep 5
    expect(page).not_to have_current_path('/esign_templates')

    heading = find('h1.pageHeading').text
    page.has_text?('PREPARE DOC FOR SIGNING')
    sleep 5

    expect(heading).to eq('PREPARE DOC FOR SIGNING')
    page.has_selector?('iframe[title="Authoring Page"]', wait: 35)
    document_iframe = find('iframe[title="Authoring Page"]', wait: 35)
    sleep 5

    within_frame document_iframe do
      sleep 5
      page.send_keys(:escape)
    end

    within_frame document_iframe do
      # Click on Send button
      click_on 'Send'
    end

    within_frame document_iframe do
      modal = find('.modal-dialog ')
      within modal do
        # Click on Save button
        click_on 'Send'
      end
    end

    page.current_path
  end

  def should_not_view_edoc_updloaded_by_restricted_account
    # Log in with an active Liscio Firm Admin account
    login_to_app

    # From Home Dashboard, go to Accounts from left nav menu
    account_selector = 'div[data-testid="sidebar__accounts"]'
    wait_for_selector(account_selector)
    find(account_selector).click

    # Search for ABC Testing Inc. and select it
    unless page.has_selector?('#account-search')
      page_refresh
      wait_for_loading_animation
    end

    search_box = find_by_id('account-search')
    # Begin typing restricted account name "Beatles"
    'abc testing'.chars.each { |ch| search_box.send_keys(ch) }

    # Verify full account name displays
    wait_for_text(page, 'ABC Testing Inc.')
    sleep 5

    table = find('.tab-content')
    table.first('a').click
    wait_for_text(page, 'Timeline')
    uploaded_by_restricted_account
  end

  def jump_to_task_from_edoc
    # Log in with active Liscio Firm Admin account
    login_to_app

    # From Home Dashboard, go to Edocs tab from left nav menu
    edoc_selector = 'div[data-testid="sidebar__edocs"]'
    wait_for_selector(edoc_selector)
    find(edoc_selector).click

    # Open an active eDocument from the list
    wait_for_selector('.row.tdBtn')
    find_all('.row.tdBtn').first.click

    # On the right hand side of the document preview, look document details
    # Look for Signer field
    # Beside Signer field, click on the Task link
    wait_for_selector('.modal')
    modal = find('.modal')
    modal.find('a').click

    # User should be redirected to the actual task where the edoc is sent into or attached
    expect(page.current_path).to include('/task/detail')
    page.current_path
  end

  def receive_and_see_signed_edoc
    login_to_app

    # Create a sign eDoc with a random title
    # Send sent a message to a recipient with a signed eDoc attached
    time_stamp = Time.now.to_i
    title = "Title_#{time_stamp}"
    template = send_edoc_with_template(title)

    # As the recipient, login and go to messages
    login_page.logout
    login_to_app_as_automation_qa

    # Click to view the message
    edoc_selector = 'div[data-testid="sidebar__edocs"]'
    wait_for_selector(edoc_selector)
    find(edoc_selector).click

    wait_for_text(page, title)
    find('span', text: title).click

    # Verify the subject title and random message body displays
    # Verify eDoc attachment is visible
    page.current_path
  end

  def allow_client_to_view_edoc_with_formatting
    # Log into Liscio Firm Admin account
    # From Home Dashboard, go to eDocs tab
    go_to_edoc

    # Click on +eDoc button
    wait_for_text(page, '+ eDoc')
    find('span', text: '+ eDoc').click
    expect(page).to have_current_path('/new_esign')

    # Select a Recipient by clicking on TO field
    page.has_css?('.inputHelper')
    find('.inputHelper').click

    # Select a Recipient and Account then click Ok button
    # Select Recipient
    page.send_keys('aquifa halbert')
    page.has_text?('Aquifa Halbert')
    page.send_keys(:enter)

    # Select Account
    page.send_keys(:tab)
    page.send_keys('abc testing inc')
    page.has_text?('ABC Testing Inc.')
    page.send_keys(:enter)

    click_on 'Ok'

    # Type 'Test' in the Agreement Title field
    page.has_selector?('div[data-value]')
    find('div[data-value]').click

    edoc_template_title = insert_formated_data_iframe

    sleep 5
    expect(page).not_to have_current_path('/esign_templates')

    heading = find('h1.pageHeading').text
    page.has_text?('PREPARE DOC FOR SIGNING')
    sleep 3

    expect(heading).to eq('PREPARE DOC FOR SIGNING')
    page.has_selector?('iframe[title="Authoring Page"]')
    sleep 5
    document_iframe = find('iframe[title="Authoring Page"]')

    within_frame document_iframe do
      sleep 5
      page.send_keys(:escape)
      sleep 1
    end

    within_frame document_iframe do
      # Click on Send button
      click_on 'Send'
    end

    within_frame document_iframe do
      modal = find('.modal-dialog ')
      within modal do
        # Click on Save button
        click_on 'Send'
      end
    end
    sleep 5

    # Verify edoc created
    login_page.logout
    login_to_app_as_client

    # From Home Dashboard, go to Task tab from left nav menu
    task_selector = 'div[data-testid="sidebar__tasks"]'
    wait_for_selector(task_selector)
    find(task_selector).click

    expect(page).to have_current_path('/all_tasks')
    wait_for_text(page, "Please sign #{edoc_template_title}")
    find('strong', text: "Please sign #{edoc_template_title}").click

    wait_for_text(page, edoc_template_title)

    # Verify Description
    wait_for_selector('iframe[id^="tiny-react_"]')
    description_iframe = find_all('iframe[id^="tiny-react_"]').first
    within_frame(description_iframe) do
      all_divs = find_all('div')
      listed_text = all_divs[0].text
      bold_text = all_divs[1].find('strong').text

      expect(listed_text).to include('use bulleted list')
      expect(bold_text).to include('use bold list')
    end
    page.current_path
  end

  def confirm_no_duplicate
    click_on_sidebar_edoc_menu

    page.current_path
  end

  def create_edoc_from_dashboard_add_new
    # Click on +ADD NEW from the left side nav of the dashboard screen
    # Verify a drop-down menu displays
    # Click on the "eDoc" option
    # Verify the EDOCS tab on the left side nav is now highlighted
    go_to_edoc_from_add_new

    # Click on the "TO *" field
    page.has_css?('.inputHelper')
    find('.inputHelper').click

    # Verify a drop-down modal with "RECIPIENT" and "ACCOUNT" fields display
    # Click on the "Select a Recipient" box
    # Begin typing recipient name "Adnan Ghaffar"
    page.send_keys('adnan ghaffar')

    # Verify recipient full name is suggested
    page.has_text?('Adnan Ghaffar')

    # Click on recipient full name
    page.send_keys(:enter)

    # Select Account
    page.send_keys(:tab)
    page.send_keys('3 mobiles')
    page.has_text?('3 Mobiles')
    page.send_keys(:enter)

    # Click on the "OK" button
    click_on 'Ok'

    # Verify "Adnan Ghaffar * 3 Mobiles" chip is displayed in "TO *" field
    to_field = find('.mailDrodown').text
    expect(to_field).to include('ADNAN GHAFFAR 3 MOBILES')

    # Click on the "AGREEMENT TITLE" field
    page.has_selector?('div[data-value]')
    find('div[data-value]').click
    page.send_keys('ACH Authorization')

    # Click on template "ACH Authorization"
    find_all('span', text: 'ACH Authorization').last.click

    prepare_edoc_to_send
    page.current_path
  end

  private

  def prepare_edoc_to_send
    # Click on the "Prepare Doc for Signing" button
    click_on 'Prepare Doc for Signing'
    sleep(8)
    page.has_selector?('iframe[title="Authoring Page"]')
    document_iframe = find('iframe[title="Authoring Page"]')
    sleep(5)
    header = find('header').text

    # Click on the "Prepare Doc for Signing" button
    page.has_text?('PREPARE DOC FOR SIGNING')
    expect(header).to eq('PREPARE DOC FOR SIGNING')

    # Click on the "Signature Fields" tab Click and drag the document
    within_frame document_iframe do
      sleep(8)
      signature_field = find('.field-signature')
      document = find('img[data-src]')
      signature_field.drag_to document
      click_on 'Send'
    end
  end

  def insert_formated_data_iframe
    # Enter Unique eDoc Agreement Title
    time_stamp = Time.now.to_i
    edoc_template_title = "edoc_#{time_stamp}"
    page.send_keys(edoc_template_title)
    page.send_keys(:tab)

    # Type 'Test' in Description field
    description_iframe = find('iframe[id^="tiny-react_"]')
    within_frame(description_iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('use bulleted list')
      page.send_keys(:enter)
      page.send_keys(:control, 'b')
      page.send_keys('use bold list')
      page.send_keys(:tab)
    end

    # Click on the Templates link under Attachments section
    wait_for_selector('a[data-testid="attachment_templates"]')
    find('a[data-testid="attachment_templates"]').click

    # Select an existing template from the list
    template_modal = find('.modal-dialog')

    within template_modal do
      find_all('.row.tdBtn').first.click
    end

    # Click on Prepare Doc for Signing button
    click_on 'Prepare Doc for Signing'
    wait_for_loading_animation
    edoc_template_title
  end

  def uploaded_by_restricted_account
    # Go to Details tab
    find('.nav-link', text: 'Details').click

    # Click on more options (...)
    wait_for_selector('.icon-more')
    find_all('.icon-more').first.click

    # Click Edit Account
    click_on 'Edit Account'

    # Check the box for Restricted account?
    label = find('label[for="restrictaccount"]')
    container_class = label.find('i')[:class]
    expect(container_class).to eq('checkmark')

    # Click on Update Account button
    find_all('button', text: 'Update Account').first.click

    # Log out from Firm Admin account
    sleep 3
    login_page.logout

    # Log in with active Liscio Employee account
    login_to_app_as_active_liscio_employee

    # From Home Dashboard, go to eDocs from left nav menu
    edoc_selector = 'div[data-testid="sidebar__edocs"]'
    wait_for_selector(edoc_selector)
    find(edoc_selector).click

    # Click on Account field in filters
    find('button', text: 'ACCOUNT').click

    # Search for ABC Testing Inc.
    account_search_filter = find_by_id('ACCOUNT')
    'abc testing in'.chars.each { |ch| account_search_filter.send_keys(ch) }

    # Employee account user should not be able to see ABC Testing Inc. in the dropdown list of Account field in filters
    expect(page).not_to have_content('ABC Testing Inc.')
    page.current_path
  end

  def send_edoc_with_template(title)
    edoc_selector = 'div[data-testid="sidebar__edocs"]'
    wait_for_selector(edoc_selector)
    find(edoc_selector).click

    wait_for_text(page, '+ eDoc')
    find('span', text: '+ eDoc').click
    expect(page).to have_current_path('/new_esign')

    page.has_css?('.inputHelper')
    find('.inputHelper').click

    # Select Recipient
    page.send_keys('automation qa')
    wait_for_text(page, 'Automation QA')
    page.send_keys(:enter)

    # Select Account
    page.send_keys(:tab)
    page.send_keys('abc testing inc')
    wait_for_text(page, 'ABC Testing Inc.')
    page.send_keys(:enter)

    click_on 'Ok'

    wait_for_selector('div[data-value]')
    find('div[data-value]').click

    title.chars.each { |ch| page.send_keys(ch) }

    page.has_selector?('a', text: 'Templates')
    find('a', text: 'Templates').click

    page.has_selector?('.modal-dialog')
    modal = find('.modal-dialog')

    wait_for_selector('.row.tdBtn')
    template = modal.find_all('.row.tdBtn').first
    template_title = template.text.split("\n").first

    template.click

    click_on 'Prepare Doc for Signing'
    sleep(3)

    wait_for_selector('iframe[title="Authoring Page"]')
    document_iframe = find('iframe[title="Authoring Page"]')
    sleep(8)
    header = find('header').text

    page.has_text?('PREPARE DOC FOR SIGNING')
    expect(header).to eq('PREPARE DOC FOR SIGNING')

    sleep(8)
    within_frame document_iframe do
      page.send_keys(:escape)
    end

    within_frame document_iframe do
      wait_for_selector('.field-signature')
      signature_field = find('.field-signature')
      document = find_all('img[data-src]').first

      signature_field.drag_to document

      click_on 'Send'
    end
    template_title
  end

  def login_to_app_as_client
    login_page.ensure_login_page_rendered

    login_page.sign_in_with_valid_client
    login_page.ensure_correct_credientials
    login_page
  end

  def login_to_app_as_automation_qa
    login_page.visit_login_page

    login_page.sign_in_with_automation_qa
    login_page.ensure_correct_credientials
    login_page
  end

  def login_to_app_as_active_liscio_employee
    login_page.ensure_login_page_rendered

    login_page.sign_in_with_valid_employee
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
