require_relative './base_page'
require_relative './login_page'

class TaskPage < BasePage
  def go_to_tasks
    login_to_app
    within('.Sidebar') do
      click_on 'TASKS'
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

  def go_to_task_to_do
    login_to_app
    within('.Sidebar') do
      find('span', text: 'ADD NEW').click
    end
    page.has_selector?('div[role="menuitem"]')
    find('div[role="menuitem"]', text: 'Task').click
    find('div[role="menuitem"]', text: 'To Do').click
    sleep(2)
    current_path = page.current_url
    visit current_path
  end

  def go_to_get_a_signature
    login_to_app
    within('.Sidebar') do
      find('span', text: 'ADD NEW').click
    end
    sleep(2)
    page.has_selector?('div[role="menuitem"]')
    find('div[role="menuitem"]', text: 'Task').click
    find('div[role="menuitem"]', text: 'Get a Signature').click
    wait_for_loading_animation
    page_refresh
    sleep(2)
  end

  def go_to_home
    login_to_app
    within('.Sidebar') do
      click_on 'HOME'
    end
  end

  def verify_engagement_letter
    click_on 'Pending Review'
    find('div[data-testid="row-0"]').click
    page.current_path
  end

  def create_new_todo_task
    sleep(3)
    page_refresh
    page.has_text?('+ Task')
    click_link '+ Task'

    page.has_selector?('a[href="/task/new"]')
    task_div = find('.task-type-select').click
    task_div.find_all('div', text: 'To Do').last.click

    page.has_selector?('.labelValue')
    employee = find_all('div.labelValue').first.click
    sleep(2)
    page.send_keys(:enter)

    page.has_selector?('div[data-value]')
    find_all('div[data-value]').last.click
    page.send_keys('RQ-1 Please provide the following info')
    page.send_keys(:enter)

    click_on 'Create Task'
  end

  def create_new_todo_task_from_home
    login_to_app
    within('.Sidebar') do
      click_on 'HOME'
    end
    create_new_todo_task
  end

  def create_new_todo_task_from_account
    login_to_app
    within('.Sidebar') do
      click_on 'ACCOUNTS'
    end

    table = find('.tableWrap')
    table.find_all('.tdBtn').first.click

    heading = find('.breadcrumb')
    heading.has_text?('ALL ACCOUNTS')
    sleep(3)
    page_refresh
    page.has_text?('In Focus')
    click_on 'In Focus'

    page.has_selector?('.inFocusBtn')
    find_all('.inFocusBtn').first.click

    in_focus_path = page.current_path

    fill_modal
    in_focus_path
  end

  def create_new_todo_task_from_contact
    login_to_app
    within('.Sidebar') do
      click_on 'CONTACTS'
    end
    sleep(2)
    page_refresh

    page.has_selector?('.tableWrap')
    table = find('.tableWrap')
    table.find_all('.tdBtn')[5].click

    sleep(3)
    heading = find('.breadcrumb')
    heading.has_text?('ALL CONTACTS')
    sleep(3)
    page_refresh
    page.has_text?('Task')
    click_on 'Task'

    contacts_path = page.current_path

    page.has_text?('+ Task')
    click_button '+ Task'

    page.has_selector?('a[href="/task/new"]')
    task_div = find('.task-type-select').click
    task_div.find_all('div', text: 'To Do').last.click

    page.has_selector?('.labelValue')
    employee = find_all('div.labelValue').first.click
    sleep(2)
    page.send_keys(:enter)

    page.has_selector?('div[data-value]')
    find_all('div[data-value]').last.click
    page.send_keys('RQ-1 Please provide the following info')
    page.send_keys(:enter)

    click_on 'Create Task'
    contacts_path
  end

  def fill_modal
    page.has_selector?('.modal-dialog')
    modal = find('.modal-dialog')
    within modal do
      task_div = find('.task-type-select').click
      task_div.find_all('div', text: 'To Do').last.click

      page.has_selector?('.labelValue')
      employee = find_all('div.labelValue').first.click
      sleep(2)
      page.send_keys(:enter)

      page.has_selector?('div[data-value]')
      find_all('div[data-value]').last.click
      page.send_keys('RQ-1 Please provide the following info')
      page.send_keys(:enter)
      click_on 'Create Task'
    end
  end

  def ensure_box_border_is_visible
    page.has_text?('TYPE')
    click_button 'TYPE'
    find('.checkbox', text: 'eDoc').click

    page.has_selector?('.tableWrap')
    table = find_all('.tableWrap').last
    table.find_all('.row')[1].click

    page.has_selector?('a[data-toggle="dropdown"]')
    find('a[data-toggle="dropdown"]').click
    click_on 'Edit Task'

    task_detail_path = page.current_path
    # verify_description_has_border
    task_detail_path
  end

  def verify_description_has_border
    page.has_selector?('#taskTitle')
    sleep(3)
    page.has_selector?('div[role="application"]')
    border = find('div[role="application"]').native.style('border')
    expect(border).to eq('0px none rgb(34, 47, 62)')
    # Border has value of 0px none which should be solid
  end

  def create_task_type_todo
    page.has_text?('ADD NEW')
    page.find_all('div', text: 'ADD NEW').last.click

    page.has_selector?('div[role="menuitem"]')
    find('div[role="menuitem"]', text: 'Task').click
    find('div[role="menuitem"]', text: 'To Do').click
    page_refresh
    page.has_selector?('.miscellaneous')
    main_container = find('.miscellaneous')

    page.has_selector?('div[data-value]')

    # For Employee
    find_all('div[data-value]')[0].click
    page.send_keys('Adnan')
    page.has_text?('Adnan Ghaffar')
    page.send_keys(:enter)

    # For Account
    find_all('div[data-value]')[1].click
    page.send_keys('Angus')
    page.has_text?('Angus Adventure')
    page.send_keys(:enter)

    # For Contact
    find('#react-select-7-input').click
    page.send_keys('Angus')
    page.has_text?('Angus McFife')
    page.send_keys(:enter)

    find_all('div[data-value]').last.click
    page.send_keys('RQ-1 Please provide the following info')
    page.has_selector?('div[data-value]')
    page.send_keys(:enter)

    click_on 'Create Task'
    verify_todo_task_created
    page.current_path
  end

  def verify_todo_task_created
    within('.Sidebar') do
      click_on 'TASKS'
    end
    expect(page).not_to have_css('.loading')
    table_body = find_all('.tRow').last
    table_body.find_all('.row').first.click
    sleep(3)
    # Match Title
    title = find('.mainHeading').text
    expect(title).to eq('RQ-1 Please provide the following info')

    container = find('.formsetValue')
    labels = container.find_all('.labelValue')
    employee = labels[0].text
    account = labels[1].find('a').text
    contact = labels[2].find('a').text
    expect(employee).to eq('Adnan Ghaffar')
    expect(account).to include('Angus Adventures')
    expect(contact).to include('Angus McFife')
  end

  def create_task_request_info
    sleep(2)
    page_refresh
    # Click on + Task button
    page.has_text?('+ Task')
    click_link '+ Task'

    page.has_text?('Request Information')

    # Select For Contact: QA Test UAT Mail
    page.has_selector?('#react-select-5-input')
    for_contact = find_by_id('react-select-5-input').click
    page.send_keys('qa tests uat mail')
    page.has_text?('QA Tests UAT Mail')
    page.send_keys(:enter)

    # Select For Account
    page.has_selector?('#react-select-3-input')
    for_account = find_by_id('react-select-3-input').click
    page.send_keys('abc testing inc')
    page.has_text?('ABC Testing Inc.')
    page.send_keys(:enter)

    # Fill in Subject Line field
    page.has_selector?('#react-select-7-input')
    subject = find_by_id('react-select-7-input').click
    page.send_keys('Testing Task')
    page.send_keys(:enter)

    # Click on Create Task button
    click_on "Create Task"
    page.current_path
  end

  def create_incomplete_request_info
    sleep(3)
    page_refresh
    # Click on + Task button
    page.has_text?('+ Task')
    click_link '+ Task'

    page.has_text?('Request Information')

    # Click on Create Task button
    click_on "Create Task"
    page.current_path
  end

  def create_task_get_sign
    sleep(3)
    page_refresh
    # Click on + Task button
    page.has_text?('+ Task')
    click_link '+ Task'

    # Select Task Type: Get a Signature
    task_div = find('.task-type-select').click
    task_div.find_all('div', text: 'Get a Signature').last.click

    # Select For Contact: QA Test UAT Mail
    page.has_selector?('#react-select-10-input')
    for_contact = find_by_id('react-select-10-input').click
    page.send_keys('qa tests uat mail')
    page.has_text?('QA Tests UAT Mail')
    page.send_keys(:enter)

    # Select Document Type: Engagement Letter
    page.has_selector?('#react-select-12-input')
    document_type = find_by_id('react-select-12-input').click
    page.send_keys('engagement letter')
    page.has_text?('Engagement Letter')
    page.send_keys(:enter)

    # Select Document: DK Test 1
    page.has_selector?('#react-select-13-input')
    select_document = find_by_id('react-select-13-input').click
    page.send_keys('dk test 1')
    page.has_text?('DK Test 1')
    page.send_keys(:enter)

    # Select Partner: [your employee account]
    page.has_selector?('#react-select-15-input')
    partner = find_by_id('react-select-15-input').click
    page.send_keys('adnan ghaffar')
    page.has_text?('Adnan Ghaffar')
    page.send_keys(:enter)

    # Put in 10 in Fees field
    find('input[name="fees"]').click
    page.send_keys('10')
    page.send_keys(:tab)

    # Fill in Subject Line field
    page.has_selector?('#react-select-14-input')
    subject = find_by_id('react-select-14-input').click
    page.send_keys('Testing Task')
    page.send_keys(:enter)

    # Click on Create Task button
    click_on "Create Task"
    page.current_path
  end

  def create_incomplete_sign_task
    sleep(3)
    page_refresh
    # Click on + Task button
    page.has_text?('+ Task')
    click_link '+ Task'

    # Select Task Type: Get a Signature
    task_div = find('.task-type-select').click
    task_div.find_all('div', text: 'Get a Signature').last.click

    # Click on Create Task button
    click_on "Create Task"
    sleep(2)
    # Select Document Type: Engagement Letter
    page.has_selector?('#react-select-12-input')
    document_type = find_by_id('react-select-12-input').click
    page.send_keys('engagement letter')
    page.has_text?('Engagement Letter')
    page.send_keys(:enter)

    # Click on Create Task button
    click_on "Create Task"
    page.current_path
  end

  def create_task_to_do
    sleep(3)
    page_refresh
    # Click on + Task button
    page.has_text?('+ Task')
    click_link '+ Task'

    # Select Task Type: To Do
    task_div = find('.task-type-select').click
    task_div.find_all('div', text: 'To Do').last.click

    # Select For Employee: [your employee account]
    find_by_id('react-select-8-input').click
    page.send_keys('adnan ghaffar')
    page.has_text?('Adnan Ghaffar')
    page.send_keys(:tab)


    # Fill in Subject Line field
    page.has_selector?('#react-select-13-input')
    subject = find_by_id('react-select-13-input').click
    page.send_keys('Testing Task')
    page.send_keys(:enter)

    # Click on Create Task button
    click_on "Create Task"
    page.current_path
  end

  def create_incomplete_todo_task
    sleep(3)
    page_refresh
    # Click on + Task button
    page.has_text?('+ Task')
    click_link '+ Task'

    # Select Task Type: To Do
    task_div = find('.task-type-select').click
    task_div.find_all('div', text: 'To Do').last.click

    # Click on Create Task button
    click_on "Create Task"
    page.current_path
  end

  def create_task_manage_to_items
    sleep(3)
    page_refresh
    # Click on + Task button
    page.has_text?('+ Task')
    click_link '+ Task'

    # Select Task Type: To Do
    task_div = find('.task-type-select').click
    task_div.find_all('div', text: 'Manage To Go Items').last.click

    # Select For Contact: QA Test UAT Mail
    page.has_selector?('#react-select-10-input')
    for_contact = find_by_id('react-select-10-input').click
    page.send_keys('qa tests uat mail')
    page.has_text?('QA Tests UAT Mail')
    page.send_keys(:enter)

    # Select For Account
    page.has_selector?('#react-select-8-input')
    for_account = find_by_id('react-select-8-input').click
    page.send_keys('abc testing inc')
    page.has_text?('ABC Testing Inc.')
    page.send_keys(:enter)

    # Select To-Go Type: Mail
    page.has_selector?('#react-select-12-input')
    for_account = find_by_id('react-select-12-input').click
    page.send_keys('mail')
    page.has_text?('Mail')
    page.send_keys(:enter)

    # Select Document Type: 1040
    page.has_selector?('#react-select-13-input')
    for_account = find_by_id('react-select-13-input').click
    page.send_keys('1040')
    page.has_text?('1040')
    page.send_keys(:enter)

    # Fill in Subject Line field
    page.has_selector?('#react-select-14-input')
    subject = find_by_id('react-select-14-input').click
    page.send_keys('Testing Task')
    page.send_keys(:enter)

    # Click on Create Task button
    click_on "Create Task"
    page.current_path
  end

  def create_incomplete_manage_items
    sleep(3)
    page_refresh
    # Click on + Task button
    page.has_text?('+ Task')
    click_link '+ Task'

    # Select Task Type: To Do
    task_div = find('.task-type-select').click
    task_div.find_all('div', text: 'Manage To Go Items').last.click

    # Click on Create Task button
    click_on "Create Task"
    page.current_path
  end

  def create_task_meeting
    # Click on + Task button
    sleep(3)
    page_refresh
    page.has_text?('+ Task')
    click_link '+ Task'

    # Select Task Type: Get a Signature
    task_div = find('.task-type-select').click
    task_div.find_all('div', text: 'Meeting').last.click

    # Select For Contact: QA Test UAT Mail
    page.has_selector?('#react-select-9-input')
    for_contact = find_by_id('react-select-9-input').click
    page.send_keys('qa tests uat mail')
    page.has_text?('QA Tests UAT Mail')
    page.send_keys(:enter)

    # Select For Account
    page.has_selector?('#react-select-8-input')
    for_account = find_by_id('react-select-8-input').click
    page.send_keys('abc testing inc')
    page.has_text?('ABC Testing Inc.')
    page.send_keys(:enter)

    # Fill in Subject Line field
    page.has_selector?('#taskTitle')
    subject = find_by_id('taskTitle').click
    page.send_keys('Testing Task')
    page.send_keys(:enter)

    # Click on Create Task button
    click_on "Create Task"
    page.current_path
  end

  def create_incomplete_meeting
    sleep(3)
    page_refresh
    # Click on + Task button
    page.has_text?('+ Task')
    click_link '+ Task'

    # Select Task Type: Get a Signature
    task_div = find('.task-type-select').click
    task_div.find_all('div', text: 'Meeting').last.click

    # Click on Create Task button
    click_on "Create Task"
    page.current_path
  end

  def create_calendly_task
    sleep(3)
    page_refresh
    # Click on + Task button
    page.has_text?('+ Task')
    click_link '+ Task'

    # Select Task Type: Get a Signature
    task_div = find('.task-type-select').click
    task_div.find_all('div', text: 'Meeting').last.click

    # Select For Contact: QA Test UAT Mail
    page.has_selector?('#react-select-9-input')
    for_contact = find_by_id('react-select-9-input').click
    page.send_keys('qa tests uat mail')
    page.has_text?('QA Tests UAT Mail')
    page.send_keys(:enter)

    # Select For Account
    page.has_selector?('#react-select-8-input')
    for_account = find_by_id('react-select-8-input').click
    page.send_keys('abc testing inc')
    page.has_text?('ABC Testing Inc.')
    page.send_keys(:enter)

    # Click on Calendly Invite radio buttonr
    page.has_selector?('span[data-for="calendlymeetingcheckbox"]')
    for_calendly = find('span[data-for="calendlymeetingcheckbox"]').click
    sleep(2)
    click_button '30 Minute Meeting'

    # Click on Create Task button
    click_on "Create Task"
    page.current_path
  end

  def use_text_formatting_in_task
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

    attachment_browse_link = 'a[data-testid="attachments__browse"]'
    wait_for_selector(attachment_browse_link)
    find(attachment_browse_link).click

    find_by_id('tagId').click
    page.send_keys('Test')
    page.has_text?('Test')
    find('.dropdown-item').click

    file_input = find('input[id="upload_doc"]', visible: :all)
    file_input.attach_file(fixtures_path.join('images', '404.png'))
    sleep(3)

    # Click on the Upload button.
    click_on "Upload"

    sleep 3
    click_on "Create Template"

    page.current_path
  end

  def attach_templates_in_new_task
    find_by_id('react-select-8-input').click
    sleep 2

    page.send_keys("Testing")
    page.send_keys(:enter)

    find_by_id('react-select-3-input').click
    page.send_keys("Adnan")
    page.send_keys(:enter)

    find_by_id('react-select-5-input').click
    page.send_keys("ABC Testing")
    page.send_keys(:enter)

    find_by_id('react-select-7-input').click
    page.send_keys("Adnan QA")
    page.send_keys(:enter)

    click_on "Create Task"
    page.current_path
  end

  def view_tasks_with_formatting
    find('div[data-testid="row-0"]').click
    sleep 2
    page.current_path
  end

  def create_a_task_from_tasks_screen
    # In the Landing page, click on TASKS from left side nav of the dashboard screen.
    go_to_tasks

    # Under OPEN TASKS tab, click on the + TASK
    task_button_selector = 'a[data-testid="new-task-link"]'
    wait_for_selector(task_button_selector)
    find(task_button_selector).click

    # Verify the pre-selected DUE DATE
    date_picker_wrapper_selector = 'react-datepicker__input-container'
    wait_for_selector(".#{date_picker_wrapper_selector}")
    date_picker_wrapper = find(".#{date_picker_wrapper_selector}")
    pre_filled_date = date_picker_wrapper.find('input').value

    # Under CREATE TASK screen, click TASK: then select GET A SIGNATURE
    task_div = find('.task-type-select').click
    task_div.find_all('div', text: 'Get a Signature').last.click

    # Select For Account: ANGUS ADVENTURE
    page.has_selector?('#react-select-8-input')
    for_contact = find_by_id('react-select-8-input').click
    'angus adventure'.chars.each { |ch| page.send_keys(ch) }
    page.has_text?('Angus Adventures')
    page.send_keys(:enter)
    sleep(1)

    # Select For Contact: AQUIFA HALBERT
    page.has_selector?('#react-select-10-input')
    for_contact = find_by_id('react-select-10-input').click
    'aquifa halbert'.chars.each { |ch| page.send_keys(ch) }
    page.has_text?('Aquifa Halbert')
    page.send_keys(:enter)

    # Select Document Type: Engagement Letter
    page.has_selector?('#react-select-12-input')
    document_type = find_by_id('react-select-12-input').click
    'engagement letter'.chars.each { |ch| page.send_keys(ch) }
    page.has_text?('Engagement Letter')
    page.send_keys(:enter)

    # Select Document: DK Test 1
    page.has_selector?('#react-select-13-input')
    select_document = find_by_id('react-select-13-input').click
    page.send_keys('dk test 1')
    page.has_text?('DK Test 1')
    page.send_keys(:enter)

    # Select Partner: [your employee account]
    page.has_selector?('#react-select-15-input')
    partner = find_by_id('react-select-15-input').click
    page.send_keys('adnan ghaffar')
    page.has_text?('Adnan Ghaffar')
    page.send_keys(:enter)

    # Input any value in FEES
    find('input[name="fees"]').click
    page.send_keys('10')
    page.send_keys(:tab)

    # Fill in Subject Line field
    time_stamp = Time.now.to_i
    subject_title = "Task_#{time_stamp}"
    page.has_selector?('#react-select-14-input')
    subject = find_by_id('react-select-14-input').click
    page.send_keys(subject_title)
    page.send_keys(:enter)

    # Click on Create Task button
    click_on "Create Task"

    # Task successfully created* should display.
    wait_for_text(page, "Task created successfully")

    # User should be able to manually created a 'Get a Signature' task for Engagement Letter from TASKS.
    verify_task_created(subject_title)
    page.current_path
  end

  def create_a_task_from_add_new
    # In the Landing page, click on + ADD NEW from left side nav of the dashboard screen.
    # Verify a drop-down menu displays.
    # Click on TASKS in the drop-down menu then select GET A SIGNATURE
    go_to_get_a_signature
    sleep(3)

    # Verify the pre-selected DUE DATE
    date_picker_wrapper_selector = 'react-datepicker__input-container'
    wait_for_selector(".#{date_picker_wrapper_selector}")
    date_picker_wrapper = find(".#{date_picker_wrapper_selector}")
    pre_filled_date = date_picker_wrapper.find('input').value

    # Select For Account: ANGUS ADVENTURE
    page.has_selector?('input[aria-label="seachAccount"]')
    for_contact = find('input[aria-label="seachAccount"]').click
    'angus adventure'.chars.each { |ch| page.send_keys(ch) }
    page.has_text?('Angus Adventures')
    page.send_keys(:enter)
    sleep(1)

    # Select For Contact: AQUIFA HALBERT
    page.has_selector?('#react-select-5-input')
    for_contact = find_by_id('react-select-5-input').click
    'aquifa halbert'.chars.each { |ch| page.send_keys(ch) }
    page.has_text?('Aquifa Halbert')
    page.send_keys(:enter)

    # Select Document Type: Engagement Letter
    page.has_selector?('input[aria-label="doctype"]')
    document_type = find('input[aria-label="doctype"]').click
    'engagement letter'.chars.each { |ch| page.send_keys(ch) }
    page.has_text?('Engagement Letter')
    page.send_keys(:enter)

    # Select Document: DK Test 1
    page.has_selector?('input[aria-label="template"]')
    select_document = find('input[aria-label="template"]').click
    page.send_keys('dk test 1')
    page.has_text?('DK Test 1')
    page.send_keys(:enter)

    # Select Partner: [your employee account]
    page.has_selector?('#react-select-10-input')
    partner = find_by_id('react-select-10-input').click
    page.send_keys('adnan ghaffar')
    page.has_text?('Adnan Ghaffar')
    page.send_keys(:enter)

    # Input any value in FEES
    find('input[name="fees"]').click
    page.send_keys('10')
    page.send_keys(:tab)

    # Fill in Subject Line field
    time_stamp = Time.now.to_i
    subject_title = "Task_#{time_stamp}"
    page.has_selector?('input.custom-react-select__input')
    subject = find('input.custom-react-select__input').click
    page.send_keys(subject_title)
    page.send_keys(:enter)

    # Click on Create Task button
    click_on "Create Task"
    wait_for_loading_animation
    sleep(3)
    expect(page).to have_current_path('/')

    # Task successfully created* should display.
    wait_for_text(page, "Task created successfully")

    # User should be able to manually created a 'Get a Signature' task for Engagement Letter from + ADD NEW.
    verify_task_created(subject_title)
    page.current_path
  end

  def mark_get_a_signature_as_complete
    subject = create_get_signature_task_with_subject(:consent_to_release)

    expect(page).to have_current_path('/all_tasks')

    wait_for_selector('.filter-wrapper')
    filters = find('.filter-wrapper')
    search_input = filters.find('input')
    subject.chars.each { |ch| search_input.send_keys(ch) }
    sleep 2

    find('div[data-testid="row-0"]').click

    mark_as_complete_button_selector = 'button[data-testid="task__mark_complete_btn"]'
    wait_for_selector(mark_as_complete_button_selector)
    find(mark_as_complete_button_selector).click

    wait_for_text(page, 'You are about to mark this task as closed. Proceed?')
    click_on 'Proceed'

    sleep 1
    wait_for_text(page, 'Task updated successfully')
    page.current_path
  end

  def sign_get_a_signature_for_engagement_letter
    go_to_tasks
    sleep(3)
    page_refresh
    # Click on + Task button
    page.has_text?('+ Task')
    click_link '+ Task'

    # Select Task Type: Get a Signature
    task_div = find('.task-type-select').click
    task_div.find_all('div', text: 'Get a Signature').last.click
    sleep 1.5

    page.has_selector?('input[aria-label="seachAccount"]')
    for_account = find('input[aria-label="seachAccount"]').click
    'angus adventure'.chars.each { |ch| page.send_keys(ch) }
    page.has_text?('Angus Adventures')
    page.send_keys(:enter)

    # Select For Contact: QA Test UAT Mail
    page.has_selector?('#react-select-10-input')
    for_contact = find_by_id('react-select-10-input').click
    page.send_keys('aquifa tron')
    page.has_text?('Aquifa Tron Halbert')
    page.send_keys(:enter)
    sleep 1.5
    page.send_keys(:tab)
    page.send_keys('prem out')
    page.has_text?('Prem Outlook')
    page.send_keys(:enter)

    # Select Document Type: Engagement Letter/Consent to Release
    page.has_selector?('#react-select-12-input')
    find_by_id('react-select-12-input').click

    page.send_keys('engagement letter')
    page.has_text?('Engagement Letter')
    page.send_keys(:enter)
    sleep 1.5

    # Select Document: DK Test 1
    page.has_selector?('#react-select-13-input')
    select_document = find_by_id('react-select-13-input').click
    page.send_keys('dk test 1')
    page.has_text?('DK Test 1')
    page.send_keys(:enter)
    sleep 1.5

    # Select Partner: [your employee account]
    page.has_selector?('#react-select-15-input')
    partner = find_by_id('react-select-15-input').click
    page.send_keys('adnan ghaffar')
    page.has_text?('Adnan Ghaffar')
    page.send_keys(:enter)
    sleep 1.5

    # Put in 10 in Fees field
    find('input[name="fees"]').click
    page.send_keys('10')
    page.send_keys(:tab)
    sleep 1.5

    # Fill in Subject Line field
    page.has_selector?('#react-select-14-input')
    subject = find_by_id('react-select-14-input').click
    sleep 1.5

    time_stamp = Time.now.to_i
    subject = "Task_#{time_stamp}"
    page.send_keys(subject)
    page.send_keys(:enter)

    # Click on Create Task button
    click_on "Create Task"
    sleep 3

    login_page.logout
    login_to_app_as_active_liscio_client

    within('.Sidebar') do
      click_on 'TASKS'
    end

    # In the Landing page, click on TASKS from left side nav of the dashboard screen
    expect(page).to have_current_path('/all_tasks')

    wait_for_text(page, subject)

    find('strong', text: subject).click

    # Click the Click to sign document to open the Preview
    click_on 'Click to sign document'

    # Click the check box AGREED TO THE ABOVE DOCUMENTS

    modal = find('.modalContent--wrap')
    modal.find('span', text: 'AGREED TO THE ABOVE DOCUMENT').click

    # CLICK SUBMIT BUTTON
    click_on 'Submit'
    wait_for_text(page, 'SIGNED')
    page.current_path
  end

  def sign_get_a_signature_for_consent_to_release
    go_to_tasks
    sleep(3)
    page_refresh
    # Click on + Task button
    page.has_text?('+ Task')
    click_link '+ Task'

    # Select Task Type: Get a Signature
    task_div = find('.task-type-select').click
    task_div.find_all('div', text: 'Get a Signature').last.click
    sleep 1.5

    page.has_selector?('input[aria-label="seachAccount"]')
    for_account = find('input[aria-label="seachAccount"]').click
    'angus adventure'.chars.each { |ch| page.send_keys(ch) }
    page.has_text?('Angus Adventures')
    page.send_keys(:enter)

    # Select For Contact: QA Test UAT Mail
    page.has_selector?('#react-select-10-input')
    for_contact = find_by_id('react-select-10-input').click
    page.send_keys('aquifa tron')
    page.has_text?('Aquifa Tron Halbert')
    page.send_keys(:enter)
    sleep 1.5
    page.send_keys(:tab)
    page.send_keys('prem out')
    page.has_text?('Prem Outlook')
    page.send_keys(:enter)

    # Select Document Type: Engagement Letter/Consent to Release
    page.has_selector?('#react-select-12-input')
    find_by_id('react-select-12-input').click

    page.send_keys('consent to release')
    page.has_text?('Consent to Release')
    page.send_keys(:enter)
    sleep 1.5

    page.has_selector?('#react-select-13-input')
    select_document = find_by_id('react-select-13-input').click
    page.send_keys(:enter)

    # Fill in Subject Line field
    page.has_selector?('#react-select-14-input')
    subject = find_by_id('react-select-14-input').click
    sleep 1.5

    time_stamp = Time.now.to_i
    subject = "Task_#{time_stamp}"
    page.send_keys(subject)
    page.send_keys(:enter)

    # Click on Create Task button
    click_on "Create Task"
    sleep 3

    login_page.logout
    login_to_app_as_active_liscio_client

    within('.Sidebar') do
      click_on 'TASKS'
    end

    # In the Landing page, click on TASKS from left side nav of the dashboard screen
    expect(page).to have_current_path('/all_tasks')

    wait_for_text(page, subject)

    find('strong', text: subject).click

    # Click the Click to sign document to open the Preview
    click_on 'Click to sign document'

    # Click the check box AGREED TO THE ABOVE DOCUMENTS

    modal = find('.modalContent--wrap')
    modal.find('span', text: 'AGREED TO THE ABOVE DOCUMENT').click

    # CLICK SUBMIT BUTTON
    click_on 'Submit'
    wait_for_text(page, 'SIGNED')
    page.current_path
  end

  def manually_create_sign_task_from_account
    login_to_app
    within('.Sidebar') do
      click_on 'ACCOUNTS'
    end

    table = find('.tableWrap')
    table.find_all('.tdBtn').first.click

    heading = find('.breadcrumb')
    heading.has_text?('ALL ACCOUNTS')
    sleep(3)
    page_refresh
    page.has_text?('In Focus')
    click_on 'In Focus'

    page.has_selector?('.inFocusBtn')
    find_all('.inFocusBtn').first.click

    in_focus_path = page.current_path

    fill_modal
    in_focus_path
  end

  def manually_create_sign_task_from_contact
    login_to_app
    within('.Sidebar') do
      click_on 'CONTACTS'
    end

    unless page.has_selector?('.tableWrap')
      sleep 3
      page_refresh
    end

    page.has_selector?('.tableWrap')
    table = find('.tableWrap')
    table.find_all('.tdBtn')[5].click

    sleep(3)
    heading = find('.breadcrumb')
    heading.has_text?('ALL CONTACTS')
    sleep(3)
    page_refresh
    page.has_text?('Task')
    click_on 'Task'

    contacts_path = page.current_path

    page.has_text?('+ Task')
    click_button '+ Task'

    page.has_selector?('a[href="/task/new"]')
    task_div = find('.task-type-select').click
    task_div.find_all('div', text: 'To Do').last.click

    page.has_selector?('.labelValue')
    employee = find_all('input').first.click
    sleep(2)
    page.send_keys(:enter)

    page.has_selector?('div[data-value]')
    find_all('div[data-value]')[1].click
    sleep(2)
    page.send_keys(:enter)

    find_all('div[data-value]').last.click
    page.send_keys('RQ-1 Please provide the following info')
    page.send_keys(:enter)

    click_on 'Create Task'
    contacts_path
  end

  def manually_create_sign_task_from_tasks
    go_to_tasks
    sleep(3)
    page_refresh
    page.has_text?('+ Task')
    click_link '+ Task'

    task_div = find('.task-type-select').click
    task_div.find_all('div', text: 'Get a Signature').last.click
    sleep 1.5

    page.has_selector?('input[aria-label="seachAccount"]')
    for_account = find('input[aria-label="seachAccount"]').click
    'angus adventure'.chars.each { |ch| page.send_keys(ch) }
    page.has_text?('Angus Adventures')
    page.send_keys(:enter)
    sleep 1.5

    page.has_selector?('#react-select-10-input')
    for_contact = find_by_id('react-select-10-input').click
    page.send_keys('aquifa tron')
    page.has_text?('Aquifa Tron Halbert')
    page.send_keys(:enter)
    sleep 1.5

    page.send_keys(:tab)
    page.send_keys('prem out')
    page.has_text?('Prem Outlook')
    page.send_keys(:enter)
    sleep 1.5

    # Select Document Type: Engagement Letter
    page.has_selector?('#react-select-12-input')
    find_by_id('react-select-12-input').click
    page.send_keys(:enter)
    sleep 5

    # Select Document: DK Test 1
    page.has_selector?('#react-select-13-input')
    select_document = find_by_id('react-select-13-input').click
    page.send_keys('dk test 1')
    page.has_text?('DK Test 1')
    page.send_keys(:enter)
    sleep 1.5

    # Select Partner: [your employee account]
    page.has_selector?('#react-select-15-input')
    partner = find_by_id('react-select-15-input').click
    page.send_keys('adnan ghaffar')
    page.has_text?('Adnan Ghaffar')
    page.send_keys(:enter)
    sleep 1.5

    # Put in 10 in Fees field
    find('input[name="fees"]').click
    page.send_keys('10')
    page.send_keys(:tab)
    sleep 1.5

    time_stamp = Time.now.to_i
    subject = "Task_#{time_stamp}"
    page.send_keys(subject)
    page.send_keys(:enter)

    click_on "Create Task"
    page.current_path
  end

  def create_consent_release_from_account
    login_to_app
    within('.Sidebar') do
      click_on 'ACCOUNTS'
    end

    table = find('.tableWrap')
    table.find_all('.tdBtn').first.click

    heading = find('.breadcrumb')
    heading.has_text?('ALL ACCOUNTS')
    sleep(3)
    page_refresh
    page.has_text?('In Focus')
    click_on 'In Focus'

    page.has_selector?('.inFocusBtn')
    find_all('.inFocusBtn').first.click

    in_focus_path = page.current_path

    fill_modal
    in_focus_path
  end

  def create_consent_release_from_task
    go_to_tasks
    sleep(3)
    page_refresh
    page.has_text?('+ Task')
    click_link '+ Task'

    task_div = find('.task-type-select').click
    task_div.find_all('div', text: 'Get a Signature').last.click
    sleep 1.5

    page.has_selector?('input[aria-label="seachAccount"]')
    for_account = find('input[aria-label="seachAccount"]').click
    'angus adventure'.chars.each { |ch| page.send_keys(ch) }
    page.has_text?('Angus Adventures')
    page.send_keys(:enter)

    sleep 1.5

    page.has_selector?('#react-select-10-input')
    for_contact = find_by_id('react-select-10-input').click
    page.send_keys('aquifa tron')
    page.has_text?('Aquifa Tron Halbert')
    page.send_keys(:enter)
    sleep 1.5

    page.send_keys(:tab)
    page.send_keys('prem out')
    page.has_text?('Prem Outlook')
    page.send_keys(:enter)
    sleep 1.5

    # Select Document Type: Engagement Letter
    page.has_selector?('#react-select-12-input')
    find_by_id('react-select-12-input').click
    page.send_keys(:enter)
    sleep 5

    # Select Document: DK Test 1
    page.has_selector?('#react-select-13-input')
    select_document = find_by_id('react-select-13-input').click
    page.send_keys('dk test 1')
    page.has_text?('DK Test 1')
    page.send_keys(:enter)
    sleep 1.5

    # Select Partner: [your employee account]
    page.has_selector?('#react-select-15-input')
    partner = find_by_id('react-select-15-input').click
    page.send_keys('adnan ghaffar')
    page.has_text?('Adnan Ghaffar')
    page.send_keys(:enter)
    sleep 1.5

    # Put in 10 in Fees field
    find('input[name="fees"]').click
    page.send_keys('10')
    page.send_keys(:tab)
    sleep 1.5

    time_stamp = Time.now.to_i
    subject = "Task_#{time_stamp}"
    page.send_keys(subject)
    page.send_keys(:enter)

    click_on "Create Task"
    page.current_path
  end

  def create_consent_release_from_contact
    login_to_app
    within('.Sidebar') do
      click_on 'CONTACTS'
    end
    sleep(2)
    page_refresh

    page.has_selector?('.tableWrap')
    table = find('.tableWrap')
    table.find_all('.tdBtn')[5].click

    sleep(3)
    heading = find('.breadcrumb')
    heading.has_text?('ALL CONTACTS')
    sleep(3)
    page_refresh
    page.has_text?('Task')
    click_on 'Task'

    contacts_path = page.current_path

    page.has_text?('+ Task')
    click_button '+ Task'

    page.has_selector?('a[href="/task/new"]')
    task_div = find('.task-type-select').click
    task_div.find_all('div', text: 'To Do').last.click

    # For Employee
    find_all('div[data-value]')[0].click
    page.send_keys('Adnan')
    page.has_text?('Adnan Ghaffar')
    page.send_keys(:enter)
    sleep 1.5

    # For Account
    find_all('div[data-value]')[1].click
    page.send_keys('Angus')
    page.has_text?('Angus Adventure')
    page.send_keys(:enter)
    sleep 1.5

    # For Subject
    page.has_selector?('div[data-value]')
    find_all('div[data-value]').last.click
    page.send_keys('RQ-1 Please provide the following info')
    page.send_keys(:enter)

    click_on 'Create Task'
    contacts_path
  end

  def letter_mark_as_complete
    subject = create_get_signature_task_with_subject(:consent_to_release)

    expect(page).to have_current_path('/all_tasks')

    wait_for_selector('.filter-wrapper')
    filters = find('.filter-wrapper')
    search_input = filters.find('input')
    subject.chars.each { |ch| search_input.send_keys(ch) }
    sleep 2

    find('div[data-testid="row-0"]').click

    mark_as_complete_button_selector = 'button[data-testid="task__mark_complete_btn"]'
    wait_for_selector(mark_as_complete_button_selector)
    find(mark_as_complete_button_selector).click

    wait_for_text(page, 'You are about to mark this task as closed. Proceed?')
    click_on 'Proceed'

    sleep 1
    wait_for_text(page, 'Task updated successfully')
    page.current_path
  end

  def create_meeting_task
    sleep(3)
    page_refresh
    page.has_text?('+ Task')
    click_link '+ Task'

    task_div = find('.task-type-select').click
    task_div.find_all('div', text: 'Meeting').last.click

    page.has_selector?('#react-select-9-input')
    for_contact = find_by_id('react-select-9-input').click
    page.send_keys('qa tests uat mail')
    page.has_text?('QA Tests UAT Mail')
    page.send_keys(:enter)

    page.has_selector?('#react-select-8-input')
    for_account = find_by_id('react-select-8-input').click
    page.send_keys('abc testing inc')
    page.has_text?('ABC Testing Inc.')
    page.send_keys(:enter)

    page.has_selector?('#taskTitle')
    subject = find_by_id('taskTitle').click
    page.send_keys('Testing Task')
    page.send_keys(:enter)

    click_on "Create Task"
    page.current_path
  end

  def create_task_from_addnew
    sleep(3)
    page_refresh
    page.has_text?('+ Task')
    click_link '+ Task'

    task_div = find('.task-type-select').click
    task_div.find_all('div', text: 'Manage To Go Items').last.click

    page.has_selector?('#react-select-10-input')
    for_contact = find_by_id('react-select-10-input').click
    page.send_keys('qa tests uat mail')
    page.has_text?('QA Tests UAT Mail')
    page.send_keys(:enter)

    page.has_selector?('#react-select-8-input')
    for_account = find_by_id('react-select-8-input').click
    page.send_keys('abc testing inc')
    page.has_text?('ABC Testing Inc.')
    page.send_keys(:enter)

    page.has_selector?('#react-select-12-input')
    for_account = find_by_id('react-select-12-input').click
    page.send_keys('mail')
    page.has_text?('Mail')
    page.send_keys(:enter)

    page.has_selector?('#react-select-13-input')
    for_account = find_by_id('react-select-13-input').click
    page.send_keys('1040')
    page.has_text?('1040')
    page.send_keys(:enter)

    page.has_selector?('#react-select-14-input')
    subject = find_by_id('react-select-14-input').click
    page.send_keys('Testing Task')
    page.send_keys(:enter)

    click_on "Create Task"
    page.current_path
  end

  def manually_create_get_a_signatur_for_engagement_letter_from_email
    login_to_app_as_automation_qa

    # Received an email with document as attachment
    email_title = send_email_to_adnan_with_unique_timestamp

    login_page.logout
    login_to_app

    # In the Landing page, click on EMAIL from left side nav of the dashboard screen
    email_selector = 'div[data-testid="sidebar__emails"]'
    wait_for_selector(email_selector)
    find(email_selector).click

    expand_email_with_subject(email_title)

    # Verify an ellipses button displays next to the date and time the email was sent
    page.has_selector?('.ReplyAction')
    message_action = find_all('.ReplyAction').last
    # Verify a drop-down menu displays
    # Click on the ellipses button then choose CREATE TASK
    within message_action do
      find_all('span').last.click
      6.times.each do |x|
        page.send_keys(:arrow_down) # Create Task
      end
      page.send_keys(:enter)
    end

    wait_for_selector('.NewTaskEmail')
    modal = find('.NewTaskEmail')
    sleep 2
    within modal do
      # Select get a signature
      find_all('div.form-group')[0].click

      4.times.each do
        page.send_keys(:arrow_down)
      end
      page.send_keys(:enter)

      # Click the FOR CONTACT: drop down menu then choose "Adnan Ghaffar Testing" as one of the recipient.
      for_contact = find_all('div.form-group')[3].click
      'adnan testing g'.chars.each do |ch|
        page.send_keys(ch)
        sleep 0.5
      end
      wait_for_text(page, 'Adnan Testing Ghaffar')
      page.send_keys(:enter)
      sleep 1

      # Click the SELECT DOCUMENT TYPE select ENGAGEMENT LETTER
      find_all('div.form-group')[5].click
      page.send_keys(:enter)
      sleep 1

      # Click the SELECT DOCUMENT TYPE select ENGAGEMENT LETTER.
      find_all('div.form-group')[6].click
      page.send_keys(:enter)
      sleep 1

      # Verify the SELECT PARTNER dropdown list.
      find_all('div.form-group')[7].click
      'adnan ghaffar'.chars.each { |ch| page.send_keys(ch) }
      wait_for_text(page, 'Adnan Ghaffar')
      page.send_keys(:enter)
      sleep 1

      # Input any value in FEES
      fill_in 'fees', with: '500'
      sleep 1

      click_on 'Create Task'
      sleep 0.5
      click_on 'Create Task'
    end

    wait_for_text(page, 'Task created successfully')
    page.current_path
  end

  def manualy_create_get_a_signature_for_consent_to_release
    login_to_app_as_automation_qa

    # Received an email with document as attachment
    email_title = send_email_to_adnan_with_unique_timestamp

    login_page.logout
    login_to_app

    # In the Landing page, click on EMAIL from left side nav of the dashboard screen
    email_selector = 'div[data-testid="sidebar__emails"]'
    wait_for_selector(email_selector)
    find(email_selector).click

    expand_email_with_subject(email_title)

    # Verify an ellipses button displays next to the date and time the email was sent
    page.has_selector?('.ReplyAction')
    message_action = find_all('.ReplyAction').last
    # Verify a drop-down menu displays
    # Click on the ellipses button then choose CREATE TASK
    within message_action do
      find_all('span').last.click
      6.times.each do |x|
        page.send_keys(:arrow_down) # Create Task
      end
      page.send_keys(:enter)
    end

    wait_for_selector('.NewTaskEmail')
    modal = find('.NewTaskEmail')
    sleep 2
    within modal do
      # Select get a signature
      find_all('div.form-group')[0].click

      4.times.each do
        page.send_keys(:arrow_down)
      end
      page.send_keys(:enter)

      # Click the FOR CONTACT: drop down menu then choose "Adnan Ghaffar Testing" as one of the recipient.
      for_contact = find_all('div.form-group')[3].click
      'adnan testing g'.chars.each do |ch|
        page.send_keys(ch)
        sleep 0.5
      end
      wait_for_text(page, 'Adnan Testing Ghaffar')
      page.send_keys(:enter)
      sleep 1

      # Click the SELECT DOCUMENT TYPE select CONSENT TO RELEASE
      find_all('div.form-group')[5].click
      page.send_keys(:arrow_down)
      page.send_keys(:enter)
      sleep 1

      # Click the SELECT DOCUMENT TYPE select CONSENT TO RELEASE
      find_all('div.form-group')[6].click
      page.send_keys(:enter)
      sleep 1

      click_on 'Create Task'
    end

    wait_for_text(page, 'Task created successfully')
    page.current_path
  end

  def send_file_without_sending_notification
    # Log in to Firm Admin Account
    login_to_app

    # From Home Dashboard, click on +Add New on the left nav menu > File
    add_new_selector = 'div[data-testid="sidebar__add_new"]'
    wait_for_selector(add_new_selector)
    find(add_new_selector).click

    sleep 2
    # Verify a drop-down menu displays
    page.has_css?('div[role="menu"]')
    div = find('div[role="menu"]')

    page.has_css?('div[role="menuitem"]')
    sleep 2
    div.find('div[role="menuitem"]', text: 'File').click

    to_field_selector = '.cstRtags'
    wait_for_selector(to_field_selector)
    find(to_field_selector).click

    # Fill in To (Recipient) field and Tags fields
    'adnan ghaffar'.chars.each { |ch| page.send_keys(ch) }
    page.send_keys(:enter)
    click_on 'Ok'

    # Check the Do not send Message checkbox
    wait_for_text(page, 'Do not Send Message')
    find('span', text: 'Do not Send Message').click

    # Select a tag for file
    find_by_id('tagId').click
    page.send_keys('Test')
    page.has_text?('Test')
    find('.dropdown-item').click

    # Click on Browse link in File section
    file_input = find('input[id="upload_doc"]', visible: :all)

    # Select file to attach and upload
    file_input.attach_file(fixtures_path.join('images', '404.png'))

    # Select file to attach and upload
    wait_for_text(page, 'Preview')

    # Click Upload button
    click_on "Upload"

    # Verify a "File uploaded successfully" toast displays
    wait_for_text(page, 'Files uploaded successfully')

    # Log out from Liscio Admin account
    login_page.logout

    # Log in with Liscio Client account where you sent the file
    login_to_app_as_automation_qa

    # From Home Dashboard, click on Notifications
    notification_selector = 'div[data-testid="sidebar__notifications"]'
    wait_for_selector(notification_selector)
    find(notification_selector).click

    # Client should see the file uploaded in files list
    file_selector = 'div[data-testid="sidebar__files"]'
    wait_for_selector(file_selector)
    find(file_selector).click

    sleep 2
    page_refresh

    first_file = find_all('.row')[1].text
    expect(first_file).to include('404.pdf')
    expect(first_file).to include('by Adnan Ghaffar')
    page.current_path
  end

  def upload_different_file_type
    # Log in to Firm Admin Account
    login_to_app

    # From Home Dashboard, click on +Add New on the left nav menu > File
    add_new_selector = 'div[data-testid="sidebar__add_new"]'
    wait_for_selector(add_new_selector)
    find(add_new_selector).click

    sleep 2
    # Verify a drop-down menu displays
    page.has_css?('div[role="menu"]')
    div = find('div[role="menu"]')

    page.has_css?('div[role="menuitem"]')
    sleep 2
    div.find('div[role="menuitem"]', text: 'File').click

    to_field_selector = '.cstRtags'
    wait_for_selector(to_field_selector)
    find(to_field_selector).click

    # Fill in To (Recipient) field and Tags fields
    'adnan ghaffar'.chars.each { |ch| page.send_keys(ch) }
    page.send_keys(:enter)
    click_on 'Ok'

    # Check the Do not send Message checkbox
    wait_for_text(page, 'Do not Send Message')
    find('span', text: 'Do not Send Message').click

    # Select a tag for file
    find_by_id('tagId').click
    page.send_keys('Test')
    page.has_text?('Test')
    find('.dropdown-item').click

    # Click on Browse link in File section
    file_input = find('input[id="upload_doc"]', visible: :all)

    # Select file to attach and upload
    file_input.attach_file(fixtures_path.join('images', '404.png'))

    # Click on Browse link in File section
    file_input = find('input[id="upload_doc"]', visible: :all)

    # Select file to attach and upload
    file_input.attach_file(fixtures_path.join('files', 'sample.pdf'))

    # Click on Browse link in File section
    file_input = find('input[id="upload_doc"]', visible: :all)

    # Select file to attach and upload
    file_input.attach_file(fixtures_path.join('files', 'sample.xls'))

    # Click Upload button
    click_on "Upload"

    # Verify a "File uploaded successfully" toast displays
    wait_for_text(page, 'Files uploaded successfully')
    page.current_path
  end

  def attach_files_to_tasks_from_add_new
    login_to_app

    # Click on + ADD NEW from the left-hand navigation menu
    add_new_selector = 'div[data-testid="sidebar__add_new"]'
    wait_for_selector(add_new_selector)

    # In Landing Page, click the + Add New button at the left sidebar
    find(add_new_selector).click

    sleep(2)
    page.has_selector?('div[role="menuitem"]')

    # Click on "Task"
    find('div[role="menuitem"]', text: 'Task').click

    # From the "Task" option menu, click on "Request Information"
    find('div[role="menuitem"]', text: 'Request Information').click
    wait_for_loading_animation
    page_refresh
    sleep(2)

    # Click on FOR ACCOUNT field "Select…" bar
    # Begin typing account name "Angus Adventures"
    # Verify account names begin to filter based on the first letter typed ("A")
    # Verify full account name is suggested in drop-down
    # Click on "Angus Adventures"
    page.has_selector?('input[aria-label="seachAccount"]')
    for_contact = find('input[aria-label="seachAccount"]').click
    'angus adventure'.chars.each { |ch| page.send_keys(ch) }
    page.has_text?('Angus Adventures')
    page.send_keys(:enter)
    sleep(1)

    # Click on FOR CONTACT field "Select…" bar
    # Verify a short drop-down list of associated contacts displays
    # Click on "Aquifa Tron Halbert"
    # Verify account name populates the FOR CONTACT field selection bar
    page.has_selector?('#react-select-5-input')
    for_contact = find_by_id('react-select-5-input').click
    'aquifa tron'.chars.each { |ch| page.send_keys(ch) }
    page.has_text?('Aquifa Tron Halbert')
    page.send_keys(:enter)

    # Click on the SUBJECT field
    # Verify various subjects display
    # Begin to type a subject titled "Attached Files"
    # Verify the subjects begin to filter based on the first letter typed ("A")
    # Complete typing "Attached Files"
    # Verify "No options" displays
    # Click out of the typing field
    # Verify "No options" text no longer displays
    # Type random message (ex. "See below") in DESCRIPTION field
    time_stamp = Time.now.to_i
    subject_title = "Task_#{time_stamp}"
    page.has_selector?('input.custom-react-select__input')
    subject = find('input.custom-react-select__input').click
    page.send_keys(subject_title)
    page.send_keys(:enter)

    iframe = find('iframe[id^="tiny-react_"]')
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('This is just a test message.')
      page.send_keys(:tab)
    end

    # Click on Browse link under FILE
    # Verify "Upload File" modal displays
    # Click on Browse link again
    # Select and upload sample .xlsx format file from system file dialog
    # Verify file is uploaded to Liscio with Preview link available
    # Click on TAGS bar and select "Test" in drop-down
    # Click on Upload button
    # Verify "Upload File" modal closes
    attachment_browse_link = 'a[data-testid="attachments__browse"]'
    wait_for_selector(attachment_browse_link)
    find(attachment_browse_link).click

    find_by_id('tagId').click
    page.send_keys('Test')
    page.has_text?('Test')
    find('.dropdown-item').click

    file_input = find('input[id="upload_doc"]', visible: :all)
    file_input.attach_file(fixtures_path.join('files', 'sample.xls'))

    # Select file to attach and upload
    wait_for_text(page, 'Preview')

    # Click on the Upload button.
    click_on "Upload"

    # Click on Create Task button
    click_on "Create Task"
    wait_for_loading_animation
    sleep(3)
    expect(page).to have_current_path('/')

    # Verify "Updated Successfully" toast displays
    wait_for_text(page, "Task created successfully")
    page.current_path
  end

  private

  def expand_email_with_subject(subject)
    page.has_selector?('input[type="search"]')
    search_box = find('input[type="search"]')
    subject.chars.each do |ch|
      search_box.send_keys(ch)
      sleep 0.5
    end

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

  def create_get_signature_task_with_subject(document_type)
    go_to_tasks
    sleep(3)
    page_refresh
    # Click on + Task button
    page.has_text?('+ Task')
    click_link '+ Task'

    # Select Task Type: Get a Signature
    task_div = find('.task-type-select').click
    task_div.find_all('div', text: 'Get a Signature').last.click
    sleep 1.5

    page.has_selector?('input[aria-label="seachAccount"]')
    for_account = find('input[aria-label="seachAccount"]').click
    'abc testing inc'.chars.each { |ch| page.send_keys(ch) }
    page.has_text?('ABC Testing Inc.')
    page.send_keys(:enter)

    # Select For Contact: QA Test UAT Mail
    page.has_selector?('#react-select-10-input')
    for_contact = find_by_id('react-select-10-input').click
    page.send_keys('adnan qa qa')
    page.has_text?('Adnan QA QA')
    page.send_keys(:enter)
    sleep 1.5

    # Select Document Type: Engagement Letter/Consent to Release
    page.has_selector?('#react-select-12-input')
    find_by_id('react-select-12-input').click
    if document_type == :consent_to_release
      page.send_keys('consent to release')
      page.has_text?('Consent to Release')
      page.send_keys(:enter)
      sleep 1.5

      page.has_selector?('#react-select-13-input')
      select_document = find_by_id('react-select-13-input').click
      page.send_keys(:enter)
    else
      page.send_keys('engagement letter')
      page.has_text?('Engagement Letter')
      page.send_keys(:enter)
      sleep 1.5

      # Select Document: DK Test 1
      page.has_selector?('#react-select-13-input')
      select_document = find_by_id('react-select-13-input').click
      page.send_keys('dk test 1')
      page.has_text?('DK Test 1')
      page.send_keys(:enter)
      sleep 1.5

      # Select Partner: [your employee account]
      page.has_selector?('#react-select-15-input')
      partner = find_by_id('react-select-15-input').click
      page.send_keys('adnan ghaffar')
      page.has_text?('Adnan Ghaffar')
      page.send_keys(:enter)
      sleep 1.5

      # Put in 10 in Fees field
      find('input[name="fees"]').click
      page.send_keys('10')
      page.send_keys(:tab)
      sleep 1.5
    end

    # Fill in Subject Line field
    page.has_selector?('#react-select-14-input')
    subject = find_by_id('react-select-14-input').click
    sleep 1.5

    time_stamp = Time.now.to_i
    subject = "Task_#{time_stamp}"
    page.send_keys(subject)
    page.send_keys(:enter)

    # Click on Create Task button
    click_on "Create Task"
    subject
  end

  def verify_task_created(subject)
    within('.Sidebar') do
      click_on 'TASKS'
    end

    page_refresh

    search_box = find('input[type="search"]')
    search_box.send_keys(subject)
    wait_for_loading_animation

    wait_for_loading_animation

    first_row_selector = 'div[data-testid="row-0"]'
    wait_for_selector(first_row_selector)
    row = find(first_row_selector).text

    record = row.split("\n")
    expect(record[0]).to eq('Get a Signature')
    expect(record[1]).to eq(subject)
    expect(record[2]).to include('Aquifa Halbert')
    expect(record[3]).to include('Angus Adventures')
  end

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

    file_input = find('input[data-testid="attachment__browse"]', visible: :all)
    file_input.attach_file(fixtures_path.join('images', '404.png'))

    # Select file to attach and upload
    wait_for_text(page, 'Preview')

    # Click on Send button
    click_on "Send", visible: true

    subject
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

  def get_subject_with_timestamp
    time_stamp = Time.now.to_i
    "test_#{time_stamp}"
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
