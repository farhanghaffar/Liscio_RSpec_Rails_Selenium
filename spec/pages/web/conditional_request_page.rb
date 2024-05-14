require_relative './base_page'
require_relative './login_page'

class ConditionalRequestPage < BasePage
  def add_file_upload_question_under_condtitional
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

    sleep 2
    # Click the Elipses icon then click Edit Template
    find_all('button[data-workflowtemplate-id]')[0].click
    sleep 2

    # Click Edit Request on the upper right side
    find('span', text: 'Edit Template').click
    sleep 3

    # To add question, click the + then choose Y/N as question type
    plus_icon_selector = 'svg[data-testid="AddCircleIcon"]'
    wait_for_selector(plus_icon_selector)
    find_all(plus_icon_selector).first.click

    # Choose the Y/N as question type
    find('li[role="menuitem"]', text: "Y/N").click

    find_all('input')[1].click
    page.send_keys('We will test conditionals')
    page.send_keys(:tab)
    sleep(2)

    # Turn on the 'Conditions' toggle
    wait_for_selector('span.MuiSwitch-switchBase')
    find('span.MuiSwitch-switchBase').click

    sleep 2
    # Under the IF field drop-down choose YES
    # In the TYPE field drop-down choose any question type
    # In the QUESTION field enter any text
    find_all('input')[2].click
    page.send_keys('First Question as a Y/N')
    page.send_keys(:tab)
    sleep(2)

    # Click the + to add another question under the CONDITIONS
    find_all(plus_icon_selector).last.click

    # In the TYPE field drop-down choose File Upload question type
    sleep 2
    find_all('div', text: "Y/N").last.click
    find('li', text: "File Upload").click

    # In the QUESTION field enter any text
    find_all('input')[3].click
    page.send_keys('File upload placeholder: ')
    page.send_keys(:tab)
    sleep(2)

    # Click Save and Exit
    click_on 'Save Changes'

    page.current_path
  end

  def add_yes_no_question_under_conditional_in_existing_request
    # In the Landing Page, click the Requests
    go_to_requests

    # Under the Requests go to the Drafts tab
    find('a', text: 'Drafts - Ready to Send').click

    first_request_selector = 'div[data-rowindex="0"]'
    wait_for_selector(first_request_selector)
    find(first_request_selector).click

    # Click the Edit Responses button
    click_on 'Edit Request'

    # To add question, click the + then choose Y/N as question type
    plus_icon_selector = 'svg[data-testid="AddCircleIcon"]'
    wait_for_selector(plus_icon_selector)
    find_all(plus_icon_selector).first.click

    # Choose the Y/N as question type
    find('li[role="menuitem"]', text: "Y/N").click

    find_all('input')[1].click
    page.send_keys('We will test conditionals Yes/No')
    page.send_keys(:tab)
    sleep(2)

    # Turn on the 'Conditions' toggle
    wait_for_selector('span.MuiSwitch-switchBase')
    find('span.MuiSwitch-switchBase').click
    sleep 2

    # Under the IF field drop-down choose YES
    # In the TYPE field drop-down choose Y/N as question type
    # In the QUESTION field enter any text
    find_all('input')[2].click
    page.send_keys('First Yes/No Question')
    page.send_keys(:tab)
    sleep(2)

    # Click the + to add another question under the CONDITIONS
    find_all(plus_icon_selector).last.click
    sleep 2

    # In the TYPE field drop-down choose Yes/No question type
    # In the QUESTION field enter any text
    find_all('input')[3].click
    page.send_keys('Second Yes/No Question')
    page.send_keys(:tab)
    sleep(2)

    # Click Preveiw and Send
    click_on 'Preview and Send'
    page.current_path
  end

  private

  def go_to_requests
    login_to_app
    click_on_sidebar_request_menu
  end

  def click_on_sidebar_request_menu
    request_selector = 'div[data-testid="sidebar__requests"]'
    request_button = find(request_selector)
    wait_for_selector(request_selector)
    request_button.click
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
