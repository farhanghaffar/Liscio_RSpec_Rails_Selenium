require_relative './base_page'
require_relative './login_page'

class InboxPage < BasePage
  def go_to_inbox
    login_to_app
    within('.Sidebar') do
      click_on 'INBOX'
    end
  end

  def go_to_accounts
    login_to_app
    within('.Sidebar') do
      click_on 'ACCOUNTS'
    end
  end

  def create_new_filter(filter)
    delete_if_filter_already_exists(filter)

    page.has_text?('My Messages')
    find_button('My Messages').click
    click_on 'Create Custom View'

    within('.modal-dialog') do
      fill_in 'name', with: filter

      dropdowns = find_all('.cstPopupShow')
      accounts = dropdowns.first
      accounts.click

      account_input_field = fill_in 'recipientValue', with: 'al'
      page.has_text?('AAlpha 2002')
      account_input_field.send_keys(:enter)
      click_on 'Save'
    end
  end

  def ensure_custom_filter_exist(filter)
    page.has_text?(filter.upcase)
    main_div = find_all('.filterGroup').last
    button = main_div.find('button')
    expect(button.text).to eq(filter.upcase)
  end

  def delete_filter(filter, selected)
    text = selected ? filter : 'My Messages'
    find_button(text, wait: 10).click
    click_on filter, wait: 10

    page.has_selector?('.filterGroup')
    #  click on edit button
    within('.filterGroup') do
      click_link
    end

    within('.modal-dialog') do
      #  click on delete button
      find('.icon-delete-small', wait: 10).click
    end

    click_on 'Yes', wait: 10
  end

  def edit_custome_filter_name(previous_filter_name, updated_filter_name)
    #  click on edit button
    page.has_selector?('.filterGroup')
    within('.filterGroup') do
      click_link
    end
    within('.modal-dialog') do
      fill_in 'name', with: updated_filter_name
    end
    click_on 'Save'
  end

  def send_a_reply
    message = create_a_random_message
    login_page.logout
    go_to_inbox

    # In messages, verify recipient sees the email subject
    wait_for_text(page, message)

    # Click on the message, verify the email body displays
    find('span', text: message).click

    # Click on the reply field
    find('.form-group').click
    iframe = find_all('iframe[id^="tiny-react_"]').last
    within_frame(iframe) do
      page.has_selector?('#tinymce')
      find_by_id('tinymce').click

      # Enter a random email reply string
      page.send_keys('Random Relpy')
      page.send_keys(:tab)
    end

    # Click on send button
    click_on "Send", visible: true
    page.current_path
  end

  def disabled_save_button
    go_to_inbox

    # Click on "+ Create Custom View"
    page.has_text?('My Messages')
    find_button('My Messages').click
    click_on 'Create Custom View'

    # Verify the "Create View" modal displays
    within('.modal-dialog') do
      # Click on the "Save" button
      click_on 'Save'
    end

    # Verify "Enter View Name" error message displays
    wait_for_text(page, 'Enter View Name')
    page.current_path
  end

  def close_create_view_modal
    go_to_inbox

    # Click on "+ Create Custom View"
    page.has_text?('My Messages')
    find_button('My Messages').click
    click_on 'Create Custom View'

    modal_selector = '.modal-dialog'
    # Verify the "Create View" modal displays
    expect(page).to have_selector(modal_selector)

    # Click on the "x" button
    find('.close').click

    # Verify the "Create View" modal no longer displays
    expect(page).not_to have_selector(modal_selector)
    page.current_path
  end

  def cancel_create_view_modal
    go_to_inbox

    # Click on "+ Create Custom View"
    page.has_text?('My Messages')
    find_button('My Messages').click
    click_on 'Create Custom View'

    modal_selector = '.modal-dialog'
    # Verify the "Create View" modal displays
    expect(page).to have_selector(modal_selector)
    sleep(3)

    # Click on the "Cancel" button
    within('.modal-dialog') do
      click_on 'Cancel'
    end

    # Verify the "Create View" modal no longer displays
    expect(page).not_to have_selector(modal_selector)
    page.current_path
  end

  def edit_a_view
    go_to_inbox

    # Create a filter with a name "QA-FILTER"
    create_new_filter('QA-FILTER')

    # Click on the edit icon next to the new or previously selected view name
    wait_for_text(page, 'QA-FILTER')
    page.has_selector?('.filterGroup')
    within('.filterGroup') do
      click_link
    end

    # Verify an "Edit View" modal displays
    # Edit the prefilled name of the view name "QA-FILTER 2"
    within('.modal-dialog') do
      fill_in 'name', with: ''
      fill_in 'name', with: 'QA-FILTER 2'
    end

    # Click on the "Save" button and the "Edit View" modal no longer displays
    click_on 'Save'

    # Verify "View updated successfully" toast displays
    wait_for_text(page, 'View updated successfully')

    # Verify the current view name changes to the edited view name
    wait_for_text(page, 'QA-FILTER 2')

    # Delete filter for uniqueness
    delete_filter('QA-FILTER 2', true)
    page.current_path
  end

  def close_edit_modal
    go_to_inbox

    # Create a filter with a name "QA-FILTER"
    create_new_filter('QA-FILTER')

    # Click on the edit icon next to the new or previously selected view name
    wait_for_text(page, 'QA-FILTER')
    page.has_selector?('.filterGroup')
    within('.filterGroup') do
      click_link
    end

    # Click on the edit button
    edit_modal_selector = '.modal-dialog'

    # Verify the "Edit View" modal displays
    expect(page).to have_selector(edit_modal_selector)

    # Click on the "x" button
    find('.close').click

    # Verify the "Edit View" modal no longer displays
    expect(page).not_to have_selector(edit_modal_selector)

    # Delete filter for uniqueness
    delete_filter('QA-FILTER', true)
    page.current_path
  end

  def cancel_edit_modal
    go_to_inbox

    # Create a filter with a name "QA-FILTER"
    create_new_filter('QA-FILTER')

    # Click on the edit icon next to the new or previously selected view name
    wait_for_text(page, 'QA-FILTER')
    page.has_selector?('.filterGroup')
    within('.filterGroup') do
      click_link
    end

    # Click on the edit button
    edit_modal_selector = '.modal-dialog'

    # Verify the "Edit View" modal displays
    expect(page).to have_selector(edit_modal_selector)

    # Click on the "Cancel" button
    within('.modal-dialog') do
      click_on 'Cancel'
    end

    # Verify the "Edit View" modal no longer displays
    expect(page).not_to have_selector(edit_modal_selector)

    # Delete filter for uniqueness
    delete_filter('QA-FILTER', true)
    page.current_path
  end

  def delete_custom_view
    go_to_inbox

    # Create a filter with a name "QA-FILTER"
    create_new_filter('QA-FILTER')

    # Click on the edit icon next to the new or previously selected view name
    wait_for_text(page, 'QA-FILTER')
    page.has_selector?('.filterGroup')
    within('.filterGroup') do
      click_link
    end

    # Click on the edit button
    edit_modal_selector = '.modal-dialog'

    # Verify the "Edit View" modal displays
    expect(page).to have_selector(edit_modal_selector)

    # Click on the "Cancel" button
    within('.modal-dialog') do
      click_on 'Cancel'
    end

    # Verify the "Edit View" modal no longer displays
    expect(page).not_to have_selector(edit_modal_selector)

    # Delete filter for uniqueness
    delete_filter('QA-FILTER', true)
    page.current_path
  end

  def close_delete_view
    go_to_inbox

    # Create a filter with a name "QA-FILTER"
    create_new_filter('QA-FILTER')

    # Click on the edit icon next to the new or previously selected view name
    wait_for_text(page, 'QA-FILTER')
    page.has_selector?('.filterGroup')
    within('.filterGroup') do
      click_link
    end

    within('.modal-dialog') do
      #  click on delete button
      find('.icon-delete-small', wait: 10).click
    end

    wait_for_text(page, 'You are about to delete this selected view.')
    click_on 'No', wait: 10

    within('.modal-dialog') do
      #  click on delete button
      find('.icon-delete-small', wait: 10).click
    end

    wait_for_text(page, 'You are about to delete this selected view.')

    click_on 'Yes', wait: 10
    wait_for_text(page, 'View deleted successfully')

    page.current_path
  end

  def close_delete_view_modal
    go_to_inbox

    # Create a filter with a name "QA-FILTER"
    create_new_filter('QA-FILTER')

    # Click on the edit icon next to the new or previously selected view name
    sleep(3)
    wait_for_text(page, 'QA-FILTER')
    page.has_selector?('.filterGroup')
    within('.filterGroup') do
      click_link
    end

    # Click on the edit button
    edit_modal_selector = '.modal-dialog'

    # Verify the "Edit View" modal displays
    expect(page).to have_selector(edit_modal_selector)

    # Click on the "Cancel" button
    within('.modal-dialog') do
      click_on 'Cancel'
    end

    # Verify the "Edit View" modal no longer displays
    expect(page).not_to have_selector(edit_modal_selector)

    page.has_selector?('.filterGroup')
    #  click on edit button
    within('.filterGroup') do
      click_link
    end

    within('.modal-dialog') do
      #  click on delete button
      find('.icon-delete-small', wait: 10).click
    end

    click_on 'No', wait: 10
    sleep(0.5)

    click_on 'Cancel'
    delete_filter('QA-FILTER', true)
    page.current_path
  end

  def all_messages_view
    go_to_inbox

    page.has_text?("All")

    find('button[data-testid="inbox__all_messages"]').click
    page.current_path
  end

  def close_and_cancel_modal
    go_to_inbox

    click_link '+ Message'
    within('.modal-dialog') do
      find('button[data-testid="close_modal"]').click
    end

    page.current_path
  end

  def close_and_cancel_modal_inbox
    go_to_inbox

    find('a[data-testid="inbox__create_message"]').click
    within('.modal-dialog') do
      find('button[data-testid="close_modal"]').click
    end

    page.current_path
  end

  def view_sent_messages
    go_to_accounts

    find_all('.row')[2].click
    find('button[data-testid="inbox__infocus"]').click
    page.has_text?('This page highlights outstanding action items for this account.')

    find('button[data-testid="inbox__messages"]').click

    page.current_path
  end

  def mark_message_thread
    go_to_inbox

    sleep 3
    page.has_text?('Last Activity At')
    find_all('i.icon-more').first.click

    page.send_keys(:arrow_down)
    page.send_keys(:arrow_up)
    page.send_keys(:enter)
    page.current_path
  end

  private

  def delete_if_filter_already_exists(filter)
    page.has_text?('My Messages')
    find_button('My Messages').click
    inbox_selector = 'div[data-testid="sidebar__inbox"]'

    if page.has_text?(filter)
      wait_for_selector(inbox_selector)
      find(inbox_selector).click
      sleep 3
      delete_filter(filter, false)
    else
      wait_for_selector(inbox_selector)
      find(inbox_selector).click
    end
  end

  def create_a_random_message
    login_to_app_as_automation_qa

    inbox_selector = 'div[data-testid="sidebar__inbox"'
    wait_for_selector(inbox_selector)
    find(inbox_selector).click

    wait_for_text(page, '+ Message')
    click_link '+ Message'
    time_stamp = Time.now.to_i
    subject = "Message_#{time_stamp}"

    within('.modal-dialog') do
      find('a[data-testid="onFocusButton"]').click

      page.has_selector?('div[data-value]')
      recipient = fill_in 'messageRecipient', with: 'adnan ghaffar'
      # Verify the recipient's name displays in the TO field
      page.has_text?('Adnan Ghaffar')
      recipient.send_keys(:enter)

      click_on 'Ok'

      # Verify various subject displays
      page.has_selector?('labelValue')

      # Verify the number subjects begin to filter based on the first letter typed ("H")
      subject_div = find_all('.labelValue')[1].click
      page.send_keys(subject)
      page.send_keys(:tab)

      page.has_selector?('iframe')
      iframe = find('iframe')
      within_frame iframe do
        # Verify "Saving" displays
        body_div = find_by_id('tinymce').click

        # Verify the message description displays
        body_div.send_keys("body")
      end

      click_on 'Send'
    end
    subject
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
