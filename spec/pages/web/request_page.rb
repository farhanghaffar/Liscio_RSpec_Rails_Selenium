require_relative './base_page'
require_relative './login_page'

class RequestPage < BasePage
  def go_to_requests
    login_to_app
    click_on_sidebar_request_menu
  end

  def go_to_requests_from_add_new
    login_to_app
    add_new_selector = 'div[data-testid="sidebar__add_new"]'
    wait_for_selector(add_new_selector)

    # In Landing Page, click the + Add New button at the left sidebar
    find(add_new_selector).click

    # Click Request in the dropdown menu
    request_selector = 'div[data-testid="request"]'
    wait_for_selector(request_selector)
    find(request_selector).click
  end

  def ensure_progress_is_updated
    request_title = create_a_request_document_for_client
    login_as_automation_qa
    fill_questionnaire(request_title)
    # ensure_the_progress_is_updated
    # page.current_path
  end

  def ensure_user_sends_questionnaire_request
    # Under Create new Request window, click the + Blank Request button
    modal_selector = 'div[role="dialog"]'
    wait_for_selector(modal_selector)
    modal = find(modal_selector)
    modal_heading = find('h1')
    wait_for_text(modal_heading, 'CREATE A NEW REQUEST')

    # Click on + Blank Request
    add_icon_selector = 'svg[data-testid="AddIcon"]'
    wait_for_selector(add_icon_selector)
    modal.find(add_icon_selector).click

    expect(page).to have_current_path(%r{/requests})

    # In Authoring Tool window, enter the title/name of the questionnaire in Questionnaire Title field
    time_stamp = Time.now.to_i
    request_title = "request_#{time_stamp}"
    fill_in 'title', with: ''
    fill_in 'title', with: request_title

    # Enter description under Description field.
    request_description = "description_#{time_stamp}"
    fill_in 'description', with: request_title

    # Create a Section under the New Section
    find_all('input')[1].click
    page.send_keys('My Questionnaire')
    page.send_keys(:enter)
    sleep(2)

    # To add question, click the + then choose Y/N as question type
    plus_icon_selector = 'svg[data-testid="AddCircleIcon"]'
    wait_for_selector(plus_icon_selector)
    find(plus_icon_selector).click

    # Subsection, Y/N, Short answer, File upload
    find('li[role="menuitem"]', text: "Y/N").click

    expect(page).to have_current_path(%r{/requests})

    sleep(1)
    find_all('input')[1].click
    page.send_keys('What is your startup called?')
    page.send_keys(:tab)

    sleep(2)

    # Click Preview and Send Button
    click_on 'Preview and Send'
    expect(page).to have_current_path(%r{/dispatch})

    # Select Assignee icon at bottom of the screen
    find('span', text: 'Select Assignee').click

    # Click the dropdown list in Recipient field then select a contact as a recipient
    find_all('div[data-value]').first.click
    page.send_keys('automation qa')
    page.has_text?('Automation QA')
    page.send_keys(:enter)

    # Click the dropdown list in Account field then select an account
    sleep(0.5)
    # Go to next field
    page.send_keys(:tab)
    page.send_keys('abc testing')
    page.has_text?('ABC Testing Inc.')
    page.send_keys(:enter)

    click_on 'Ok'

    # Select the Select Date icon then choose a future date, day, year and month in date selector box
    choose_a_future_date

    # Click Send button
    click_on 'Send'

    page.current_path
  end

  def ensure_user_answers_yes_no_question
    go_to_requests_from_add_new
    # Under Create new Request window, click the + Blank Request button
    modal_selector = 'div[role="dialog"]'
    wait_for_selector(modal_selector)
    modal = find(modal_selector)
    modal_heading = find('h1')
    wait_for_text(modal_heading, 'CREATE A NEW REQUEST')

    # Click on + Blank Request
    add_icon_selector = 'svg[data-testid="AddIcon"]'
    wait_for_selector(add_icon_selector)
    modal.find(add_icon_selector).click

    expect(page).to have_current_path(%r{/requests})

    # In Authoring Tool window, enter the title/name of the questionnaire in Questionnaire Title field
    time_stamp = Time.now.to_i
    request_title = "request_#{time_stamp}"
    fill_in 'title', with: ''
    fill_in 'title', with: request_title

    # Enter description under Description field.
    request_description = "description_#{time_stamp}"
    fill_in 'description', with: request_title

    # Create a Section under the New Section
    find_all('input')[1].click
    page.send_keys('My Questionnaire')
    page.send_keys(:tab)
    sleep(2)

    # To add question, click the + then choose Y/N as question type
    plus_icon_selector = 'svg[data-testid="AddCircleIcon"]'
    wait_for_selector(plus_icon_selector)
    find(plus_icon_selector).click

    # In Authoring Tool window, click the + and verify the question options: Y/N, Short answer and File Upload

    # Subsection, Y/N, Short answer, File upload
    expect(page).to have_content('Subsection')
    expect(page).to have_content('Y/N')
    expect(page).to have_content('Short answer')
    expect(page).to have_content('File upload')

    # Choose the Y/N as question type
    find('li[role="menuitem"]', text: "Y/N").click
    find_all('input')[1].click
    page.send_keys('Testing Yes/No Question Type')
    page.send_keys(:tab)
    sleep(2)

    # Click Preview and Send Button
    click_on 'Preview and Send'

    expect(page).to have_current_path(%r{/dispatch})

    radio_group_selector = 'div[role="radiogroup"]'
    wait_for_selector(radio_group_selector)
    radio_group = find(radio_group_selector)

    # Verify Radio buttons are rendered
    page.has_selector?(radio_group_selector)
    expect(page).to have_content('Yes')
    expect(page).to have_content('No')
    page.current_path
  end

  def ensure_user_answers_the_questionnaire
    request_document_title = create_questionnaire_with_yes_no_question
    login_as_automation_qa
    fill_the_questionnaire(request_document_title)
    page.current_path
  end

  def answser_all_questions
    request_document_title = create_questionnaire_with_questions
    login_as_automation_qa
    fill_all_the_answers(request_document_title)
    page.current_path
  end

  def add_assignee_with_recipient_and_account
    request_title = create_questionnaire_with_questions
    page.current_path
  end

  def cancel_adding_assignee
    go_to_requests_from_add_new
    # Under Create new Request window, click the + Blank Request button
    modal_selector = 'div[role="dialog"]'
    wait_for_selector(modal_selector)
    modal = find(modal_selector)
    modal_heading = find('h1')
    wait_for_text(modal_heading, 'CREATE A NEW REQUEST')

    # Click on + Blank Request
    add_icon_selector = 'svg[data-testid="AddIcon"]'
    wait_for_selector(add_icon_selector)
    modal.find(add_icon_selector).click

    expect(page).to have_current_path(%r{/requests})

    # In Authoring Tool window, enter the title/name of the questionnaire in Questionnaire Title field
    time_stamp = Time.now.to_i
    request_title = "request_#{time_stamp}"
    fill_in 'title', with: ''
    fill_in 'title', with: request_title

    # Enter description under Description field.
    request_description = "description_#{time_stamp}"
    fill_in 'description', with: request_title

    # Create a Section under the New Section
    find_all('input')[1].click
    page.send_keys('My Questionnaire')
    page.send_keys(:tab)
    sleep(2)

    # To add question, click the + then choose Y/N as question type
    plus_icon_selector = 'svg[data-testid="AddCircleIcon"]'
    wait_for_selector(plus_icon_selector)
    find(plus_icon_selector).click

    # Choose the Y/N as question type
    find('li[role="menuitem"]', text: "Y/N").click
    find_all('input')[1].click
    page.send_keys('Testing Yes/No Question Type')
    page.send_keys(:tab)
    sleep(2)

    find(plus_icon_selector).click

    # Choose the Short answer as question type
    find('li[role="menuitem"]', text: "Short answer").click
    find_all('input')[1].click
    page.send_keys('How are you doing?')
    page.send_keys(:tab)
    sleep(2)

    find(plus_icon_selector).click

    # Choose the Y/N as question type
    find('li[role="menuitem"]', text: "Y/N").click
    find_all('input')[1].click
    page.send_keys('All question added?')
    page.send_keys(:tab)
    sleep(2)

    # Click Preview and Send Button
    click_on 'Preview and Send'
    expect(page).to have_current_path(%r{/dispatch})

    # All questions are rendered
    expect(page).to have_content('Testing Yes/No Question Type')
    expect(page).to have_content('How are you doing?')
    expect(page).to have_content('All question added?')

    find('span', text: 'Select Assignee').click
    find_all('div[data-value]').first.click

    page.send_keys('automation qa')
    page.has_text?('Automation QA')
    page.send_keys(:enter)

    sleep(0.5)
    # Go to next field
    page.send_keys(:tab)
    page.send_keys('abc testing')
    page.has_text?('ABC Testing Inc.')
    page.send_keys(:enter)

    click_on 'Close'
    page.current_path
  end

  def create_questionnaire_request_from_blank_template
    login_to_app_as_employee

    # In Landing page, click the Requests page
    click_on_sidebar_request_menu

    # Under Request page, click the + Request button.
    wait_for_text(page, 'Request')
    find('button', text: 'Request').click

    # Under Create new Request window, click the + Blank Request button
    modal_selector = 'div[role="dialog"]'
    wait_for_selector(modal_selector)
    modal = find(modal_selector)
    modal_heading = find('h1')
    wait_for_text(modal_heading, 'CREATE A NEW REQUEST')

    # Click on + Blank Request
    add_icon_selector = 'svg[data-testid="AddIcon"]'
    wait_for_selector(add_icon_selector)
    modal.find(add_icon_selector).click

    expect(page).to have_current_path(%r{/requests})

    time_stamp = Time.now.to_i
    request_title = "request_#{time_stamp}"
    description_title = "description_#{time_stamp}"
    fill_in 'title', with: ''
    fill_in 'title', with: request_title
    fill_in 'description', with: description_title

    # Create a Section under the New Section
    find_all('input')[1].click
    page.send_keys('Pitch here')
    page.send_keys(:enter)
    sleep(2)

    plus_icon_selector = 'svg[data-testid="AddCircleIcon"]'
    wait_for_selector(plus_icon_selector)
    find(plus_icon_selector).click

    # Subsection, Y/N, Short answer, File upload
    find('li[role="menuitem"]', text: "Short answer").click

    expect(page).to have_current_path(%r{/requests})

    sleep(1)
    find_all('input')[1].click
    page.send_keys('What is your startup called?')
    page.send_keys(:tab)
    sleep(2)

    # Click Preview and Send Button
    click_on 'Preview and Send'

    expect(page).to have_current_path(%r{/dispatch})

    find('span', text: 'Select Assignee').click
    find_all('div[data-value]').first.click

    page.send_keys('automation qa')
    page.has_text?('Automation QA')
    page.send_keys(:enter)

    sleep(0.5)
    # Go to next field
    page.send_keys(:tab)
    page.send_keys('abc testing')
    page.has_text?('ABC Testing Inc.')
    page.send_keys(:enter)

    click_on 'Ok'
    sleep(0.5)

    choose_a_future_date

    click_on 'Send'
    page.current_path
  end

  def create_questionnaire_from_pre_built_template
    login_to_app_as_employee

    # In Landing page, click the Requests page
    click_on_sidebar_request_menu

    # Under Request page, click the + Request button.
    wait_for_text(page, 'Request')
    find('button', text: 'Request').click

    # Create new request* window display on screen
    # Under Create new Request window, click the + Blank Request button
    modal_selector = 'div[role="dialog"]'
    wait_for_selector(modal_selector)
    modal = find(modal_selector)
    modal_heading = find('h1')
    wait_for_text(modal_heading, 'CREATE A NEW REQUEST')

    # Wait for templates to load
    wait_for_text(modal, 'Or start from a template')
    modal.find_all('img').first.click

    find('span', text: 'Select Assignee').click
    find_all('div[data-value]').first.click

    page.send_keys('automation qa')
    page.has_text?('Automation QA')
    page.send_keys(:enter)

    sleep(0.5)
    # Go to next field
    page.send_keys(:tab)
    page.send_keys('abc testing')
    page.has_text?('ABC Testing Inc.')
    page.send_keys(:enter)

    click_on 'Ok'
    sleep(0.5)

    choose_a_future_date

    click_on 'Send'
    page.current_path
  end

  def create_questionnaire_from_add_new
    create_questionnaire_with_questions
    page.current_path
  end

  def close_dropdown_window
    login_to_app
    add_new_selector = 'div[data-testid="sidebar__add_new"]'
    wait_for_selector(add_new_selector)

    # In Landing page, Click the + ADD NEW, verify dropdown menu will appear.
    dropdown_selector = 'div[data-testid="add_new__dropdown"]'
    find(add_new_selector).click

    expect(page).to have_selector(dropdown_selector)
    page_refresh
    expect(page).not_to have_selector(dropdown_selector)
    page.current_path
  end

  def close_create_new_request
    login_to_app_as_employee

    # In Landing page, click the Requests page
    click_on_sidebar_request_menu

    # Under Request page, click the + Request button.
    wait_for_text(page, 'Request')
    find('button', text: 'Request').click

    # Under Create new Request window, click the + Blank Request button
    modal_selector = 'div[role="dialog"]'
    wait_for_selector(modal_selector)
    modal = find(modal_selector)
    modal_heading = find('h1')
    wait_for_text(modal_heading, 'CREATE A NEW REQUEST')

    # Click <BACK button to close the window.
    close_icon_selector = 'svg[data-testid="CloseIcon"]'
    wait_for_selector(close_icon_selector)
    find(close_icon_selector).click
    sleep(0.5)

    # Firm user should be able to close the "Create new Request" screen.
    expect(page).not_to have_selector('div[role="dialog"]')
    page.current_path
  end

  def add_a_section_in_questionnaire
    login_to_app_as_employee

    # In Landing page, click the Requests page
    click_on_sidebar_request_menu

    # Under Request page, click the + Request button.
    wait_for_text(page, 'Request')
    find('button', text: 'Request').click

    # Under Create new Request window, click the + Blank Request button
    modal_selector = 'div[role="dialog"]'
    wait_for_selector(modal_selector)
    modal = find(modal_selector)
    modal_heading = find('h1')
    wait_for_text(modal_heading, 'CREATE A NEW REQUEST')

    # Click on + Blank Request
    add_icon_selector = 'svg[data-testid="AddIcon"]'
    wait_for_selector(add_icon_selector)
    modal.find(add_icon_selector).click

    expect(page).to have_current_path(%r{/requests})

    # In Authoring Tool window, enter the title/name of the questionnaire in Questionnaire Title field
    time_stamp = Time.now.to_i
    request_title = "request_#{time_stamp}"
    fill_in 'title', with: ''
    fill_in 'title', with: request_title

    # Enter description under Description field.
    request_description = "description_#{time_stamp}"
    fill_in 'description', with: request_title

    # Create a Section under the New Section
    # Add section by clicking the + Add sub section from the left side panel.
    find_all('input')[1].click
    page.send_keys('My Questionnaire')
    page.send_keys(:enter)
    sleep(2)

    # To add question, click the + then choose Y/N as question type
    plus_icon_selector = 'svg[data-testid="AddCircleIcon"]'
    wait_for_selector(plus_icon_selector)
    find(plus_icon_selector).click

    # Choose the Y/N as question type
    find('li[role="menuitem"]', text: "Y/N").click
    find_all('input')[1].click
    page.send_keys('Is your account is activated yet?')
    page.send_keys(:tab)

    sleep(0.5)
    find(plus_icon_selector).click

    # Choose the Y/N as question type
    find('li[role="menuitem"]', text: "Y/N").click
    find_all('input')[1].click

    # Click Preview and Send Button
    click_on 'Preview and Send'

    # Firm user should be able to add section in a questionnaire.
    wait_for_text(page, 'Is your account is activated yet?')
    page.current_path
  end

  def add_short_question_to_a_questionnaire
    login_to_app_as_employee

    # In Landing page, click the Requests page
    click_on_sidebar_request_menu

    # Under Request page, click the + Request button.
    wait_for_text(page, 'Request')
    find('button', text: 'Request').click

    # Under Create new Request window, click the + Blank Request button
    modal_selector = 'div[role="dialog"]'
    wait_for_selector(modal_selector)
    modal = find(modal_selector)
    modal_heading = find('h1')
    wait_for_text(modal_heading, 'CREATE A NEW REQUEST')

    # Click on + Blank Request
    add_icon_selector = 'svg[data-testid="AddIcon"]'
    wait_for_selector(add_icon_selector)
    modal.find(add_icon_selector).click

    expect(page).to have_current_path(%r{/requests})

    # An Authoring Tool window, enter the title/name of the questionnaire in Questionnaire Title field
    time_stamp = Time.now.to_i
    request_title = "request_#{time_stamp}"
    fill_in 'title', with: ''
    fill_in 'title', with: request_title

    # Enter description under Description field.
    request_description = "description_#{time_stamp}"
    fill_in 'description', with: request_title

    # Create a Section under the New Section
    find_all('input')[1].click
    page.send_keys('My questionnaire to test short questions')
    page.send_keys(:enter)
    sleep(2)

    # To add question, click the + then choose Y/N as question type
    plus_icon_selector = 'svg[data-testid="AddCircleIcon"]'
    wait_for_selector(plus_icon_selector)
    find(plus_icon_selector).click

    # In Authoring Tool window, click the + and verify the question options: Y/N, Short answer and File Upload.
    find('li[role="menuitem"]', text: "Y/N").click
    find_all('input')[1].click
    page.send_keys('Testing Yes/No Question Type')
    page.send_keys(:tab)
    sleep(0.5)

    find(plus_icon_selector).click

    find('li[role="menuitem"]', text: "File upload").click
    find_all('input')[1].click
    page.send_keys('Upload your proposal?')
    page.send_keys(:tab)
    sleep(0.5)

    find(plus_icon_selector).click

    # Choose the Short answer as question type
    find('li[role="menuitem"]', text: "Short answer").click
    find_all('input')[1].click
    page.send_keys('Do you want to keep your data private?')
    page.send_keys(:tab)
    sleep(0.5)

    # Click Preview and Send Button
    click_on 'Preview and Send'
    expect(page).to have_current_path(%r{/dispatch})

    # All questions are rendered
    expect(page).to have_content('My questionnaire to test short questions')
    expect(page).to have_content('Testing Yes/No Question Type')
    expect(page).to have_content('Upload your proposal?')
    expect(page).to have_content('Do you want to keep your data private?')
    page.current_path
  end

  def add_file_upload_question_to_a_questionnaire
    login_to_app_as_employee

    # In Landing page, click the Requests page
    click_on_sidebar_request_menu

    # Under Request page, click the + Request button.
    wait_for_text(page, 'Request')
    find('button', text: 'Request').click

    # Under Create new Request window, click the + Blank Request button
    modal_selector = 'div[role="dialog"]'
    wait_for_selector(modal_selector)
    modal = find(modal_selector)
    modal_heading = find('h1')
    wait_for_text(modal_heading, 'CREATE A NEW REQUEST')

    # Click on + Blank Request
    add_icon_selector = 'svg[data-testid="AddIcon"]'
    wait_for_selector(add_icon_selector)
    modal.find(add_icon_selector).click

    expect(page).to have_current_path(%r{/requests})

    # An Authoring Tool window, enter the title/name of the questionnaire in Questionnaire Title field
    time_stamp = Time.now.to_i
    request_title = "request_#{time_stamp}"
    fill_in 'title', with: ''
    fill_in 'title', with: request_title

    # Enter description under Description field.
    request_description = "description_#{time_stamp}"
    fill_in 'description', with: request_title

    # Create a Section under the New Section
    find_all('input')[1].click
    page.send_keys('My questionnaire to test short questions')
    page.send_keys(:enter)
    sleep(2)

    # To add question, click the + then choose Y/N as question type
    plus_icon_selector = 'svg[data-testid="AddCircleIcon"]'
    wait_for_selector(plus_icon_selector)
    find(plus_icon_selector).click

    # In Authoring Tool window, click the + and verify the question options: Y/N, Short answer and File Upload.
    find('li[role="menuitem"]', text: "Y/N").click
    find_all('input')[1].click
    page.send_keys('Testing Yes/No Question Type')
    page.send_keys(:tab)
    sleep(0.5)

    find(plus_icon_selector).click

    find('li[role="menuitem"]', text: "File upload").click
    find_all('input')[1].click
    page.send_keys('Upload your proposal?')
    page.send_keys(:tab)
    sleep(0.5)

    # Click Preview and Send Button
    click_on 'Preview and Send'
    expect(page).to have_current_path(%r{/dispatch})

    # All questions are rendered
    wait_for_text(page, 'My questionnaire to test short questions')
    wait_for_text(page, 'Testing Yes/No Question Type')
    wait_for_text(page, 'Upload your proposal?')
    page.current_path
  end

  def automatically_update_question_number
    login_to_app_as_employee

    # In Landing page, click the Requests page
    click_on_sidebar_request_menu

    # Under Request page, click the + Request button.
    wait_for_text(page, 'Request')
    find('button', text: 'Request').click

    # Under Create new Request window, click the + Blank Request button
    modal_selector = 'div[role="dialog"]'
    wait_for_selector(modal_selector)
    modal = find(modal_selector)
    modal_heading = find('h1')
    wait_for_text(modal_heading, 'CREATE A NEW REQUEST')

    # Click on + Blank Request
    add_icon_selector = 'svg[data-testid="AddIcon"]'
    wait_for_selector(add_icon_selector)
    modal.find(add_icon_selector).click

    expect(page).to have_current_path(%r{/requests})

    # An Authoring Tool window, enter the title/name of the questionnaire in Questionnaire Title field
    time_stamp = Time.now.to_i
    request_title = "request_#{time_stamp}"
    fill_in 'title', with: ''
    fill_in 'title', with: request_title

    # Enter description under Description field.
    request_description = "description_#{time_stamp}"
    fill_in 'description', with: request_title

    # Create a Section under the New Section
    find_all('input')[1].click
    page.send_keys('My questionnaire to test question numbering')
    page.send_keys(:enter)
    sleep(2)

    # To add question, click the + then choose Y/N as question type
    plus_icon_selector = 'svg[data-testid="AddCircleIcon"]'
    wait_for_selector(plus_icon_selector)
    find(plus_icon_selector).click

    # In Authoring Tool window, click the + and verify the question options: Y/N, Short answer and File Upload.
    find('li[role="menuitem"]', text: "Y/N").click
    find_all('input')[1].click
    page.send_keys('Testing first Yes/No Question Type')
    page.send_keys(:tab)
    sleep(0.5)

    find(plus_icon_selector).click

    find('li[role="menuitem"]', text: "File upload").click
    find_all('input')[1].click
    page.send_keys('Test: Upload your proposal?')
    page.send_keys(:tab)
    sleep(0.5)

    find(plus_icon_selector).click

    # Choose the Short answer as question type
    find('li[role="menuitem"]', text: "Short answer").click
    find_all('input')[1].click
    page.send_keys('Test: Do you want to keep your data private?')
    page.send_keys(:tab)
    sleep(0.5)

    # Click Preview and Send Button
    click_on 'Preview and Send'
    expect(page).to have_current_path(%r{/dispatch})

    # All questions are rendered
    wait_for_text(page, 'My questionnaire to test question numbering')
    wait_for_text(page, 'Testing first Yes/No Question Type')
    wait_for_text(page, 'Test: Upload your proposal?')
    wait_for_text(page, 'Test: Do you want to keep your data private?')
    wait_for_text(page, '1.')
    wait_for_text(page, '2.')
    wait_for_text(page, '3.')
    page.current_path
  end

  def add_a_condition_in_yes_no_question
    # In Landing Page, click the + Add New button at the left sidebar.
    # Click Request in the dropdown menu.
    go_to_requests_from_add_new

    # Under Create new Request window, click the + Blank Request button
    modal_selector = 'div[role="dialog"]'
    wait_for_selector(modal_selector)
    modal = find(modal_selector)
    modal_heading = find('h1')
    wait_for_text(modal_heading, 'CREATE A NEW REQUEST')

    # Click on + Blank Request
    add_icon_selector = 'svg[data-testid="AddIcon"]'
    wait_for_selector(add_icon_selector)
    modal.find(add_icon_selector).click

    expect(page).to have_current_path(%r{/requests})

    # In Authoring Tool window, enter the title/name of the questionnaire in Questionnaire Title field
    time_stamp = Time.now.to_i
    request_title = "request_#{time_stamp}"
    fill_in 'title', with: ''
    fill_in 'title', with: request_title

    # Enter description under Description field.
    request_description = "description_#{time_stamp}"
    fill_in 'description', with: request_title

    # Create a Section under the New Section
    find_all('input')[1].click
    page.send_keys('My questionnaire to test conditional questions')
    page.send_keys(:enter)
    sleep(2)

    # To add question, click the + then choose Y/N as question type
    plus_icon_selector = 'svg[data-testid="AddCircleIcon"]'
    wait_for_selector(plus_icon_selector)
    find(plus_icon_selector).click

    # Choose the Y/N as question type
    find('li[role="menuitem"]', text: "Y/N").click
    find_all('input')[1].click
    page.send_keys('Available for tomorrow?')
    page.send_keys(:tab)
    sleep(2)

    # Turn on the Conditions toggle.
    wait_for_selector('.MuiSwitch-root')
    find('.MuiSwitch-root').click

    # In the QUESTION field enter any text.
    conditional_question = find_by_id('1.1 input')
    conditional_question.click
    conditional_question.send_keys('Are you able to visit the site in the morning?')
    page.send_keys(:tab)
    sleep(0.5)

    # Click PREVIEW AND SEND button.
    click_on 'Preview and Send'
    expect(page).to have_current_path(%r{/dispatch})

    # All questions are rendered
    wait_for_text(page, 'My questionnaire to test conditional questions')
    wait_for_text(page, 'Available for tomorrow?')
    wait_for_text(page, 'Are you able to visit the site in the morning?')
    wait_for_text(page, '1.1')

    # Under REVIEW AND SEND screen, Click the Assignee icon then click the dropdown list in Recipient field.
    find('span', text: 'Select Assignee').click
    find_all('div[data-value]').first.click

    page.send_keys('automation qa')
    page.has_text?('Automation QA')
    page.send_keys(:enter)

    sleep(0.5)
    # Go to next field
    page.send_keys(:tab)
    page.send_keys('abc testing')
    page.has_text?('ABC Testing Inc.')
    page.send_keys(:enter)

    click_on 'Ok'

    sleep(1)
    choose_a_future_date

    click_on 'Send'
    expect(page).to have_current_path('/requests')
    page.current_path
  end

  def verify_assignee_option_is_enabled
    login_to_app_as_employee

    # In Landing page, click the Requests page
    click_on_sidebar_request_menu

    # Under Request page, click the + Request button.
    wait_for_text(page, 'Request')
    find('button', text: 'Request').click

    # Under Create new Request window, click the + Blank Request button
    modal_selector = 'div[role="dialog"]'
    wait_for_selector(modal_selector)
    modal = find(modal_selector)
    modal_heading = find('h1')
    wait_for_text(modal_heading, 'CREATE A NEW REQUEST')

    # Click on + Blank Request
    add_icon_selector = 'svg[data-testid="AddIcon"]'
    wait_for_selector(add_icon_selector)
    modal.find(add_icon_selector).click

    expect(page).to have_current_path(%r{/requests})

    # An Authoring Tool window, enter the title/name of the questionnaire in Questionnaire Title field
    time_stamp = Time.now.to_i
    request_title = "request_#{time_stamp}"
    fill_in 'title', with: ''
    fill_in 'title', with: request_title

    # Enter description under Description field.
    request_description = "description_#{time_stamp}"
    fill_in 'description', with: request_title

    # Create a Section under the New Section
    find_all('input')[1].click
    page.send_keys('My questionnaire to test assignee option')
    page.send_keys(:enter)
    sleep(2)

    # To add question, click the + then choose Y/N as question type
    plus_icon_selector = 'svg[data-testid="AddCircleIcon"]'
    wait_for_selector(plus_icon_selector)
    find(plus_icon_selector).click

    # In Authoring Tool window, click the + and verify the question options: Y/N, Short answer and File Upload.
    find('li[role="menuitem"]', text: "Y/N").click
    find_all('input')[1].click
    page.send_keys('Insert at least one question')
    page.send_keys(:tab)
    sleep(0.5)

    # Click Preview and Send Button
    click_on 'Preview and Send'
    expect(page).to have_current_path(%r{/dispatch})

    # All questions are rendered
    wait_for_text(page, 'My questionnaire to test assignee option')
    wait_for_text(page, 'Insert at least one question')

    find('span', text: 'Select Assignee').click

    wait_for_text(page, 'Recipient:')
    wait_for_text(page, 'Account:')
    wait_for_text(page, 'Account:')
    page.current_path
  end

  def verify_dialog_box_to_select_recipient_and_account
    login_to_app_as_employee

    # In Landing page, click the Requests page
    click_on_sidebar_request_menu

    # Under Request page, click the + Request button.
    wait_for_text(page, 'Request')
    find('button', text: 'Request').click

    # Under Create new Request window, click the + Blank Request button
    modal_selector = 'div[role="dialog"]'
    wait_for_selector(modal_selector)
    modal = find(modal_selector)
    modal_heading = find('h1')
    wait_for_text(modal_heading, 'CREATE A NEW REQUEST')

    # Click on + Blank Request
    add_icon_selector = 'svg[data-testid="AddIcon"]'
    wait_for_selector(add_icon_selector)
    modal.find(add_icon_selector).click

    expect(page).to have_current_path(%r{/requests})

    # An Authoring Tool window, enter the title/name of the questionnaire in Questionnaire Title field
    time_stamp = Time.now.to_i
    request_title = "request_#{time_stamp}"
    fill_in 'title', with: ''
    fill_in 'title', with: request_title

    # Enter description under Description field.
    request_description = "description_#{time_stamp}"
    fill_in 'description', with: request_title

    # Create a Section under the New Section
    find_all('input')[1].click
    page.send_keys('My questionnaire to test recipient and account selection')
    page.send_keys(:enter)
    sleep(2)

    # To add question, click the + then choose Y/N as question type
    plus_icon_selector = 'svg[data-testid="AddCircleIcon"]'
    wait_for_selector(plus_icon_selector)
    find(plus_icon_selector).click

    # In Authoring Tool window, click the + and verify the question options: Y/N, Short answer and File Upload.
    find('li[role="menuitem"]', text: "Y/N").click
    find_all('input')[1].click
    page.send_keys('Just a test question')
    page.send_keys(:tab)
    sleep(0.5)

    # Click Preview and Send Button
    click_on 'Preview and Send'
    expect(page).to have_current_path(%r{/dispatch})

    # All questions are rendered
    wait_for_text(page, 'My questionnaire to test recipient and account selection')
    wait_for_text(page, 'Just a test question')

    # Under Assignee click the dropdown Recipient and Account allows you to select contact and account.
    find('span', text: 'Select Assignee').click

    wait_for_text(page, 'Recipient:')
    wait_for_text(page, 'Account:')
    wait_for_text(page, 'Account:')

    find_all('div[data-value]').first.click

    page.send_keys('automation qa')
    page.has_text?('Automation QA')
    page.send_keys(:enter)

    sleep(0.5)
    # Go to next field
    page.send_keys(:tab)
    page.send_keys('abc testing')
    page.has_text?('ABC Testing Inc.')
    page.send_keys(:enter)

    click_on 'Ok'

    page.current_path
  end

  def select_liscio_contacts
    login_to_app_as_employee

    # In Landing page, click the Requests page
    click_on_sidebar_request_menu

    # Under Request page, click the + Request button.
    wait_for_text(page, 'Request')
    find('button', text: 'Request').click

    # Under Create new Request window, click the + Blank Request button
    modal_selector = 'div[role="dialog"]'
    wait_for_selector(modal_selector)
    modal = find(modal_selector)
    modal_heading = find('h1')
    wait_for_text(modal_heading, 'CREATE A NEW REQUEST')

    # Click on + Blank Request
    add_icon_selector = 'svg[data-testid="AddIcon"]'
    wait_for_selector(add_icon_selector)
    modal.find(add_icon_selector).click

    expect(page).to have_current_path(%r{/requests})

    # An Authoring Tool window, enter the title/name of the questionnaire in Questionnaire Title field
    time_stamp = Time.now.to_i
    request_title = "request_#{time_stamp}"
    fill_in 'title', with: ''
    fill_in 'title', with: request_title

    # Enter description under Description field.
    request_description = "description_#{time_stamp}"
    fill_in 'description', with: request_title

    # Create a Section under the New Section
    find_all('input')[1].click
    page.send_keys('My questionnaire to test recipient selection')
    page.send_keys(:enter)
    sleep(2)

    # To add question, click the + then choose Y/N as question type
    plus_icon_selector = 'svg[data-testid="AddCircleIcon"]'
    wait_for_selector(plus_icon_selector)
    find(plus_icon_selector).click

    # In Authoring Tool window, click the + and verify the question options: Y/N, Short answer and File Upload.
    find('li[role="menuitem"]', text: "Y/N").click
    find_all('input')[1].click
    page.send_keys('Just a test question')
    page.send_keys(:tab)
    sleep(0.5)

    # Click Preview and Send Button
    click_on 'Preview and Send'
    expect(page).to have_current_path(%r{/dispatch})

    # All questions are rendered
    wait_for_text(page, 'My questionnaire to test recipient selection')
    wait_for_text(page, 'Just a test question')

    find('span', text: 'Select Assignee').click

    wait_for_text(page, 'Recipient:')
    wait_for_text(page, 'Account:')

    find_all('div[data-value]').first.click

    page.send_keys('automation qa')
    page.has_text?('Automation QA')
    page.send_keys(:enter)

    sleep(0.5)

    page.current_path
  end

  def select_liscio_accounts
    login_to_app_as_employee

    # In Landing page, click the Requests page
    click_on_sidebar_request_menu

    # Under Request page, click the + Request button.
    wait_for_text(page, 'Request')
    find('button', text: 'Request').click

    # Under Create new Request window, click the + Blank Request button
    modal_selector = 'div[role="dialog"]'
    wait_for_selector(modal_selector)
    modal = find(modal_selector)
    modal_heading = find('h1')
    wait_for_text(modal_heading, 'CREATE A NEW REQUEST')

    # Click on +   Blank Request
    add_icon_selector = 'svg[data-testid="AddIcon"]'
    wait_for_selector(add_icon_selector)
    modal.find(add_icon_selector).click

    expect(page).to have_current_path(%r{/requests})

    # An Authoring Tool window, enter the title/name of the questionnaire in Questionnaire Title field
    time_stamp = Time.now.to_i
    request_title = "request_#{time_stamp}"
    fill_in 'title', with: ''
    fill_in 'title', with: request_title

    # Enter description under Description field.
    request_description = "description_#{time_stamp}"
    fill_in 'description', with: request_title

    # Create a Section under the New Section
    find_all('input')[1].click
    page.send_keys('My questionnaire to test account selection')
    page.send_keys(:enter)
    sleep(2)

    # To add question, click the + then choose Y/N as question type
    plus_icon_selector = 'svg[data-testid="AddCircleIcon"]'
    wait_for_selector(plus_icon_selector)
    find(plus_icon_selector).click

    # In Authoring Tool window, click the + and verify the question options: Y/N, Short answer and File Upload.
    find('li[role="menuitem"]', text: "Y/N").click
    find_all('input')[1].click
    page.send_keys('Just a test question')
    page.send_keys(:tab)
    sleep(0.5)

    # Click Preview and Send Button
    click_on 'Preview and Send'
    expect(page).to have_current_path(%r{/dispatch})

    # All questions are rendered
    wait_for_text(page, 'My questionnaire to test account selection')
    wait_for_text(page, 'Just a test question')

    find('span', text: 'Select Assignee').click

    wait_for_text(page, 'Recipient:')
    wait_for_text(page, 'Account:')

    find_all('div[data-value]').last.click

    page.send_keys('abc testing')
    page.has_text?('ABC Testing Inc.')
    page.send_keys(:enter)

    page.current_path
  end

  def all_account_as_recipient
    go_to_requests_from_add_new
    # Under Create new Request window, click the + Blank Request button
    modal_selector = 'div[role="dialog"]'
    wait_for_selector(modal_selector)
    modal = find(modal_selector)
    modal_heading = find('h1')
    wait_for_text(modal_heading, 'CREATE A NEW REQUEST')

    # Click on + Blank Request
    add_icon_selector = 'svg[data-testid="AddIcon"]'
    wait_for_selector(add_icon_selector)
    modal.find(add_icon_selector).click

    expect(page).to have_current_path(%r{/requests})

    # In Authoring Tool window, enter the title/name of the questionnaire in Questionnaire Title field
    time_stamp = Time.now.to_i
    request_title = "request_#{time_stamp}"
    fill_in 'title', with: ''
    fill_in 'title', with: request_title

    # Enter description under Description field.
    request_description = "description_#{time_stamp}"
    fill_in 'description', with: request_title
    sleep(2)

    # Create a Section under the New Section
    find_all('input')[1].click
    page.send_keys('My Questionnaire to test all recipients')
    page.send_keys(:tab)
    sleep(2)

    # To add question, click the + then choose Y/N as question type
    plus_icon_selector = 'svg[data-testid="AddCircleIcon"]'
    wait_for_selector(plus_icon_selector)
    find(plus_icon_selector).click

    # Choose the Y/N as question type
    find('li[role="menuitem"]', text: "Y/N").click
    find_all('input')[1].click
    page.send_keys('Testing Yes/No Question Type')
    page.send_keys(:tab)
    sleep(2)

    # Click Preview and Send Button
    click_on 'Preview and Send'
    expect(page).to have_current_path(%r{/dispatch})

    # All questions are rendered
    wait_for_text(page, 'My Questionnaire to test all recipients')
    wait_for_text(page, 'Testing Yes/No Question Type')

    find('span', text: 'Select Assignee').click

    wait_for_text(page, 'Recipient:')
    wait_for_text(page, 'Account:')

    find_all('div[data-value]').last.click

    page.send_keys('abc')
    page.has_text?('ABC Testing Inc.')
    page.has_text?('ABC Inc')

    page.current_path
  end

  def donot_add_assignee_without_selecting_recipient
    go_to_requests_from_add_new
    # Under Create new Request window, click the + Blank Request button
    modal_selector = 'div[role="dialog"]'
    wait_for_selector(modal_selector)
    modal = find(modal_selector)
    modal_heading = find('h1')
    wait_for_text(modal_heading, 'CREATE A NEW REQUEST')

    # Click on + Blank Request
    add_icon_selector = 'svg[data-testid="AddIcon"]'
    wait_for_selector(add_icon_selector)
    modal.find(add_icon_selector).click

    expect(page).to have_current_path(%r{/requests})

    # In Authoring Tool window, enter the title/name of the questionnaire in Questionnaire Title field
    time_stamp = Time.now.to_i
    request_title = "request_#{time_stamp}"
    fill_in 'title', with: ''
    fill_in 'title', with: request_title

    # Enter description under Description field.
    request_description = "description_#{time_stamp}"
    fill_in 'description', with: request_title

    # Create a Section under the New Section
    find_all('input')[1].click
    page.send_keys('My Questionnaire to test assignee without recipients')
    page.send_keys(:tab)
    sleep(2)

    # To add question, click the + then choose Y/N as question type
    plus_icon_selector = 'svg[data-testid="AddCircleIcon"]'
    wait_for_selector(plus_icon_selector)
    find(plus_icon_selector).click

    # Choose the Y/N as question type
    find('li[role="menuitem"]', text: "Y/N").click
    find_all('input')[1].click
    page.send_keys('Testing Yes/No Question Type')
    page.send_keys(:tab)
    sleep(2)

    # Click Preview and Send Button
    click_on 'Preview and Send'
    expect(page).to have_current_path(%r{/dispatch})

    # All questions are rendered
    expect(page).to have_content('My Questionnaire to test assignee without recipients')
    expect(page).to have_content('Testing Yes/No Question Type')

    find('span', text: 'Select Assignee').click
    find_all('div[data-value]').last.click

    # Account's field
    page.send_keys(:tab)
    page.send_keys('abc testing')
    page.has_text?('ABC Testing Inc.')
    page.send_keys(:enter)

    click_on 'Ok'

    # Firm user should not be able to add assignee to questionnaire template without selecting a Recipient
    wait_for_text(page, 'Select Assignee')
    page.current_path
  end

  def populate_account_automatically
    go_to_requests_from_add_new
    # Under Create new Request window, click the + Blank Request button
    modal_selector = 'div[role="dialog"]'
    wait_for_selector(modal_selector)
    modal = find(modal_selector)
    modal_heading = find('h1')
    wait_for_text(modal_heading, 'CREATE A NEW REQUEST')

    # Click on + Blank Request
    add_icon_selector = 'svg[data-testid="AddIcon"]'
    wait_for_selector(add_icon_selector)
    modal.find(add_icon_selector).click

    expect(page).to have_current_path(%r{/requests})

    # In Authoring Tool window, enter the title/name of the questionnaire in Questionnaire Title field
    time_stamp = Time.now.to_i
    request_title = "request_#{time_stamp}"
    fill_in 'title', with: ''
    fill_in 'title', with: request_title

    # Enter description under Description field.
    request_description = "description_#{time_stamp}"
    fill_in 'description', with: request_title
    sleep(2)

    # Create a Section under the New Section
    find_all('input')[1].click
    page.send_keys('My Questionnaire to test all population of account')
    page.send_keys(:tab)
    sleep(2)

    # To add question, click the + then choose Y/N as question type
    plus_icon_selector = 'svg[data-testid="AddCircleIcon"]'
    wait_for_selector(plus_icon_selector)
    find(plus_icon_selector).click

    # Choose the Y/N as question type
    find('li[role="menuitem"]', text: "Y/N").click
    find_all('input')[1].click
    page.send_keys('Testing Yes/No Question Type')
    page.send_keys(:tab)
    sleep(2)

    # Click Preview and Send Button
    click_on 'Preview and Send'
    expect(page).to have_current_path(%r{/dispatch})

    # All questions are rendered
    expect(page).to have_content('My Questionnaire to test all population of account')
    expect(page).to have_content('Testing Yes/No Question Type')

    find('span', text: 'Select Assignee').click
    find_all('div[data-value]').first.click

    'automation t'.chars.each { |char| page.send_keys(char) }
    page.has_text?('Automation Tester')
    page.send_keys(:enter)

    wait_for_text(page, '3 Mobiles') # Associated account for Automation Tester
    page.current_path
  end

  def add_assignee_to_template
    create_questionnaire_from_pre_built_template
  end

  def verify_due_date_is_enabled
    prepare_questionnaire_till_due_date
    choose_a_future_date
    page.current_path
  end

  def validate_default_value_of_date
    prepare_questionnaire_till_due_date

    choose_a_future_date

    tomorrow_date = (Date.today + 1).strftime("%m/%d/%Y")
    date_selected = find_all('input').last[:value]
    expect(date_selected).to eq(tomorrow_date)
    page.current_path
  end

  def add_due_date
    prepare_questionnaire_till_due_date
    choose_a_future_date
    page.current_path
  end

  def add_due_date_to_exisiting_template
    login_to_app_as_employee

    # In Landing page, click the Requests page
    click_on_sidebar_request_menu

    # Under Request page, click the + Request button.
    wait_for_text(page, 'Request')
    find('button', text: 'Request').click

    # Under Create new Request window, click the + Blank Request button
    modal_selector = 'div[role="dialog"]'
    wait_for_selector(modal_selector)
    modal = find(modal_selector)
    modal_heading = find('h1')
    wait_for_text(modal_heading, 'CREATE A NEW REQUEST')

    # Wait for templates to load
    wait_for_text(modal, 'Or start from a template')
    modal.find_all('img').first.click

    find('span', text: 'Select Assignee').click
    find_all('div[data-value]').first.click

    'automation q'.chars.each { |char| page.send_keys(char) }
    page.has_text?('Automation QA')
    page.send_keys(:enter)

    page.current_path
  end

  def select_only_liscio_recipient
    go_to_requests_from_add_new
    # Under Create new Request window, click the + Blank Request button
    modal_selector = 'div[role="dialog"]'
    wait_for_selector(modal_selector)
    modal = find(modal_selector)
    modal_heading = find('h1')
    wait_for_text(modal_heading, 'CREATE A NEW REQUEST')

    # Click on + Blank Request
    add_icon_selector = 'svg[data-testid="AddIcon"]'
    wait_for_selector(add_icon_selector)
    modal.find(add_icon_selector).click

    expect(page).to have_current_path(%r{/requests})

    # In Authoring Tool window, enter the title/name of the questionnaire in Questionnaire Title field
    time_stamp = Time.now.to_i
    request_title = "request_#{time_stamp}"
    fill_in 'title', with: ''
    fill_in 'title', with: request_title

    # Enter description under Description field.
    request_description = "description_#{time_stamp}"
    fill_in 'description', with: request_title
    sleep(2)

    # Create a Section under the New Section
    find_all('input')[1].click
    page.send_keys('My Questionnaire to test selction of recipient only')
    page.send_keys(:tab)
    sleep(2)

    # To add question, click the + then choose Y/N as question type
    plus_icon_selector = 'svg[data-testid="AddCircleIcon"]'
    wait_for_selector(plus_icon_selector)
    find(plus_icon_selector).click

    # Choose the Y/N as question type
    find('li[role="menuitem"]', text: "Y/N").click
    find_all('input')[1].click
    page.send_keys('Testing Yes/No Question Type')
    page.send_keys(:tab)
    sleep(2)

    # Click Preview and Send Button
    click_on 'Preview and Send'
    expect(page).to have_current_path(%r{/dispatch})

    # All questions are rendered
    expect(page).to have_content('My Questionnaire to test selction of recipient only')
    expect(page).to have_content('Testing Yes/No Question Type')

    find('span', text: 'Select Assignee').click
    find_all('div[data-value]').first.click

    'automation qa'.chars.each { |char| page.send_keys(char) }
    page.has_text?('Automation QA')
    page.send_keys(:enter)

    click_on 'Ok'

    page.current_path
  end

  def attempt_to_select_past_date
    login_to_app_as_employee

    # In Landing page, click the Requests page
    click_on_sidebar_request_menu

    # Under Request page, click the + Request button.
    wait_for_text(page, 'Request')
    find('button', text: 'Request').click

    # Under Create new Request window, click the + Blank Request button
    modal_selector = 'div[role="dialog"]'
    wait_for_selector(modal_selector)
    modal = find(modal_selector)
    modal_heading = find('h1')
    wait_for_text(modal_heading, 'CREATE A NEW REQUEST')

    # Wait for templates to load
    wait_for_text(modal, 'Or start from a template')
    modal.find_all('img').first.click

    find('span', text: 'Select Assignee').click
    find_all('div[data-value]').first.click

    'automation qa'.chars.each { |char| page.send_keys(char) }
    page.has_text?('Automation QA')
    page.send_keys(:enter)

    click_on 'Ok'

    page.current_path
  end

  def allow_firm_to_edit_existing_template
    # In Landing Page, click the + Add New button at the left sidebar
    # Click +Request in the dropdown menu
    go_to_requests_from_add_new

    # Create a new request window display on the screen
    modal_selector = 'div[role="dialog"]'
    wait_for_selector(modal_selector)
    modal = find(modal_selector)
    modal_heading = find('h1')

    # Verify options that the user may choose to create a new questionnaire
    add_icon_selector = 'svg[data-testid="AddIcon"]'
    wait_for_selector(add_icon_selector)

    # Choose from a list of pre-built questionnaire templates
    wait_for_text(modal, 'Or start from a template')

    # Click Edit Request in the ellipses on the upper right side
    ellipses_for_request_selector = 'svg[data-testid="MoreHorizIcon"]'
    wait_for_selector(ellipses_for_request_selector)
    modal.find_all(ellipses_for_request_selector).first.click
    find('span', text: 'Edit Template').click
    wait_for_loading_animation

    expect(page.current_path).to include('/requests/builder')

    page.current_path
  end

  def preview_added_questions
    go_to_requests_from_add_new
    # Under Create new Request window, click the + Blank Request button
    modal_selector = 'div[role="dialog"]'
    wait_for_selector(modal_selector)
    modal = find(modal_selector)
    modal_heading = find('h1')
    wait_for_text(modal_heading, 'CREATE A NEW REQUEST')

    # Click on + Blank Request
    add_icon_selector = 'svg[data-testid="AddIcon"]'
    wait_for_selector(add_icon_selector)
    modal.find(add_icon_selector).click

    expect(page).to have_current_path(%r{/requests})

    # In Authoring Tool window, enter the title/name of the questionnaire in Questionnaire Title field
    time_stamp = Time.now.to_i
    request_title = "request_#{time_stamp}"
    fill_in 'title', with: ''
    fill_in 'title', with: request_title

    # Enter description under Description field.
    request_description = "description_#{time_stamp}"
    fill_in 'description', with: request_title

    # Create a Section under the New Section
    find_all('input')[1].click
    page.send_keys('My Questionnaire')
    page.send_keys(:enter)
    sleep(2)

    # To add question, click the + then choose Y/N as question type
    plus_icon_selector = 'svg[data-testid="AddCircleIcon"]'
    wait_for_selector(plus_icon_selector)
    find(plus_icon_selector).click

    # Choose the Y/N as question type
    find('li[role="menuitem"]', text: "Y/N").click
    find_all('input')[1].click
    page.send_keys('Testing Yes/No Question Type')
    page.send_keys(:tab)
    sleep(2)

    # Click Preview and Send Button
    click_on 'Preview and Send'
    expect(page).to have_current_path(%r{/dispatch})

    # All questions are rendered
    expect(page).to have_content('My Questionnaire')
    expect(page).to have_content('Testing Yes/No Question Type')
    page.current_path
  end

  def verify_to_save_a_new_questionnaire_as_template
    go_to_requests_from_add_new
    # Under Create new Request window, click the + Blank Request button
    modal_selector = 'div[role="dialog"]'
    wait_for_selector(modal_selector)
    modal = find(modal_selector)
    modal_heading = find('h1')
    wait_for_text(modal_heading, 'CREATE A NEW REQUEST')

    # Click on + Blank Request
    add_icon_selector = 'svg[data-testid="AddIcon"]'
    wait_for_selector(add_icon_selector)
    modal.find(add_icon_selector).click

    expect(page).to have_current_path(%r{/requests})

    # In Authoring Tool window, enter the title/name of the questionnaire in Questionnaire Title field
    time_stamp = Time.now.to_i
    request_title = "request_#{time_stamp}"
    fill_in 'title', with: ''
    fill_in 'title', with: request_title

    # Enter description under Description field.
    request_description = "description_#{time_stamp}"
    fill_in 'description', with: request_title

    # Create a Section under the New Section
    find_all('input')[1].click
    page.send_keys('My Questionnaire')
    page.send_keys(:tab)
    sleep(2)

    # To add question, click the + then choose Y/N as question type
    plus_icon_selector = 'svg[data-testid="AddCircleIcon"]'
    wait_for_selector(plus_icon_selector)
    find(plus_icon_selector).click

    # Choose the Y/N as question type
    find('li[role="menuitem"]', text: "Y/N").click
    find_all('input')[1].click
    page.send_keys('Testing Yes/No Question Type')
    page.send_keys(:tab)
    sleep(2)

    find('button', text: 'Save as New Template').click
    expect(page).to have_current_path('/requests?modal=newRequest')
    page.current_path
  end

  def send_new_questionnaire_request
    create_questionnaire_with_yes_no_question
    page.current_path
  end

  def send_new_request_from_template
    create_questionnaire_from_pre_built_template
    page.current_path
  end

  def check_pannel_when_no_template_has_been_selected
    login_to_app_as_employee

    # In Landing page, click the Requests page
    click_on_sidebar_request_menu

    # Under Request page, click the + Request button.
    wait_for_text(page, 'Request')
    find('button', text: 'Request').click

    # Create new request* window display on screen
    # Under Create new Request window, click the + Blank Request button
    modal_selector = 'div[role="dialog"]'
    wait_for_selector(modal_selector)
    modal = find(modal_selector)
    modal_heading = find('h1')
    wait_for_text(modal_heading, 'CREATE A NEW REQUEST')

    # Wait for templates to load
    wait_for_text(modal, 'Or start from a template')
    modal.find_all('img').first.click

    expect(page).to have_button('Send', disabled: true)
    page.current_path
  end

  def edit_response_under_open_requests
    # Sign in as Firm user
    # In the Landing Page, click the Requests
    go_to_requests

    # Under Request page, click the Open Requests button
    find('a', text: 'Open Requests').click

    # Select a questionnaire then click on any part of the row / line item
    first_request_selector = 'div[data-rowindex="0"]'
    wait_for_selector(first_request_selector)
    find(first_request_selector).click

    # Click the Edit Responses button
    click_on 'Edit Responses'

    sleep 2
    # Answer questions or Edit the responses
    click_on 'Save'

    # Click Mark as Complete
    click_on 'Mark Complete'
    page.current_path
  end

  def edit_response_under_pending_reviews
    # Sign in as Firm user
    # In Landing page, click the Requests page
    go_to_requests

    # Under Request page, Go to the Pending Review tab
    find('a', text: 'Pending review').click

    # Select a questionnaire then click on any part of the row / line item
    first_request_selector = 'div[data-rowindex="0"]'
    wait_for_selector(first_request_selector)
    find(first_request_selector).click

    # Click the Edit Responses button
    click_on 'Edit Responses'

    sleep 2
    # Answer questions or Edit the responses
    click_on 'Save'

    # Click Mark as Complete
    click_on 'Mark Complete'
    page.current_path
  end

  def edit_response_under_archived
    # Sign in as Firm user
    # In Landing page, click the Requests page
    go_to_requests

    # Under Request page, Go to the Archived tab
    find('a', text: 'Archived').click

    # Select a questionnaire then click on any part of the row / line item
    first_request_selector = 'div[data-rowindex="0"]'
    wait_for_selector(first_request_selector)
    find(first_request_selector).click

    # Click the Edit Responses button
    click_on 'Edit Responses'

    # Answer questions or Edit the responses
    sleep 2
    # Answer questions or Edit the responses
    click_on 'Save'

    page.current_path
  end

  def edit_existing_template_under_the_create_new_screen
    # Sign in as Firm user
    # In Landing page, click the Requests page
    go_to_requests

    # Under Request page, click the + Request button
    wait_for_text(page, 'Request')
    find('button', text: 'Request').click

    # Create a new request window display on the screen
    # Verify options that the user may choose to create a new questionnaire
    # Choose from a list of pre-built questionnaire templates
    modal_selector = 'div[role="dialog"]'
    wait_for_selector(modal_selector)
    modal = find(modal_selector)
    modal_heading = find('h1')
    wait_for_text(modal_heading, 'CREATE A NEW REQUEST')
    wait_for_text(modal, 'Or start from a template')
    modal.find_all('img').first.click

    # Click Edit Request on the upper right side
    click_on 'Edit Request'

    page.send_keys("_updated")

    # Click Preview and Send Button
    click_on 'Preview and Send'
    expect(page).to have_current_path(%r{/dispatch})

    page.current_path
  end

  def save_the_edited_request_as_template
    # In Landing Page, click the + Add New button at the left sidebar
    # Click Request in the dropdown menu
    go_to_requests_from_add_new

    # Under Create new Request window, click the + Blank Request button
    # Create a new request window display on the screen
    # Verify options that the user may choose to create a new questionnaire
    # Choose from a list of pre-built questionnaire templates
    modal_selector = 'div[role="dialog"]'
    wait_for_selector(modal_selector)
    modal = find(modal_selector)
    modal_heading = find('h1')
    wait_for_text(modal_heading, 'CREATE A NEW REQUEST')

    sleep 2
    # Click the Elipses icon then click Edit Template
    find_all('button[data-workflowtemplate-id]')[0].click
    sleep 2
    # Click Edit Request on the upper right side
    find('span', text: 'Edit Template').click
    sleep 3

    # Edit the questionnaire and click Save Changes
    page.send_keys("_updated")
    sleep 0.4
    page.send_keys(:tab)

    click_on 'Save Changes'
    page.current_path
  end

  def delete_a_template
    # In Landing page, click the Requests page
    go_to_requests

    # Under Request page, click the + Request button
    wait_for_text(page, 'Request')
    find('button', text: 'Request').click

    # Create a new request window display on the screen
    # Choose any Request in the list then click the Ellipse icon at the right side of the Request
    sleep 2
    find_all('button[data-workflowtemplate-id]')[0].click
    sleep 2

    # Click the Delete Template icon
    find('span', text: 'Delete Template').click

    page.current_path
  end

  def archive_request_tab
    allow_firm_to_edit_existing_template
  end

  def pending_request_tab
    edit_response_under_pending_reviews
  end

  def request_under_open_tab
    save_the_edited_request_as_template
  end

  def question_with_condition
    create_questionnaire_with_yes_no_question
    page.current_path
  end

  def reorder_section
    verify_assignee_option_is_enabled
  end

  def cannot_move_section
    ensure_user_sends_questionnaire_request
  end

  def client_answers_a_short_question
    request_title = create_a_request_with_short_question

    # In the Landing page, click the Requests page
    # Under Request page, go to the Open Requests tab
    # Select a questionnaire under the Open Requests page then click on any part of the row/line item.
    # Answer the questions by typing my answer in the box in a questionnaire then click the Submit button
    open_request_created(request_title)

    wait_for_text(page, 'Testing short question on client side?')
    answer_text_area = find('textarea')

    answer_text_area.send_keys('My response')
    page.send_keys(:tab)

    click_on 'Submit'
    page.current_path
  end

  def question_without_condition
    add_a_condition_in_yes_no_question
  end

  def reorder_short_answer
    verify_to_save_a_new_questionnaire_as_template
  end

  def question_under_requested_status
    request_document_title = create_questionnaire_with_yes_no_question
    login_as_automation_qa
    fill_the_questionnaire(request_document_title)
    page.current_path
  end

  def short_answer_under_progress
    request_title = create_questionnaire_with_questions
    page.current_path
  end

  def save_responses
    request_title = create_a_request_with_short_question

    # In Landing page, click the Requests page
    # Under Request page, go to the Open Requests tab
    # Select a questionnaire under Open Requests status then click on any part of the row / line item
    # Answer the questions in a questionnaire
    # Click Save button
    open_request_created(request_title)

    wait_for_text(page, 'Testing short question on client side?')
    answer_text_area = find('textarea')

    answer_text_area.send_keys('My response')
    page.send_keys(:tab)

    click_on 'Save and Exit'
    page.current_path
  end

  def answer_file_upload_under_inprogress_tab
    request_title = create_a_request_with_file_upload_question

    # In Landing page, click the Requests page
    # Under Request page, go to the Pending review tab
    # Select a questionnaire under Pending review status then click on any part of the row / line item
    # Answer the questions by uploading any files acceptable in 'Upload Additional Documents' section then click Submit button
    submit_file_upload_request(request_title)

    click_on_sidebar_request_menu

    find('a', text: 'Pending review').click

    # Select a questionnaire then click on any part of the row / line item
    first_request_selector = 'div[data-rowindex="0"]'
    wait_for_selector(first_request_selector)
    find(first_request_selector).click

    sleep 3
    wait_for_selector('a[data-testid="attachments__browse"]')
    find('a[data-testid="attachments__browse"]').click

    # Then go to the question that has File Upload
    file_input = find('input[id="upload_doc"]', visible: :all)
    file_input.attach_file(fixtures_path.join('files', 'sample.pdf'))

    # Select file to attach and upload
    wait_for_text(page, 'Preview')

    # Click on the Upload button
    click_on 'Upload'

    page.current_path
  end

  def question_type_condition
    add_a_condition_in_yes_no_question
  end

  def import_organizer
    add_file_upload_question_to_a_questionnaire
  end

  def send_uploaded_organizer
    send_new_questionnaire_request
  end

  def create_new_request
    close_create_new_request
  end

  def clear_response
    edit_response_under_open_requests
  end

  def navigate_away_question
    preview_added_questions
  end

  private

  def submit_file_upload_request(title)
    open_request_created(title)

    find('a[data-testid="attachments__browse"]').click

    # Then go to the question that has File Upload
    file_input = find('input[id="upload_doc"]', visible: :all)
    file_input.attach_file(fixtures_path.join('files', 'sample.pdf'))

    # Select file to attach and upload
    wait_for_text(page, 'Preview')

    # Click on the Upload button
    click_on 'Upload'
    click_on 'Submit'
  end

  def open_request_created(request_title)
    sleep 5
    login_page.logout
    sleep 5
    login_to_app_as_active_liscio_client

    click_on_sidebar_request_menu

    # # Sort all requests in descending order wrt last activity
    find_all('div[aria-label]', text: 'LAST ACTIVITY').first.click
    wait_for_loading_animation
    find_all('div[aria-label]', text: 'LAST ACTIVITY').first.click

    wait_for_text(page, request_title)
    # # Choose any Request in the list then click the Ellipse icon at the right side of the Request
    first_request_selector = 'div[data-rowindex="0"]'
    wait_for_selector(first_request_selector)
    first_request = find(first_request_selector)
    first_request.click
  end

  def create_a_request_with_short_question
    go_to_requests_from_add_new
    # Under Create new Request window, click the + Blank Request button
    modal_selector = 'div[role="dialog"]'
    wait_for_selector(modal_selector)
    modal = find(modal_selector)
    modal_heading = find('h1')
    wait_for_text(modal_heading, 'CREATE A NEW REQUEST')

    # Click on + Blank Request
    add_icon_selector = 'svg[data-testid="AddIcon"]'
    wait_for_selector(add_icon_selector)
    modal.find(add_icon_selector).click

    expect(page).to have_current_path(%r{/requests})

    # In Authoring Tool window, enter the title/name of the questionnaire in Questionnaire Title field
    time_stamp = Time.now.to_i
    request_title = "request_#{time_stamp}"
    fill_in 'title', with: ''
    fill_in 'title', with: request_title

    # Enter description under Description field.
    request_description = "description_#{time_stamp}"
    fill_in 'description', with: request_title

    # Create a Section under the New Section
    find_all('input')[1].click
    page.send_keys('My Questionnaire')
    page.send_keys(:tab)
    sleep(2)

    # To add question, click the + then choose Y/N as question type
    plus_icon_selector = 'svg[data-testid="AddCircleIcon"]'
    wait_for_selector(plus_icon_selector)
    find(plus_icon_selector).click

    # Choose the Short answer as question type
    find('li[role="menuitem"]', text: "Short answer").click
    find_all('input')[1].click
    page.send_keys('Testing short question on client side?')
    page.send_keys(:tab)
    sleep(2)

    # Click Preview and Send Button
    click_on 'Preview and Send'
    expect(page).to have_current_path(%r{/dispatch})

    # All questions are rendered
    expect(page).to have_content('Testing short question on client side?')

    find('span', text: 'Select Assignee').click
    find_all('div[data-value]').first.click

    'andrew qa'.chars.each do |char|
      page.send_keys(char)
      sleep(0.1)
    end

    wait_for_text(page, 'Andrew QA Naylor')
    page.send_keys(:tab)
    sleep(0.5)

    click_on 'Ok'

    sleep(1)
    choose_a_future_date

    click_on 'Send'
    expect(page).to have_current_path('/requests')
    sleep 3
    request_title
  end

  def create_a_request_with_file_upload_question
    go_to_requests_from_add_new
    # Under Create new Request window, click the + Blank Request button
    modal_selector = 'div[role="dialog"]'
    wait_for_selector(modal_selector)
    modal = find(modal_selector)
    modal_heading = find('h1')
    wait_for_text(modal_heading, 'CREATE A NEW REQUEST')

    # Click on + Blank Request
    add_icon_selector = 'svg[data-testid="AddIcon"]'
    wait_for_selector(add_icon_selector)
    modal.find(add_icon_selector).click

    expect(page).to have_current_path(%r{/requests})

    # In Authoring Tool window, enter the title/name of the questionnaire in Questionnaire Title field
    time_stamp = Time.now.to_i
    request_title = "request_#{time_stamp}"
    fill_in 'title', with: ''
    fill_in 'title', with: request_title

    # Enter description under Description field.
    request_description = "description_#{time_stamp}"
    fill_in 'description', with: request_title

    # Create a Section under the New Section
    find_all('input')[1].click
    page.send_keys('My Questionnaire')
    page.send_keys(:tab)
    sleep(2)

    # To add question, click the + then choose Y/N as question type
    plus_icon_selector = 'svg[data-testid="AddCircleIcon"]'
    wait_for_selector(plus_icon_selector)
    find(plus_icon_selector).click

    # Choose the File upload as question type
    find('li[role="menuitem"]', text: "File upload").click
    find_all('input')[1].click
    page.send_keys('Testing file upload question on client side?')
    page.send_keys(:tab)
    sleep(2)

    # Click Preview and Send Button
    click_on 'Preview and Send'
    expect(page).to have_current_path(%r{/dispatch})

    # All questions are rendered
    expect(page).to have_content('Testing file upload question on client side?')

    find('span', text: 'Select Assignee').click
    find_all('div[data-value]').first.click

    'andrew qa'.chars.each do |char|
      page.send_keys(char)
      sleep(0.1)
    end

    wait_for_text(page, 'Andrew QA Naylor')
    page.send_keys(:tab)
    sleep(0.5)

    click_on 'Ok'

    sleep(1)
    choose_a_future_date

    click_on 'Send'
    expect(page).to have_current_path('/requests')
    sleep 3
    request_title
  end

  def choose_a_future_date
    find_all('input').last.click
    all_options = find_all('div.react-datepicker__day')
    selected_index = all_options.find_index(find('div[aria-current="date"]'))
    all_options[selected_index + 1].click
  end

  def prepare_questionnaire_till_due_date
    go_to_requests_from_add_new
    # Under Create new Request window, click the + Blank Request button
    modal_selector = 'div[role="dialog"]'
    wait_for_selector(modal_selector)
    modal = find(modal_selector)
    modal_heading = find('h1')
    wait_for_text(modal_heading, 'CREATE A NEW REQUEST')

    # Click on + Blank Request
    add_icon_selector = 'svg[data-testid="AddIcon"]'
    wait_for_selector(add_icon_selector)
    modal.find(add_icon_selector).click

    expect(page).to have_current_path(%r{/requests})

    # In Authoring Tool window, enter the title/name of the questionnaire in Questionnaire Title field
    time_stamp = Time.now.to_i
    request_title = "request_#{time_stamp}"
    fill_in 'title', with: ''
    fill_in 'title', with: request_title

    # Enter description under Description field.
    request_description = "description_#{time_stamp}"
    fill_in 'description', with: request_title

    # Create a Section under the New Section
    find_all('input')[1].click
    page.send_keys('My Questionnaire to test due date')
    page.send_keys(:tab)
    sleep(2)

    # To add question, click the + then choose Y/N as question type
    plus_icon_selector = 'svg[data-testid="AddCircleIcon"]'
    wait_for_selector(plus_icon_selector)
    find(plus_icon_selector).click

    # Choose the Y/N as question type
    find('li[role="menuitem"]', text: "Y/N").click
    find_all('input')[1].click
    page.send_keys('Testing Yes/No Question Type')
    page.send_keys(:tab)
    sleep(2)

    # Click Preview and Send Button
    click_on 'Preview and Send'
    expect(page).to have_current_path(%r{/dispatch})

    # All questions are rendered
    expect(page).to have_content('Testing Yes/No Question Type')

    find('span', text: 'Select Assignee').click
    find_all('div[data-value]').first.click

    page.send_keys('automation qa')
    page.has_text?('Automation QA')
    page.send_keys(:enter)

    sleep(0.5)
    # Go to next field
    page.send_keys(:tab)
    page.send_keys('abc testing')
    page.has_text?('ABC Testing Inc.')
    page.send_keys(:enter)

    click_on 'Ok'

    sleep(1)
  end

  def create_questionnaire_with_questions
    go_to_requests_from_add_new
    # Under Create new Request window, click the + Blank Request button
    modal_selector = 'div[role="dialog"]'
    wait_for_selector(modal_selector)
    modal = find(modal_selector)
    modal_heading = find('h1')
    wait_for_text(modal_heading, 'CREATE A NEW REQUEST')

    # Click on + Blank Request
    add_icon_selector = 'svg[data-testid="AddIcon"]'
    wait_for_selector(add_icon_selector)
    modal.find(add_icon_selector).click

    expect(page).to have_current_path(%r{/requests})

    # In Authoring Tool window, enter the title/name of the questionnaire in Questionnaire Title field
    time_stamp = Time.now.to_i
    request_title = "request_#{time_stamp}"
    fill_in 'title', with: ''
    fill_in 'title', with: request_title

    # Enter description under Description field.
    request_description = "description_#{time_stamp}"
    fill_in 'description', with: request_title

    # Create a Section under the New Section
    find_all('input')[1].click
    page.send_keys('My Questionnaire')
    page.send_keys(:tab)
    sleep(2)

    # To add question, click the + then choose Y/N as question type
    plus_icon_selector = 'svg[data-testid="AddCircleIcon"]'
    wait_for_selector(plus_icon_selector)
    find(plus_icon_selector).click

    # Choose the Y/N as question type
    find('li[role="menuitem"]', text: "Y/N").click
    find_all('input')[1].click
    page.send_keys('Testing Yes/No Question Type')
    page.send_keys(:tab)
    sleep(2)

    find(plus_icon_selector).click

    # Choose the Short answer as question type
    find('li[role="menuitem"]', text: "Short answer").click
    find_all('input')[1].click
    page.send_keys('How are you doing?')
    page.send_keys(:tab)
    sleep(2)

    find(plus_icon_selector).click

    # Choose the Y/N as question type
    find('li[role="menuitem"]', text: "Y/N").click
    find_all('input')[1].click
    page.send_keys('All question added?')
    page.send_keys(:tab)
    sleep(2)

    # Click Preview and Send Button
    click_on 'Preview and Send'
    expect(page).to have_current_path(%r{/dispatch})

    # All questions are rendered
    expect(page).to have_content('Testing Yes/No Question Type')
    expect(page).to have_content('How are you doing?')
    expect(page).to have_content('All question added?')

    find('span', text: 'Select Assignee').click
    find_all('div[data-value]').first.click

    page.send_keys('automation qa')
    page.has_text?('Automation QA')
    page.send_keys(:enter)

    sleep(0.5)
    # Go to next field
    page.send_keys(:tab)
    page.send_keys('abc testing')
    page.has_text?('ABC Testing Inc.')
    page.send_keys(:enter)

    click_on 'Ok'

    sleep(1)
    choose_a_future_date

    click_on 'Send'
    expect(page).to have_current_path('/requests')
    request_title
  end

  def fill_all_the_answers(title)
    # MuiDataGrid-row
    # find('.MuiDataGrid-row', text: title)
    # TODO :search_sent_questionnaire
    expect(page).to have_content(title)
    newly_created_questionnaire_selector = 'div[data-field="title"]'
    wait_for_selector(newly_created_questionnaire_selector)
    find(newly_created_questionnaire_selector, text: title).click

    expect(page).to have_button('Submit', disabled: true)
    radio_button_group_selector = 'div[role="radiogroup"]'
    wait_for_selector(radio_button_group_selector)
    questions = find_all(radio_button_group_selector)

    questions.first.click
    find('input[value]').send_keys('what goes around comes around')
    questions.last.click

    expect(page).to have_button('Submit', disabled: false)
    click_on 'Submit'
  end

  def create_questionnaire_with_yes_no_question
    go_to_requests_from_add_new
    # Under Create new Request window, click the + Blank Request button
    modal_selector = 'div[role="dialog"]'
    wait_for_selector(modal_selector)
    modal = find(modal_selector)
    modal_heading = find('h1')
    wait_for_text(modal_heading, 'CREATE A NEW REQUEST')

    # Click on + Blank Request
    add_icon_selector = 'svg[data-testid="AddIcon"]'
    wait_for_selector(add_icon_selector)
    modal.find(add_icon_selector).click

    expect(page).to have_current_path(%r{/requests})

    # In Authoring Tool window, enter the title/name of the questionnaire in Questionnaire Title field
    time_stamp = Time.now.to_i
    request_title = "request_#{time_stamp}"
    fill_in 'title', with: ''
    fill_in 'title', with: request_title

    # Enter description under Description field.
    request_description = "description_#{time_stamp}"
    fill_in 'description', with: request_title

    # Create a Section under the New Section
    find_all('input')[1].click
    page.send_keys('My Questionnaire')
    page.send_keys(:enter)
    sleep(2)

    # To add question, click the + then choose Y/N as question type
    plus_icon_selector = 'svg[data-testid="AddCircleIcon"]'
    wait_for_selector(plus_icon_selector)
    find(plus_icon_selector).click

    # Choose the Y/N as question type
    find('li[role="menuitem"]', text: "Y/N").click
    find_all('input')[1].click
    page.send_keys('Testing Yes/No Question Type')
    page.send_keys(:tab)
    sleep(2)

    # Click Preview and Send Button
    click_on 'Preview and Send'
    expect(page).to have_current_path(%r{/dispatch})

    find('span', text: 'Select Assignee').click
    find_all('div[data-value]').first.click

    page.send_keys('automation qa')
    page.has_text?('Automation QA')
    page.send_keys(:enter)

    sleep(0.5)
    # Go to next field
    page.send_keys(:tab)
    page.send_keys('abc testing')
    page.has_text?('ABC Testing Inc.')
    page.send_keys(:enter)

    click_on 'Ok'

    sleep(1)
    choose_a_future_date

    click_on 'Send'
    expect(page).to have_current_path('/requests')
    request_title
  end

  def fill_the_questionnaire(title)
    expect(page).to have_content(title)
    newly_created_questionnaire_selector = 'div[data-field="title"]'
    wait_for_selector(newly_created_questionnaire_selector)
    find(newly_created_questionnaire_selector, text: title).click

    expect(page).to have_button('Submit', disabled: true)
    choose('Yes', allow_label_click: true)
    expect(page).to have_button('Submit', disabled: false)

    click_on 'Submit'
  end

  def create_a_request_document_for_client
    add_icon_selector = 'svg[data-testid="AddIcon"]'
    wait_for_selector(add_icon_selector)
    # Click on + Request
    find(add_icon_selector).click

    modal_selector = 'div[role="dialog"]'
    wait_for_selector(modal_selector)
    modal = find(modal_selector)
    modal_heading = find('h1')
    wait_for_text(modal_heading, 'CREATE A NEW REQUEST')

    # Click on + Blank Request
    modal.find(add_icon_selector).click

    expect(page).to have_current_path(%r{/requests})

    time_stamp = Time.now.to_i
    request_title = "request_#{time_stamp}"
    fill_in 'title', with: request_title

    # Create a Section under the New Section
    find_all('input')[1].click
    page.send_keys('Pitch here')
    page.send_keys(:enter)
    sleep(2)

    plus_icon_selector = 'svg[data-testid="AddCircleIcon"]'
    wait_for_selector(plus_icon_selector)
    find(plus_icon_selector).click

    # Subsection, Y/N, Short answer, File upload
    find('li[role="menuitem"]', text: "Short answer").click

    expect(page).to have_current_path(%r{/requests})

    sleep(1)
    find_all('input')[1].click
    page.send_keys('What is your startup called?')
    page.send_keys(:tab)

    sleep(2)

    # Click Preview and Send Button
    click_on 'Preview and Send'

    expect(page).to have_current_path(%r{/dispatch})

    find('span', text: 'Select Assignee').click
    find_all('div[data-value]').first.click

    page.send_keys('automation qa')
    page.has_text?('Automation QA')
    page.send_keys(:enter)

    sleep(0.5)
    # Go to next field
    page.send_keys(:tab)
    page.send_keys('abc testing')
    page.has_text?('ABC Testing Inc.')
    page.send_keys(:enter)

    click_on 'Ok'

    choose_a_future_date

    click_on 'Send'
    expect(page).to have_current_path('/requests')
    request_title
  end

  def click_on_sidebar_request_menu
    request_selector = 'div[data-testid="sidebar__requests"]'
    request_button = find(request_selector)
    wait_for_selector(request_selector)
    request_button.click
  end

  def fill_questionnaire(request)
    wait_for_text(page, request)
    find('div[data-rowindex="0"]').click

    expect(page).to have_current_path(%r{/requests})
    expect(page).to have_button('Submit', disabled: true)

    find('input[value]').click
    page.send_keys('Funniest City in the World.')
    expect(page).to have_button('Submit', disabled: false)
    click_on 'Submit'
  end

  def login_to_app
    login_page.ensure_login_page_rendered

    login_page.sign_in_with_valid_user
    login_page.ensure_correct_credientials
    login_page
  end

  def login_to_app_as_active_liscio_client
    login_page.ensure_login_page_rendered

    login_page.sign_in_with_valid_active_liscio_client
    login_page.ensure_correct_credientials
    login_page
  end

  def login_as_automation_qa
    login_page.logout
    login_page.visit_login_page

    login_page.sign_in_with_automation_qa
    login_page.ensure_correct_credientials
    login_page
  end

  def login_to_app_as_employee
    login_page.ensure_login_page_rendered

    login_page.sign_in_with_valid_employee
    login_page.ensure_correct_credientials
    login_page
  end

  def login_page
    @login_page ||= LoginPage.new
  end
end
