require_relative './base_page'
require_relative './login_page'

class BulkActionsPage < BasePage
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
    sleep 3
    page_refresh
  end

  def goto_invite_app_from_bulk_action
    login_to_app

    within('.Sidebar') do
      find('span', text: 'BULK ACTIONS').click
    end
    sleep(2)
    div = find('div[role="menu"]')
    within div do
      page.has_text?('Invite to Download App')
      div.find('div[role="menuitem"]', text: 'Invite to Download App').click
    end
    sleep 3
    page_refresh
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
    sleep 3
    page_refresh
  end

  def goto_invite_to_liscio_from_bulk_action
    login_to_app

    within('.Sidebar') do
      find('span', text: 'BULK ACTIONS').click
    end
    sleep(2)
    div = find('div[role="menu"]')
    within div do
      page.has_text?('Invite to Liscio')
      div.find('div[role="menuitem"]', text: 'Invite to Liscio').click
    end
    sleep 3
    page_refresh
  end

  def goto_send_edoc_from_bulk_action
    login_to_app

    within('.Sidebar') do
      find('span', text: 'BULK ACTIONS').click
    end
    sleep(2)
    div = find('div[role="menu"]')
    within div do
      page.has_text?('Send eDocs')
      div.find('div[role="menuitem"]', text: 'Send eDocs').click
    end
    sleep 3
    page_refresh
  end

  def goto_reassign_to_new_user_from_bulk_action
    login_to_app

    within('.Sidebar') do
      find('span', text: 'BULK ACTIONS').click
    end
    sleep(2)
    div = find('div[role="menu"]')
    within div do
      page.has_text?('Reassign Task Owner')
      find('div[role="menuitem"]', text: 'Reassign Task Owner').click
    end
    sleep 3
    page_refresh
  end

  def filter_via_entity_type
    click_on "SELECT ENTITY"
    find_all('.checkbox')[1].click
    find_all('.checkbox')[2].click

    find_all('.form-control').first.click
    page.current_path
  end

  def filter_entity_type_download_app
    click_on "SELECT ENTITY"
    find_all('.checkbox')[1].click
    find_all('.checkbox')[2].click

    click_on "Search"
    page.current_path
  end

  def filter_entity_contact
    find_all('.form-control').first.click
    page.send_keys("QA")
    click_on "Search"
    page.current_path
  end

  def send_an_invite_to_user
    find_all('.checkbox')[2].click
    click_on "Next Step"
    click_on "Send Invitation"
    page.current_path
  end

  def send_an_invite_to_several
    find_all('.checkbox')[2].click
    find_all('.checkbox')[3].click
    click_on "Next Step"
    click_on "Send Invitation"
    page.current_path
  end

  def filter_via_relationship
    click_on "SELECT RELATIONSHIP"
    find_all('.checkbox').first.click

    find_all('.form-control').first.click
    page.current_path
  end

  def check_account_owner
    find_all('.checkbox').first.click

    find_all('.form-control').first.click
    page.current_path
  end

  def filter_via_account_search
    find_all('.form-control').first.click
    page.send_keys("Bob")

    click_on "Search"
    page.current_path
  end

  def clear_all_filters
    click_on "SELECT ENTITY"
    find_all('.checkbox')[1].click
    find('.icon-close2.label-small').click
    page.current_path
  end

  def filter_list_of_users_via_account_search
    # From Home Dashboard, click on Bulk actions
    # Click on Send Message
    goto_new_message_from_bulk_action

    # Click on Search Account field
    input_selector = 'input[type="text"]'
    wait_for_selector(input_selector)
    account_field = find(input_selector)
    account_field.click

    # Type 'ABC'
    account_field.send_keys('ABC')

    # Click SEARCH
    find('button', text: 'SEARCH').click
    wait_for_loading_animation
    sleep(3)

    filtered_users = find_all('.tdBtn').first.text
    expect(filtered_users).to include('abc')
    page.current_path
  end

  def filter_list_of_users_via_account_owner_checkbox
    # From Home Dashboard, click on Bulk actions
    # Click on Send Message
    goto_new_message_from_bulk_action

    # Check the Account owner? box
    wait_for_text(page, 'Account owner?')
    find('span', text: 'Account owner?').click

    # Click on SEARCH
    find('button', text: 'SEARCH').click
    wait_for_loading_animation

    filter = find('div.badge-filter').text
    expect(filter).to eq('Account Owner')
    page.current_path
  end

  def clear_all_filters_new_message_screen
    # From Home Dashboard, click on Bulk actions
    # Click on Send Message
    goto_new_message_from_bulk_action

    # Click on Select Entity field
    find('button[data-toggle="dropdown"]', text: 'SELECT ENTITY').click

    # Select Individual and Sole Proprietorship
    find_all('span.dropdown-item', text: 'Individual').first.click
    find_all('span.dropdown-item', text: 'Sole Proprietorship').first.click

    # Click on SEARCH
    find('button', text: 'SEARCH').click
    wait_for_loading_animation

    filter = find('div.select-filter-list').text
    expect(filter).to include('Individual')
    expect(filter).to include('Sole Proprietorship')

    # Click on X Clear all
    wait_for_text(page, 'Clear All')
    find('button', text: 'Clear All').click

    page.current_path
  end

  def send_an_invite_to_user_to_liscio
    # From Home Dashboard, click on Bulk actions
    # Click on Invite to Liscio
    goto_invite_to_liscio_from_bulk_action

    # Select one user from the list that you want to send an invite to
    find_all('.checkbox')[2].click

    # Click on Next step button
    click_on "Next Step"

    # Click on Send Invitation button
    click_on "Send Invites"

    wait_for_text(page, 'Invitation will be sent shortly')
    page.current_path
  end

  def filter_via_entity_type_on_invite_screen
    # From Home Dashboard, click on Bulk actions
    # Click on Invite to Liscio
    goto_invite_to_liscio_from_bulk_action

    # Click on Select Entity field
    find('button[data-toggle="dropdown"]', text: 'SELECT ENTITY').click

    # Select Individual and Sole Proprietorship
    find_all('span.dropdown-item', text: 'Individual').first.click
    find_all('span.dropdown-item', text: 'Sole Proprietorship').first.click

    # Click on SEARCH
    find('button', text: 'SEARCH').click
    wait_for_loading_animation

    filter = find('div.select-filter-list').text
    expect(filter).to include('Individual')
    expect(filter).to include('Sole Proprietorship')
    page.current_path
  end

  def filter_via_client_status
    # Employees with Client status set to Invited
    user = set_employee_with_client_status_set_to_invited

    # From Home Dashboard, click on Bulk actions
    # Click on Invite to Liscio
    within('.Sidebar') do
      find('span', text: 'BULK ACTIONS').click
    end
    sleep(2)
    div = find('div[role="menu"]')
    within div do
      page.has_text?('Invite to Liscio')
      div.find('div[role="menuitem"]', text: 'Invite to Liscio').click
    end
    sleep 3
    page_refresh

    # Click on Select Status field
    find('button[data-toggle="dropdown"]', text: 'SELECT STATUS').click

    # Select Invited
    find_all('span.dropdown-item', text: 'Invited').first.click

    # Click on SEARCH
    find('button', text: 'SEARCH').click
    wait_for_loading_animation

    filter = find('div.select-filter-list').text
    expect(filter).to include('Invited')

    email = user.split("\n")[1]
    expect(page).to have_content(email)
    page.current_path
  end

  def filter_list_of_users_via_contact_search
    # From Home Dashboard, click on Bulk actions
    # Click on Invite to Liscio
    goto_invite_to_liscio_from_bulk_action

    # Click on Search contact field
    input_selector = 'input[type="text"]'
    wait_for_selector(input_selector)
    account_field = find(input_selector)
    account_field.click

    # Type 'QA'
    account_field.send_keys('QA')

    # Click SEARCH
    find('button', text: 'SEARCH').click
    wait_for_loading_animation

    sleep(2)
    filtered_users = find_all('.tdBtn').first.text
    expect(filtered_users).to include('QA')
    page.current_path
  end

  def clear_all_filters_on_invite_screen
    # From Home Dashboard, click on Bulk actions
    # Click on Invite to Liscio
    goto_invite_to_liscio_from_bulk_action

    # Click on Select Status field
    find('button[data-toggle="dropdown"]', text: 'SELECT STATUS').click

    # Select Invited
    find_all('span.dropdown-item', text: 'Invited').first.click

    # Click on SEARCH
    find('button', text: 'SEARCH').click
    wait_for_loading_animation

    filter = find('div.select-filter-list').text
    expect(filter).to include('Invited')

    # Click on X Clear all
    wait_for_text(page, 'Clear All')
    find('button', text: 'Clear All').click

    # Click SEARCH
    find('button', text: 'SEARCH').click
    wait_for_loading_animation

    page.current_path
  end

  def export_bulk_contact_list_as_csv
    # From Home Dashboard, click on Bulk actions
    # Click on Invite to Liscio
    goto_invite_to_liscio_from_bulk_action

    # Click on Export icon on the upper right corner
    find('.icon-download2').click

    page.current_path
  end

  def send_edoc_to_user
    # From Home Dashboard, click on Bulk actions
    # Click on Send eDocs
    goto_send_edoc_from_bulk_action

    # Select one user from the list that you want to send the eDocs to
    selected_user = find_all('.tdBtn')[0].text
    find_all('.checkbox')[2].click

    # Click on Next step button
    click_on "Next Step"
    # Fill in Agreement Title field
    fill_in 'agreementTitle', with: 'My Custom Title'
    iframe = find('iframe[id^="tiny-react_"]')
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('This is just a test message.')
      page.send_keys(:tab)
    end

    # Click on Templates link under &Attachments* section
    click_on 'Templates'

    # Select template to use
    wait_for_selector('.modal-dialog')
    wait_for_selector('.tdBtn')
    template = find_all('.tdBtn')[0]
    template.click
    template_text = template.text
    template_name = template_text.split("\n").first
    page.has_text?(template_name)

    # Click on Next Step button
    click_on 'Next Step'

    # Click on Send eDocs button
    click_on 'Send eDocs'

    expect(page).to have_content('eDocs will be sent shortly')
    page.current_path
  end

  def send_edoc_to_multiple_users
    # From Home Dashboard, click on Bulk actions
    # Click on Send eDocs
    goto_send_edoc_from_bulk_action

    expect(page).to have_current_path('/bulkesign')
    # Select multiple users from the list that you want to send the eDocs to
    page.has_selector?('.checkbox')

    selected_user_one = find_all('.tdBtn')[0].text
    find_all('.checkbox')[2].click
    selected_user_two = find_all('.tdBtn')[1].text
    find_all('.checkbox')[3].click

    # Click on Next step button
    click_on "Next Step"

    # Fill in Agreement Title field
    fill_in 'agreementTitle', with: 'My Custom Title'
    iframe = find('iframe[id^="tiny-react_"]')
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('This is just a test message.')
      page.send_keys(:tab)
    end

    # Click on Templates link under &Attachments* section
    click_on 'Templates'

    # Select template to use
    wait_for_selector('.modal-dialog')
    wait_for_selector('.tdBtn')
    template = find_all('.tdBtn')[0]
    template.click
    template_text = template.text
    template_name = template_text.split("\n").first
    page.has_text?(template_name)

    # Click on Next Step button
    click_on 'Next Step'

    # Click on Send eDocs button
    click_on 'Send eDocs'

    expect(page).to have_content('eDocs will be sent shortly')
    page.current_path
  end

  def filter_list_of_users_via_entity_type
    # From Home Dashboard, click on Bulk actions
    # Click on Send eDocs
    goto_send_edoc_from_bulk_action

    # Click on Select Entity field
    find('button[data-toggle="dropdown"]', text: 'SELECT ENTITY').click

    # Select Individual and Sole Proprietorship
    find_all('span.dropdown-item', text: 'Individual').first.click
    find_all('span.dropdown-item', text: 'Sole Proprietorship').first.click

    # Click on SEARCH
    find('button', text: 'SEARCH').click
    wait_for_loading_animation

    filter = find('div.select-filter-list').text
    expect(filter).to include('Individual')
    expect(filter).to include('Sole Proprietorship')
    page.current_path
  end

  def filter_employee_list_via_relationship_types
    # From Home Dashboard, click on Bulk actions
    # Click on Send eDocs
    goto_send_edoc_from_bulk_action

    # Click on Select Relationship field
    find('button[data-toggle="dropdown"]', text: 'SELECT RELATIONSHIP').click

    # Select Primary from the drop down
    find_all('span.dropdown-item', text: 'Primary').first.click

    # Click on SEARCH
    find('button', text: 'SEARCH').click
    wait_for_loading_animation

    filter = find('div.select-filter-list').text
    expect(filter).to include('Primary')
    page.current_path
  end

  def filter_via_account_owner_on_send_edocs
    # From Home Dashboard, click on Bulk actions
    # Click on Send eDocs
    goto_send_edoc_from_bulk_action

    # Check the Account owner? box
    wait_for_text(page, 'Account owner?')
    find('span', text: 'Account owner?').click

    # Click on SEARCH
    find('button', text: 'SEARCH').click
    wait_for_loading_animation

    filter = find('div.badge-filter').text
    expect(filter).to eq('Account Owner')
    page.current_path
  end

  def filter_via_contact_on_invite_page
    # From Home Dashboard, click on Bulk actions
    # Click on Invite to Download Apps
    goto_invite_app_from_bulk_action

    input_selector = 'input[type="text"]'
    wait_for_selector(input_selector)
    contact_field = find(input_selector)
    contact_field.click

    # Type 'QA'
    contact_field.send_keys('QA')

    # Click SEARCH
    find('button', text: 'SEARCH').click
    wait_for_loading_animation

    sleep(2)
    filtered_users = find_all('.tdBtn').first.text
    expect(filtered_users).to include('qa')
    page.current_path
  end

  def remove_people_from_list_in_doing_bulk_action
    # From Home Dashboard, click on Bulk actions
    # Click on Send eDocs
    goto_invite_app_from_bulk_action
    expect(page).to have_current_path('/bulkdownload')

    # Select several people from the list that you want to send an invite to
    page.has_selector?('.checkbox')

    selected_user_one = find_all('.tdBtn')[0].text
    find_all('.checkbox')[2].click
    selected_user_two = find_all('.tdBtn')[1].text
    find_all('.checkbox')[3].click
    selected_user_three = find_all('.tdBtn')[2].text
    find_all('.checkbox')[4].click

    # Click on Next step button
    click_on 'Next Step'
    expect(page).to have_content('Showing 1 to 3 of 3 entries')

    # Click on the Delete icon on the right corner of the row of person you want to remove from the list
    find('button[data-testid="delete0"]').click
    expect(page).to have_content('Showing 1 to 2 of 2 entries')

    # Click on Send Invitation button
    click_on "Send Invitation"
    page.current_path
  end

  def delete_from_list
    # Select several people from the list that you want
    page.has_selector?('.checkbox')

    selected_user_one = find_all('.tdBtn')[0].text
    find_all('.checkbox')[2].click
    selected_user_two = find_all('.tdBtn')[1].text
    find_all('.checkbox')[3].click
    selected_user_three = find_all('.tdBtn')[2].text
    find_all('.checkbox')[4].click

    # Click on Next step button
    click_on 'Next Step'

    page.current_path
  end

  def preview_individuals_changes_per_doc
    # Select several people from the list that you want
    page.has_selector?('.checkbox')

    selected_user_one = find_all('.tdBtn')[0].text
    find_all('.checkbox')[2].click

    # Click on Next step button
    click_on 'Next Step'
    page.current_path
  end

  def filter_employee_list
    # Click on Select Relationship field
    find('button[data-toggle="dropdown"]', text: 'SELECT RELATIONSHIP').click

    # Select Primary from the drop down
    find_all('span.dropdown-item', text: 'Primary').first.click

    # Click on SEARCH
    find('button', text: 'SEARCH').click
    wait_for_loading_animation

    filter = find('div.select-filter-list').text
    expect(filter).to include('Primary')
    page.current_path
  end

  def filter_employee_via_recurring
    goto_reassign_to_new_user_from_bulk_action
    sleep 3

    find('label[for="isRecurring"]').click
    page.current_path
  end

  def clear_filters_recurring
    goto_reassign_to_new_user_from_bulk_action

    find('label[for="isRecurring"]').click
    find('a[data-testid="clear-all-button"]').click
    page.current_path
  end

  def delete_certain_from_recurring
    goto_invite_to_liscio_from_bulk_action
    sleep 3

    # Select several people from the list that you want to send an invite to
    page.has_selector?('.checkbox')

    selected_user_one = find_all('.tdBtn')[0].text
    find_all('.checkbox')[2].click
    selected_user_two = find_all('.tdBtn')[1].text
    find_all('.checkbox')[3].click
    selected_user_three = find_all('.tdBtn')[2].text
    find_all('.checkbox')[4].click

    # Click on Next step button
    click_on 'Next Step'
    expect(page).to have_content('Showing 1 to 3 of 3 entries')

    # Click on the Delete icon on the right corner of the row of person you want to remove from the list
    find('button[data-testid="delete0"]').click
    page.current_path
  end

  def delete_certain_from_app
    goto_invite_to_liscio_from_bulk_action
    sleep 3

    # Select several people from the list that you want to send an invite to
    page.has_selector?('.checkbox')

    selected_user_one = find_all('.tdBtn')[0].text
    find_all('.checkbox')[2].click
    selected_user_two = find_all('.tdBtn')[1].text
    find_all('.checkbox')[3].click
    selected_user_three = find_all('.tdBtn')[2].text
    find_all('.checkbox')[4].click

    # Click on Next step button
    click_on 'Next Step'
    expect(page).to have_content('Showing 1 to 3 of 3 entries')

    # Click on the Delete icon on the right corner of the row of person you want to remove from the list
    find('button[data-testid="delete0"]').click
    page.current_path
  end

  def clear_all_filters_on_send_edoc_screen
    # From Home Dashboard, click on Bulk actions
    # Click on Send eDocs
    goto_send_edoc_from_bulk_action

    # Click on Select Relationship field
    find('button[data-toggle="dropdown"]', text: 'SELECT RELATIONSHIP').click

    # Select Primary from the drop down
    find_all('span.dropdown-item', text: 'Primary').first.click

    # Click on Select Entity field
    find('button[data-toggle="dropdown"]', text: 'SELECT ENTITY').click

    # Select Individual
    find_all('span.dropdown-item', text: 'Individual').first.click

    # Click on SEARCH
    find('button', text: 'SEARCH').click
    wait_for_loading_animation

    filter = find('div.select-filter-list').text
    expect(filter).to include('Primary')
    expect(filter).to include('Individual')

    # Click on X Clear all
    wait_for_text(page, 'Clear All')
    find('button', text: 'Clear All').click

    filter = find('div.select-filter-list').text
    expect(filter).not_to include('Primary')
    expect(filter).not_to include('Individual')
    page.current_path
  end

  def reassign_to_new_user
    # From Home Dashboard, click on Bulk actions
    # Click on Reassign Task Owner
    goto_reassign_to_new_user_from_bulk_action

    expect(page).to have_current_path('/bulkreassign')
    page.has_selector?('.checkbox')

    # Select one task from the list that you want to reassign
    table = find_all('.tRow')[1]
    first_task = table.find_all('.row')[0]
    first_task.click

    # Click on Next step button
    click_on "Next Step"

    # Click on the Reassign task to new owner: dropdown
    input = find_all('input').first
    input.click

    # Search for the person you would like to assign it to and select it
    'adnan gha'.chars.each do |char|
      input.send_keys(char)
      sleep(0.1)
    end
    wait_for_text(page, 'Adnan Ghaffar')
    input.send_keys(:enter)

    # Click Reassign Task Owner button
    click_on 'Reassign Task Owner'
    expect(page).to have_content('Task will be reassigned shortly')
    page.current_path
  end

  def reassign_multiple_tasks_at_once
    # From Home Dashboard, click on Bulk actions
    # Click on Reassign Task Owner
    goto_reassign_to_new_user_from_bulk_action

    expect(page).to have_current_path('/bulkreassign')
    page.has_selector?('.checkbox')

    # Select multiple tasks from the list that you want to reassign
    table = find_all('.tRow')[1]
    first_task = table.find_all('.row')[0]
    first_task.click
    second_task = table.find_all('.row')[1]
    second_task.click

    # Click on Next step button
    click_on "Next Step"

    # Click on the Reassign task to new owner: dropdown
    input = find_all('input').first
    input.click

    # Search for the person you would like to assign it to and select it
    input.send_keys('adnan gha')
    wait_for_text(page, 'Adnan Ghaffar')
    input.send_keys(:enter)

    # Click Reassign Task Owner button
    click_on 'Reassign Task Owner'
    expect(page).to have_content('Task will be reassigned shortly')
    page.current_path
  end

  def filter_via_task_assignee
    # From Home Dashboard, click on Bulk actions
    # Click on Reassign Task Owner
    goto_reassign_to_new_user_from_bulk_action

    expect(page).to have_current_path('/bulkreassign')
    page.has_selector?('.checkbox')

    # Click on My Tasks field
    find('button[type="button"]', text: 'MY TASKS').click

    # Select Tasks assigned to me
    find_all('a.dropdown-item', text: 'Tasks assigned to me').first.click

    filter = find('div.select-filter-list').text
    expect(filter).to include('Tasks assigned to me')
    page.current_path
  end

  def filter_via_task_type
    # From Home Dashboard, click on Bulk actions
    # Click on Reassign Task Owner
    goto_reassign_to_new_user_from_bulk_action

    expect(page).to have_current_path('/bulkreassign')
    page.has_selector?('.checkbox')

    # Click on Type field
    find('button[type="button"]', text: 'TYPE').click

    # Select Get a Signature and To do
    find('.checkbox', text: 'Get a Signature').click

    filter = find('div.select-filter-list').text
    expect(filter).to include('Get a Signature')

    page.current_path
  end

  def filter_employee_list_via_task_owner
    # From Home Dashboard, click on Bulk actions
    # Click on Reassign Task Owner
    goto_reassign_to_new_user_from_bulk_action

    expect(page).to have_current_path('/bulkreassign')
    page_refresh
    sleep 3
    page.has_selector?('.checkbox')

    # Click on Owner field
    find('button[type="button"]', text: 'OWNER').click

    # Search for the name of the owner of tasks you would like to view
    fill_in 'recipientValue', with: 'adnan gha'

    # Select the name of that person from results list
    find('button[type="button"]', text: 'Adnan Ghaffar').click

    filter = find('div.select-filter-list').text
    expect(filter).to include('Adnan Ghaffar')
    page.current_path
  end

  def filter_via_account_on_reassign_screen
    # From Home Dashboard, click on Bulk actions
    # Click on Reassign Task Owner
    goto_reassign_to_new_user_from_bulk_action

    expect(page).to have_current_path('/bulkreassign')
    page.has_selector?('.checkbox')

    # Click on Search field
    find('button[type="button"]', text: 'ACCOUNT').click

    # Type 'ABC'
    fill_in 'recipientValue', with: 'ABC'

    # Select Account from the search result list
    find('button[type="button"]', text: 'ABC Testing Inc.').click

    filter = find('div.select-filter-list').text
    expect(filter).to include('ABC Testing Inc.')
    page.current_path
  end

  def filter_via_task_assigned_to
    # From Home Dashboard, click on Bulk actions
    # Click on Reassign Task Owner
    goto_reassign_to_new_user_from_bulk_action

    expect(page).to have_current_path('/bulkreassign')
    page.has_selector?('.checkbox')

    # Click on Assigned to field
    find('button[type="button"]', text: 'ASSIGNED TO').click

    # Search for the name of the assignee of tasks you would like to view
    fill_in 'recipientValue', with: 'adnan gha'

    # Select the name of that person from results list
    find_all('button[type="button"]', text: 'Adnan Ghaffar').first.click

    filter = find('div.select-filter-list').text
    expect(filter).to include('Adnan Ghaffar')
    page.current_path
  end
  def send_get_signature_request
    # Pick first user from the list
    selected_user = find_all('.tdBtn')[0].text
    find_all('.checkbox')[1].click

    # Click on Next step button
    click_on "Next Step"
    page.current_path
  end

  def send_get_signature_request_to_multiple
    # Select several people from the list that you want to send an invite to
    page.has_selector?('.checkbox')

    selected_user_one = find_all('.tdBtn')[0].text
    find_all('.checkbox')[2].click
    selected_user_two = find_all('.tdBtn')[1].text
    find_all('.checkbox')[3].click

    # Click on Next step button
    click_on "Next Step"
    page.current_path
  end

  def send_bulk_messages
    goto_new_message_from_bulk_action

    find('button[data-toggle="dropdown"]', text: 'SELECT RELATIONSHIP').click

    find_all('span.dropdown-item', text: 'Primary').first.click

    find('button', text: 'SEARCH').click
    wait_for_loading_animation

    filter = find('div.select-filter-list').text
    expect(filter).to include('Primary')
    page.current_path
  end

  def send_bulk_edocs
    goto_send_edoc_from_bulk_action

    selected_user = find_all('.tdBtn')[0].text
    find_all('.checkbox')[2].click

    click_on "Next Step"
    fill_in 'agreementTitle', with: 'My Custom Title'
    iframe = find('iframe[id^="tiny-react_"]')
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('This is just a test message.')
      page.send_keys(:tab)
    end

    click_on 'Templates'

    wait_for_selector('.modal-dialog')
    wait_for_selector('.tdBtn')
    template = find_all('.tdBtn')[0]
    template.click
    template_text = template.text
    template_name = template_text.split("\n").first
    page.has_text?(template_name)

    click_on 'Next Step'

    click_on 'Send eDocs'

    expect(page).to have_content('eDocs will be sent shortly')
    page.current_path
  end

  def send_bulk_edocs_to_multiple_templates
    goto_send_edoc_from_bulk_action

    selected_user = find_all('.tdBtn')[0].text
    find_all('.checkbox')[2].click

    click_on "Next Step"
    fill_in 'agreementTitle', with: 'My Custom Title'
    iframe = find('iframe[id^="tiny-react_"]')
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click
      page.send_keys('This is just a test message.')
      page.send_keys(:tab)
    end

    click_on 'Templates'
    page.current_path
  end

  private

  def set_employee_with_client_status_set_to_invited
    goto_invite_to_liscio_from_bulk_action

    # Pick first user from the list
    selected_user = find_all('.tdBtn')[0].text
    find_all('.checkbox')[1].click

    # Click on Next step button
    click_on "Next Step"

    # Click on Send Invitation button
    click_on "Send Invites"

    wait_for_text(page, 'Invitation will be sent shortly')
    selected_user
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
