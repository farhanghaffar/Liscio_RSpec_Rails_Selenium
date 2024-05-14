require_relative './base_page'
require_relative './login_page'

class PendingReviewPage < BasePage
  def goto_requests
    # Sign in as Firm user
    login_to_app

    # In the Landing Page, click the Requests
    click_on_requests
  end

  def click_on_requests
    request_selector = 'div[data-testid="sidebar__requests"]'
    request_button = find(request_selector)
    wait_for_selector(request_selector)
    request_button.click
  end

  def go_back_to_pending_review_screen_using_back_button
    goto_requests

    # Under the Requests go to the Pending Review tab
    pending_review_selector = 'a[href="/requests/pending"]'
    wait_for_selector(pending_review_selector)
    find(pending_review_selector).click

    # Click any Request in the list
    first_request_selector = 'div[data-rowindex="0"]'
    wait_for_selector(first_request_selector)
    find(first_request_selector).click
    wait_for_text(page, 'RESPONSE PREVIEW')

    # Upper left click Back button
    find('button', text: 'BACK').click

    # Firm user should be able to go back to Pending Review screen using Back button
    expect(page).to have_current_path('/requests/pending')
    page.current_path
  end

  def save_request_in_drafts
    request_title = create_a_new_request

    verify_request_exist(request_title)
  end

  def edit_request_under_draft_tab
    goto_requests

    # Under the Requests go to the Drafts tab
    drafts_reviews_selector = 'a[href="/requests/drafts"]'
    wait_for_selector(drafts_reviews_selector)
    find(drafts_reviews_selector).click

    # Select a questionnaire and click on any part of the row/line item
    first_request_selector = 'div[data-rowindex="0"]'
    wait_for_selector(first_request_selector)
    find(first_request_selector).click

    # Edit the questionnaire and click Save and Exit
    title_selector = 'input[name="title"]'
    wait_for_selector(title_selector)
    previous_title = find(title_selector).value
    updated_title = "#{previous_title}_1"
    fill_in 'title', with: updated_title

    # Then click Save and Exit button
    click_on 'Save and Exit'

    verify_request_exist(updated_title)
  end

  def delete_request_under_drafts_tab
    request_title = create_a_new_request

    # In the Landing Page, click the Requests
    click_on_requests

    # Under the Requests go to the Drafts tab
    drafts_reviews_selector = 'a[href="/requests/drafts"]'
    wait_for_selector(drafts_reviews_selector)
    find(drafts_reviews_selector).click

    # Sort all requests in descending order wrt last activity
    find_all('div[aria-label]', text: 'LAST ACTIVITY').first.click

    wait_for_text(page, request_title)
    # Choose any Request in the list then click the Ellipse icon at the right side of the Request
    first_request_selector = 'div[data-rowindex="0"]'
    wait_for_selector(first_request_selector)
    first_request = find(first_request_selector)
    first_request.find('button').click

    sleep(2)
    # Click the Delete icon
    find('span', text: 'Delete').click

    wait_for_text(page, 'Draft deleted successfully')
    page.current_path
  end

  def edit_request_under_pending_reviews
    goto_requests

    # Go to the Pending Review tab
    pending_review_selector = 'a[href="/requests/pending"]'
    wait_for_selector(pending_review_selector)
    find(pending_review_selector).click

    # Select a questionnaire and click on any part of the row/line item
    first_request_selector = 'div[data-rowindex="0"]'
    wait_for_selector(first_request_selector)
    find(first_request_selector).click

    # Click Mark as Complete
    click_on 'Mark Complete'
    page.current_path
  end

  def update_request_under_pending_reviews
    goto_requests

    # Go to the Pending Review tab
    pending_review_selector = 'a[href="/requests/pending"]'
    wait_for_selector(pending_review_selector)
    find(pending_review_selector).click

    # Click any Request in the list
    first_request_selector = 'div[data-rowindex="0"]'
    wait_for_selector(first_request_selector)
    find(first_request_selector).click

    # Click the Edit Responses button
    find('button', text: 'Edit Responses').click

    # Answer questions or edit the responses

    # Click Save
    find('button', text: 'Save').click
    page.current_path
  end

  def upload_xls_file
    questionnaire_title = create_a_questionnaire_with_file_upload_field

    # Sign in as Client user
    login_to_app_as_active_liscio_client

    # In the Landing Page, click the Requests
    click_on_requests

    # Select Requests under the Requests Page
    sleep 3
    page_refresh

    # Sort all requests in descending order wrt last activity
    find_all('div[aria-label]', text: 'LAST ACTIVITY').first.click

    sleep 2
    # Sort all requests in descending order wrt last activity
    find_all('div[aria-label]', text: 'LAST ACTIVITY').first.click

    find('p', text: questionnaire_title).click

    upload_file_to_questionnaire('sample.pdf')

    wait_for_text(page, 'Updated successfully')
    page.current_path
  end

  def upload_image_file
    questionnaire_title = create_a_questionnaire_with_file_upload_field

    # Sign in as Client user
    login_to_app_as_active_liscio_client

    # In the Landing Page, click the Requests
    click_on_requests

    # Select Requests under the Requests Page
    sleep 3
    page_refresh

    # Sort all requests in descending order wrt last activity
    find_all('div[aria-label]', text: 'LAST ACTIVITY').first.click

    sleep 2
    # Sort all requests in descending order wrt last activity
    find_all('div[aria-label]', text: 'LAST ACTIVITY').first.click

    find('p', text: questionnaire_title).click

    upload_file_to_questionnaire('sample.png')

    wait_for_text(page, 'Updated successfully')
    page.current_path
  end

  def upload_pdf_file
    questionnaire_title = create_a_questionnaire_with_file_upload_field

    # Sign in as Client user
    login_to_app_as_active_liscio_client

    # In the Landing Page, click the Requests
    click_on_requests

    # Select Requests under the Requests Page
    sleep 3
    page_refresh

    # Sort all requests in descending order wrt last activity
    find_all('div[aria-label]', text: 'LAST ACTIVITY').first.click

    sleep 2
    # Sort all requests in descending order wrt last activity
    find_all('div[aria-label]', text: 'LAST ACTIVITY').first.click

    find('p', text: questionnaire_title).click

    upload_file_to_questionnaire('sample.pdf')

    wait_for_text(page, 'Updated successfully')
    page.current_path
  end

  def upload_mulitple_files
    questionnaire_title = create_a_questionnaire_with_file_upload_field

    # Sign in as Client user
    login_to_app_as_active_liscio_client

    # In the Landing Page, click the Requests
    click_on_requests

    # Select Requests under the Requests Page
    sleep 3
    page_refresh

    # Sort all requests in descending order wrt last activity
    find_all('div[aria-label]', text: 'LAST ACTIVITY').first.click

    sleep 2
    # Sort all requests in descending order wrt last activity
    find_all('div[aria-label]', text: 'LAST ACTIVITY').first.click

    find('p', text: questionnaire_title).click

    # Choose an PDF file, image file or XLS file  then Open and click Upload
    upload_file_to_questionnaire('sample.pdf')
    upload_file_to_questionnaire('sample.png')
    upload_file_to_questionnaire('sample.xls')

    wait_for_text(page, 'Updated successfully')
    page.current_path
  end

  def remove_uploaded_file
    upload_mulitple_files

    2.times.each do
      find_all('.icon-close2').first.click
      click_on 'Yes'

      wait_for_text(page, 'Attachment removed successfully')
      sleep 1
    end
    page.current_path
  end

  private

  def upload_file_to_questionnaire(file)
    find('a[data-testid="attachments__browse"]').click

    # Then go to the question that has File Upload
    file_input = find('input[id="upload_doc"]', visible: :all)
    file_input.attach_file(fixtures_path.join('files', file))

    # Select file to attach and upload
    wait_for_text(page, 'Preview')

    # Click on the Upload button
    click_on 'Upload'
  end

  def create_a_questionnaire_with_file_upload_field
    goto_requests

    # Under the Requests click + Request button
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

    # Enter the Questionnaire title and Description
    time_stamp = Time.now.to_i
    request_title = "request_#{time_stamp}"
    fill_in 'title', with: ''
    fill_in 'title', with: request_title

    request_description = "description_#{time_stamp}"
    fill_in 'description', with: request_title

    # Click + to add a new section and question
    find_all('input')[1].click
    page.send_keys('My Questionnaire')
    page.send_keys(:enter)
    sleep(2)

    # To add question, click the + then choose Y/N as question type
    plus_icon_selector = 'svg[data-testid="AddCircleIcon"]'
    wait_for_selector(plus_icon_selector)
    find(plus_icon_selector).click

    # Subsection, Y/N, Short answer, File upload
    find('li[role="menuitem"]', text: "File upload").click

    expect(page).to have_current_path(%r{/requests})

    sleep(1)
    find_all('input')[1].click
    page.send_keys('Please upload you relevant attachment')
    page.send_keys(:tab)

    sleep(2)

    # Click Preview and Send Button
    click_on 'Preview and Send'

    expect(page).to have_current_path(%r{/dispatch})

    find('span', text: 'Select Assignee').click
    find_all('div[data-value]').first.click

    'aquifa tron'.chars.each do |ch|
      page.send_keys(ch)
      sleep(0.5)
    end

    page.has_text?('Aquifa Tron Halbert')
    page.send_keys(:enter)

    click_on 'Ok'
    sleep(0.5)

    choose_a_future_date

    click_on 'Send'
    login_page.logout
    request_title
  end

  def choose_a_future_date
    find_all('input').last.click
    all_options = find_all('div.react-datepicker__day')
    selected_index = all_options.find_index(find('div[aria-current="date"]'))
    all_options[selected_index + 1].click
  end

  def create_a_new_request
    goto_requests

    # Under the Requests click + Request button
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

    # Enter the Questionnaire title and Description
    time_stamp = Time.now.to_i
    request_title = "request_#{time_stamp}"
    fill_in 'title', with: ''
    fill_in 'title', with: request_title

    request_description = "description_#{time_stamp}"
    fill_in 'description', with: request_title

    # Click + to add a new section and question
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

    # Then click Save and Exit button
    click_on 'Save and Exit'
    request_title
  end

  def verify_request_exist(request_title)
    # Sort all requests in descending order wrt last activity
    find_all('div[aria-label]', text: 'LAST ACTIVITY').first.click

    # Firm users can save the new request in the Drafts tab using Save and Exit
    wait_for_text(page, request_title)
    page.current_path
  end

  def login_to_app_as_active_liscio_client
    login_page.ensure_login_page_rendered

    login_page.sign_in_with_valid_active_liscio_client
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
