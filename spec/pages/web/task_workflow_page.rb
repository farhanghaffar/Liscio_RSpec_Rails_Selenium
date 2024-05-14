require_relative './base_page'
require_relative './login_page'

class TaskWorkflowPage < BasePage
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
      div.find('div[role="menuitem"]', text: 'Get Signature').click
    end
  end

  def go_to_emails
    login_to_app
    within('.Sidebar') do
      click_on 'EMAILS'
    end
  end

  def create_task_from_bulk_actions
    sleep(3)
    page_refresh
    # Click on the Select all checkbox to Select all Contacts in the current page
    sleep(3)
    find_all('.checkbox')[1].click

    # Scroll down and click on Next Step button
    click_on "Next Step"

    # Select Document Type: Engagement Letter
    find_by_id('react-select-3-input').click
    find_by_id('react-select-3-option-0').click

    # Select Document: Engagement Letter Fixed Fee (11)
    find_by_id('react-select-4-input').click
    find_by_id('react-select-4-option-2').click

    # Select Partner: [your employee account]
    find_by_id('react-select-6-input').click
    page.send_keys('Adnan')
    page.send_keys(:tab)

    # Put in 10 in Fees field
    find('input[name="fees"]').click
    page.send_keys('10')
    page.send_keys(:tab)

    # Fill in Subject Line field
    find_all('#DocumentSection__SelectTemplate').first.click
    page.send_keys('Testing')
    page.send_keys(:tab)

    # Click on Preview Document button
    click_on "Preview Document"
    click_on "Save Document"
    click_on "Create Document"

    # Click on Send Document
    click_on "Send Document"
  end

  def create_task_from_message
    sleep(3)
    # From Home Dashboard, click on an Existing message conversation under Liscio Messages tab
    find_all('.row')[1].click

    # Click on the three dots **(...)*** on the right corner of the last conversation card on list
    sleep(2)
    find_all('.icon-more').first.click

    # Select Create Task
    find('li', text: "Create Task").click

    # Select For Employee: [your employee account]
    find_by_id('react-select-8-input').click
    page.send_keys('Adnan')
    page.send_keys(:tab)

    # Click on Create Task button
    click_on "Create Task"
  end

  def create_task_using_checkbox
    sleep(3)
    # From Home Dashboard, click on an Existing message conversation under Liscio Messages tab
    find_all('.row')[1].click

    # Click on the (checkbox icon) between the message and notepad icon
    sleep(2)
    find('svg[data-testid="CheckBoxOutlinedIcon"]').click

    # Select For Employee: [your employee account]
    find_by_id('react-select-8-input').click
    page.send_keys('Adnan')
    page.send_keys(:tab)

    # Click on Create Task button
    click_on "Create Task"
  end

  def create_task_from_emails
    # In the message list, click on the three dots (...) of the email preview in the list
    sleep(3)
    find_all('.EmOne__Border').first.hover

    # Select *Create Task*
    find_all('.icon-more').first.click
    find('li', text: "Create Task").click

    # Select For Employee: [your employee account]
    find_by_id('react-select-8-input').click
    page.send_keys('Adnan')
    page.send_keys(:tab)

    # Select For Account: ABC Testing Inc.
    find_by_id('react-select-9-input').click
    page.send_keys('ABC Testing')
    page.send_keys(:tab)

    # Click on Create Task + button
    click_on "Create Task"
  end

  def archive_an_existing_task
    sleep(4)
    page_refresh
    # From Home Dashboard, click on an existing task under My Tasks section
    page.has_text?('My Tasks')
    page.has_selector?('span')

    # Check the check box of the tasks you want to archive
    find_all('.checkbox')[2].click

    # Click on the Archive button beside + Task button on the upper right corner
    click_on "Archive"
    sleep(3)
    # Click Yes in the confirmation dialog box that will pop up
    click_on "Yes"
  end

  def archive_from_task_list
    # From Home Dashboard, click on an existing task under My Tasks section
    page.has_text?('My Tasks')
    page.has_selector?('span')
    find_all('span', text: "Testing").first.click
    sleep(3)
    page_refresh

    # Click on the three dots (...) on the top right corner
    find_all('.icon-more').first.click

    # Click on the Archive button beside + Task button on the upper right corner
    click_on "Archive Task"
  end

  def reopen_archived_task
    # Click on Archived tab
    page.has_selector?('.nav-item')
    find('.nav-item', text: 'Archived').click

    # Open a task under the list
    find_all('.row')[1].click
    sleep(3)
    page_refresh
    # Click on the three dots (...) on the top right corner
    find_all('.icon-more').first.click
    sleep(3)
    # Select Re-Open task
    click_on "Re-Open Task"
    page.current_path
  end

  def create_task_from_home_dashboard
    login_to_app
    # From Home Dashboard, click on + Task under Tasks section
    page.has_selector?('a[href="/task/new"]')
    click_link('+ Task', href: '/task/new')
    task_div = find('.task-type-select').click
    task_div.find_all('div', text: 'Request Information').last.click

    # Select Task Type: Request Information
    page.has_selector?('#react-select-3-input')
    for_account = find_by_id('react-select-3-input').click
    page.send_keys('abc testing inc')
    page.has_text?('ABC Testing Inc.')
    page.send_keys(:enter)

    # Select For Contact: Adnan QA QA
    page.has_selector?('#react-select-5-input')
    for_contact = find_by_id('react-select-5-input').click
    page.send_keys('adnan qa qa')
    page.has_text?('Adnan QA QA')
    page.send_keys(:enter)

    # Fill in Subject Line field
    page.has_selector?('#react-select-7-input')
    subject = find_by_id('react-select-7-input').click
    page.send_keys('This is a Test newly created task')
    page.send_keys(:enter)

    # Click on + Create Task button
    click_on 'Create Task'

    # User will be redirected back to Home Dashboard.
    expect(page).to have_current_path('/')
    verify_task_created
  end

  def verify_task_created
    # Under Tasks section > Outstanding Tasks tab, you should be able to see the tasks you created on top of the list with these columns: Task Name, Assigned To, Account, Owner, Due Date, and Last Activity At.
    page.has_text?('TASK NAME')
    page.has_text?('ASSIGNED TO')
    page.has_text?('ACCOUNT')
    page.has_text?('OWNER')
    page.has_text?('DUE DATE')
    page.has_text?('LAST ACTIVITY AT')
    page.has_text?('Outstanding Tasks')
    outstanding_tab = find('a', text: 'Outstanding Tasks')
    outstanding_tab.click
    expect(outstanding_tab[:class]).to include('active')
    page.has_selector?('.tRow')
    table_body = find_all('.tRow').last

    first_row = table_body.find_all('.row').first.text
    task_label = first_row.split("\n")[0]
    assigned_to = first_row.split("\n")[2]
    expect(assigned_to).to eq("adnan qa qa")

    # The Task Type label should be visible on top of the subject line of the task you created.
    expect(task_label).to eq("Request Information")
    page.current_path
  end

  def create_task_from_new_button_dashboard
    login_to_app

    # From Home Dashboard, click on +Add New button on the left nav menu > Task > Meeting
    within('.Sidebar') do
      find('span', text: 'ADD NEW').click
    end

    # Verify a drop-down menu displays
    page.has_css?('div[role="menu"]')
    div = find('div[role="menu"]')

    page.has_css?('div[role="menuitem"]')
    div.find('div[role="menuitem"]', text: 'Task').hover

    page.has_text?('Meeting')
    find('div[role="menuitem"]', text: 'Meeting').click
    # Verify a loading animation displays
    page.has_css?('#loading')
    expect(page.current_url).to include('task/new?type=virtual_meeting')
    # Blocked [Please set up zoom or calendly to create virtual Meetings.]
    # TODO: Automation Steps
  end

  def create_task_from_task_section
    # Log in to Firm User/Client Account
    login_to_app

    # From Home Dashboard, click on Tasks on the left nav menu
    within('.Sidebar') do
      click_on 'TASK'
    end

    within('.Sidebar') do
      click_on 'TASK'
    end

    page_refresh

    expect(page).to have_current_path('/all_tasks')

    # Click on + Task button
    page_refresh
    page.has_text?('+ Task')
    find('a', text: '+ Task').click

    # Select Task Type: Get a Signature
    task_div = find('.task-type-select').click
    task_div.find_all('div', text: 'Get a Signature').last.click

    # Select For Account: ABC Testing Inc.
    page.has_selector?('#react-select-8-input')
    for_account = find_by_id('react-select-8-input').click
    page.send_keys('abc testing inc')
    page.has_text?('ABC Testing Inc.')
    page.send_keys(:enter)


    # Select For Contact: Adnan QA QA
    page.has_selector?('#react-select-10-input')
    for_contact = find_by_id('react-select-10-input').click
    page.send_keys('adnan qa qa')
    page.has_text?('Adnan QA QA')
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

    wait_for_text(page, 'SELECT PARTNER')
    # Select Partner: [your employee account]
    page.has_selector?('#react-select-15-input')
    select_partner = find_by_id('react-select-15-input').click
    page.send_keys('adnan ghaffar')
    page.has_text?('Adnan Ghaffar')
    page.send_keys(:enter)

    # Put in an amount in Fees field
    fill_in 'fees', with: 400

    # Fill in Subject Line field
    page.has_selector?('#react-select-14-input')
    subject = find_by_id('react-select-14-input').click
    page.send_keys('Audit - Accounts Receivable')
    page.send_keys(:enter)

    # Click on + Create Task button
    click_on 'Create Task'

    # User should see a success banner confirmation that the task is created and will be redirected back to Tasks List view.
    expect(page).to have_current_path('/all_tasks')
    verify_signature_task_created
    page.current_path
  end

  def verify_signature_task_created
    # Verify a loading animation displays
    page.has_css?('#loading')

    page.has_text?('TASK NAME')
    page.has_text?('ASSIGNED TO')
    page.has_text?('ACCOUNT')
    page.has_text?('OWNER')
    page.has_text?('DUE DATE')
    page.has_text?('LAST ACTIVITY AT')

    sleep(3)
    page.has_selector?('.tRow')
    table_body = find_all('.tRow').last

    first_row = table_body.find_all('.row')[0].text

    # The Task Type label should be visible on top of the subject line of the task you created.
    task_label = first_row.split("\n")[0]
    subject = first_row.split("\n")[1]
    expect(task_label).to eq("Get a Signature")
    expect(subject).to eq("Audit - Accounts Receivable")
    page.current_path
  end

  def create_task_from_account_infocus
    # Log in to Firm User/Client Account
    login_to_app

    # From Home Dashboard, click on Accounts from Left Nav menu
    within('.Sidebar') do
      click_on 'ACCOUNT'
    end
    sleep(3)
    page_refresh

    expect(page).to have_current_path('/accounts')

    # Verify a loading animation displays
    page.has_css?('#loading')

    # Search for ABC Testing Inc
    search_bar = find_by_id('account-search')
    search_bar.send_keys('ABC Testing Inc')
    page.has_css?('#loading')

    sleep(3)
    # Click on ABC Testing Inc
    page.has_selector?('.tRow')
    table_body = find_all('.tRow').last

    first_row = table_body.find_all('.row')[0].click

    # Verify a loading animation displays
    page.has_css?('#loading')
    page.has_text?('Timeline')

    # Click on In Focus tab
    page.has_text?('In Focus')
    click_button 'In Focus'
    # find('button', text: 'In Focus').click
    # find_all('button.nav-link')[2].click

    sleep(3)
    # Scroll down to Clients tasks section and click on + Task button
    find_all('button', text: 'Task')[1].click

    page.has_selector?('.modal-dialog')
    task_modal = find('.modal-dialog')
    within task_modal do
      # Select Task Type: To Do
      task_div = find('.task-type-select').click
      task_div.find_all('div', text: 'To Do').last.click

      # Select For Employee: [your employee account]
      page.has_selector?('#react-select-8-input')
      for_employee = find_by_id('react-select-8-input').click
      page.send_keys('adnan ghaffar')
      page.has_text?('Adnan Ghaffar')
      page.send_keys(:enter)

      # Fill in Subject Line field
      page.has_selector?('#react-select-13-input')
      subject = find_by_id('react-select-13-input').click
      page.send_keys('Task - From Account In Focus')
      page.send_keys(:enter)

      # Click on Create Task button
      click_on 'Create Task'
    end
    verify_task_from_account_infocus_created
  end

  def verify_task_from_account_infocus_created
    # From Home Dashboard, click on Tasks on the left nav menu
    within('.Sidebar') do
      click_on 'TASK'
    end

    expect(page).to have_current_path('/all_tasks')

    # Verify a loading animation displays
    page.has_css?('#loading')

    page.has_text?('TASK NAME')
    page.has_text?('ASSIGNED TO')
    page.has_text?('ACCOUNT')
    page.has_text?('OWNER')
    page.has_text?('DUE DATE')
    page.has_text?('LAST ACTIVITY AT')

    sleep(3)
    page.has_selector?('.tRow')
    table_body = find_all('.tRow').last

    first_row = table_body.find_all('.row')[0].text

    # The Task Type label should be visible on top of the subject line of the task you created.
    task_label = first_row.split("\n")[0]
    subject = first_row.split("\n")[1]
    expect(task_label).to eq("To Do")
    expect(subject).to eq("Task - From Account In Focus")
    page.current_path
  end

  def create_task_from_accounts
    # Click on ABC Testing Inc
    click_link 'ABC Testing Inc.'
    sleep(3)
    page_refresh
    # Click on Tasks tab
    click_button "Tasks"
    sleep(3)
    # Click on + Task button
    page.has_text?('+ Task')
    click_button '+ Task'

    # Select Task Type: To Do
    find_all('.select-custom-class').first.click
    find_by_id('react-select-2-option-2').click

    # Select For Employee: [your employee account]
    find_by_id('react-select-8-input').click
    page.send_keys('Adnan')
    page.send_keys(:tab)

    # Fill in Subject Line field
    find_by_id('react-select-13-input').click
    page.send_keys('Testing')
    page.send_keys(:tab)

    # Click on Create Task button
    click_on "Create Task"
    page.current_path
  end

  def create_task_from_contacts
    sleep(3)
    page_refresh
    # Search for "UAT Mail, QA Test" and click on it
    find_by_id('contact-search').click
    send_keys('UAT Mail')
    page.has_text?('UAT Mail')
    find_all('.row')[1].click

    # Click on Tasks tab
    click_button "Tasks"

    # Click on + Task button
    page.has_text?('+ Task')
    click_button '+ Task'

    # Select Task Type: To Do
    find_all('.select-custom-class').first.click
    find_by_id('react-select-2-option-2').click

    # Select For Employee: [your employee account]
    find_by_id('react-select-8-input').click
    page.send_keys('Adnan')
    page.send_keys(:tab)

    # Fill in Subject Line field
    find_by_id('react-select-13-input').click
    page.send_keys('Testing')
    page.send_keys(:tab)

    # Click on Create Task button
    click_on "Create Task"
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
