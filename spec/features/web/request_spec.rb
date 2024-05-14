# frozen_string_literal: true

require 'spec_helper'
require_relative '../../pages/web/request_page'

RSpec.describe 'Request workflow', js: true, type: :feature do
  it 'ensures user to send a questionnaire request that created directly in authoring tool', send_questionnaire: true, testrail_id: '2665' do
    request_page.go_to_requests_from_add_new

    request_path = request_page.ensure_user_sends_questionnaire_request
    expect(page).to have_current_path(request_path, ignore_query: true)
  end

  it 'ensures user to answer "Y/N" question under "Requested" status in questionnaire request page', answer_yes_no_quesiton: true, testrail_id: '2973' do
    request_path = request_page.ensure_user_answers_yes_no_question
    expect(page).to have_current_path(request_path, ignore_query: true)
  end

  it 'ensures user to answer "Y/N" question', ensure_user_answers_the_questionnaire: true, testrail_id: '2642' do
    request_path = request_page.ensure_user_answers_the_questionnaire
    expect(page).to have_current_path(request_path, ignore_query: true)
  end

  it 'ensure user to submit questionnaires after answering all the questions', answser_all_questions: true, testrail_id: '2633' do
    request_path = request_page.answser_all_questions
    expect(page).to have_current_path(request_path, ignore_query: true)
  end

  it 'allow firm user to add assignee with recipient and account under authoring tool', add_assignee_with_recipient_and_account: true, testrail_id: '2657' do
    request_path = request_page.add_assignee_with_recipient_and_account
    expect(page).to have_current_path(request_path, ignore_query: true)
  end

  it 'allow firm user to cancel adding assignee', cancel_adding_assignee: true, testrail_id: '3118' do
    request_path = request_page.cancel_adding_assignee
    expect(page).to have_current_path(request_path, ignore_query: true)
  end

  it 'disallow firm user to add assignee without selecting a recipient', donot_add_assignee_without_selecting_recipient: true, testrail_id: '3752' do
    request_path = request_page.donot_add_assignee_without_selecting_recipient
    expect(page).to have_current_path(request_path, ignore_query: true)
  end

  it 'allow firm users to add assignee in questionnaire template', add_assignee_to_template: true, testrail_id: '3753' do
    request_path = request_page.add_assignee_to_template
    expect(page).to have_current_path(request_path, ignore_query: true)
  end

  describe 'due date in questionnaire', due_date_in_questionnaire: true do
    it 'verify select date option is enabled after firm user added both a title and at least one question to the questionnaire', verify_due_date_is_enabled: true, testrail_id: '2715' do
      request_path = request_page.verify_due_date_is_enabled
      expect(page).to have_current_path(request_path, ignore_query: true)
    end

    it 'allows firm user to validate the default values of the date selector', validate_default_value_of_date: true, testrail_id: '2623' do
      request_path = request_page.validate_default_value_of_date
      expect(page).to have_current_path(request_path, ignore_query: true)
    end

    it 'allows firm user to add due date to questionnaire from authoring tool', add_due_date: true, testrail_id: '2714' do
      request_path = request_page.add_due_date
      expect(page).to have_current_path(request_path, ignore_query: true)
    end

    it 'allows firm user to add due date to existing questionnaire template', add_due_date_to_exisiting_template: true, testrail_id: '2610' do
      request_path = request_page.add_due_date_to_exisiting_template
      expect(page).to have_current_path(request_path, ignore_query: true)
    end

    it 'allows firm user to check the panel when no template has been selected', check_pannel_when_no_template_has_been_selected: true, testrail_id: '2689' do
      request_path = request_page.check_pannel_when_no_template_has_been_selected
      expect(page).to have_current_path(request_path, ignore_query: true)
    end

    it 'verify firm user unable to select past date in existing questionnaire template', attempt_to_select_past_date: true, testrail_id: '2611' do
      request_path = request_page.attempt_to_select_past_date
      expect(page).to have_current_path(request_path, ignore_query: true)
    end
  end

  describe 'initiate new questionnaire request', initiate_new_questionanaire_request: true do
    it 'allow firm user to create a questionnaire request from blank template', create_questionnaire_request_from_blank_template: true, testrail_id: '2609' do
      request_path = request_page.create_questionnaire_request_from_blank_template
      expect(page).to have_current_path(request_path, ignore_query: true)
    end

    it 'allow firm user to create a new questionnaire request from pre-built template', create_questionnaire_from_pre_built_template: true, testrail_id: '2687' do
      request_path = request_page.create_questionnaire_from_pre_built_template
      expect(page).to have_current_path(request_path, ignore_query: true)
    end

    it 'allow firm user to create new questionnaire request from +add new at the left sidebar', create_questionnaire_from_add_new: true, testrail_id: '2628' do
      request_path = request_page.create_questionnaire_from_add_new
      expect(page).to have_current_path(request_path, ignore_query: true)
    end

    it 'allow firm user to close the dropdown window from + add new without selecting any from the list', close_dropdown_window: true, testrail_id: '2629' do
      request_path = request_page.close_dropdown_window
      expect(page).to have_current_path(request_path, ignore_query: true)
    end

    it 'allow firm user to close the create new request screen', close_create_new_request: true, testrail_id: '3075' do
      request_path = request_page.close_create_new_request
      expect(page).to have_current_path(request_path, ignore_query: true)
    end
  end

  describe 'sections and questions in questionnaire', section_and_question_in_questionnaire: true do
    it 'allows firm user to add section in a questionnaire', add_a_section_in_questionnaire: true, testrail_id: '3338' do
      request_path = request_page.add_a_section_in_questionnaire
      expect(page).to have_current_path(request_path, ignore_query: true)
    end

    it 'verify question number automatically update every time firm user add new question', automatically_update_question_number: true, testrail_id: '2974' do
      request_path = request_page.automatically_update_question_number
      expect(page).to have_current_path(request_path, ignore_query: true)
    end

    it 'allows firm user to add short answer question to a new questionnaire request', add_short_question_to_a_questionnaire: true, testrail_id: '2975' do
      request_path = request_page.add_short_question_to_a_questionnaire
      expect(page).to have_current_path(request_path, ignore_query: true)
    end

    it 'allows firm user to add file upload question type to a new questionnaire request', add_file_upload_question_to_a_questionnaire: true, testrail_id: '2976' do
      request_path = request_page.add_file_upload_question_to_a_questionnaire
      expect(page).to have_current_path(request_path, ignore_query: true)
    end

    it 'allows firm user to add a conditions in the yes/no question type from a blank template', add_a_condition_in_yes_no_question: true, testrail_id: '4294' do
      request_path = request_page.add_a_condition_in_yes_no_question
      expect(page).to have_current_path(request_path, ignore_query: true)
    end
  end

  describe 'assignee in questionnaire', assignee_in_questionnaire: true do
    it 'verify assignee option is enabled after firm user added both a title and at least one question to the questionnaire', verify_assignee_option_is_enabled: true, testrail_id: '2982' do
      request_path = request_page.verify_assignee_option_is_enabled
      expect(page).to have_current_path(request_path)
    end

    it 'allow firm user to see a dialog box allowing to select both a contact and an account after clicking the assignee icon', verify_dialog_box_to_select_recipient_and_account: true, testrail_id: '2983' do
      request_path = request_page.verify_dialog_box_to_select_recipient_and_account
      expect(page).to have_current_path(request_path, ignore_query: true)
    end

    it 'allow firm user have not yet selected a recipient or an account then all existing liscio contacts can be selected in recipient drop-down menu', select_liscio_contacts: true, testrail_id: '2984' do
      request_path = request_page.select_liscio_contacts
      expect(page).to have_current_path(request_path, ignore_query: true)
    end

    it 'allow firm user have not yet selected a recipient or an account all existing liscio accounts can be selected in account drop-down menu', select_liscio_accounts: true, testrail_id: '2985' do
      request_path = request_page.select_liscio_accounts
      expect(page).to have_current_path(request_path, ignore_query: true)
    end

    it 'allow firm users to select an employee as a recipient, all existing liscio accounts can be selected in account drop-down menu', all_account_as_recipient: true, testrail_id: '2986' do
      request_path = request_page.all_account_as_recipient
      expect(page).to have_current_path(request_path, ignore_query: true)
    end

    it 'allow firm users to select a client that has one account as a recipient the account field is automatically populated with that account', populate_account_automatically: true, testrail_id: '2987' do
      request_path = request_page.populate_account_automatically
      expect(page).to have_current_path(request_path, ignore_query: true)
    end

    it 'allow firm users to select only a recipient without selecting any account', select_only_liscio_recipient: true, testrail_id: '2990' do
      request_path = request_page.select_only_liscio_recipient
      expect(page).to have_current_path(request_path, ignore_query: true)
    end
  end

  describe 'save and publish', save_and_publish: true do
    it 'allows firm user to edit an existing template', allow_firm_to_edit_existing_template: true, testrail_id: '2663' do
      request_path = request_page.allow_firm_to_edit_existing_template
      expect(page).to have_current_path(request_path, ignore_query: true)
    end

    it 'allows firm user to save a new questionnaire request as template', verify_to_save_a_new_questionnaire_as_template: true, testrail_id: '2664' do
      request_path = request_page.verify_to_save_a_new_questionnaire_as_template
      expect(page).to have_current_path(request_path, ignore_query: true)
    end
  end

  it 'allows firm user to preview the request before sending it', preview_added_questions: true, testrail_id: '3273' do
    request_path = request_page.preview_added_questions
    expect(page).to have_current_path(request_path, ignore_query: true)
  end

  describe 'send a new questionnaire request', send_questionnaire_request: true do
    it 'allow firm users to send a questionnaire request under drafts tab', send_new_questionnaire_request: true, testrail_id: '3044' do
      request_path = request_page.send_new_questionnaire_request
      expect(page).to have_current_path(request_path, ignore_query: true)
    end

    it 'allow firm users to send a questionnaire request using pre-built template', send_new_request_from_template: true, testrail_id: '3168' do
      request_path = request_page.send_new_request_from_template
      expect(page).to have_current_path(request_path, ignore_query: true)
    end
  end

  it 'allow firm users to edit responses in a request under open requests', edit_response_under_open_requests: true, testrail_id: '4912' do
    request_path = request_page.edit_response_under_open_requests
    expect(page).to have_current_path(request_path, ignore_query: true)
  end

  it 'allow firm users to edit responses in a request under pending reviews', edit_response_under_pending_reviews: true, testrail_id: '4913' do
    request_path = request_page.edit_response_under_pending_reviews
    expect(page).to have_current_path(request_path, ignore_query: true)
  end

  it 'allow firm users to edit responses in a request under archived', edit_response_under_archived: true, testrail_id: '4914' do
    request_path = request_page.edit_response_under_archived
    expect(page).to have_current_path(request_path, ignore_query: true)
  end

  it 'allow firm users to edit an existing template under the create new request screen', edit_existing_template_under_the_create_new_screen: true, testrail_id: '4915' do
    request_path = request_page.edit_existing_template_under_the_create_new_screen
    expect(page).to have_current_path(request_path, ignore_query: true)
  end

  it 'allow firm users to save the edited request as template', save_the_edited_request_as_template: true, testrail_id: '4916' do
    request_path = request_page.save_the_edited_request_as_template
    expect(page).to have_current_path(request_path, ignore_query: true)
  end

  it 'allow firm users to delete a template under the create new request screen', delete_a_template: true, testrail_id: '4917' do
    request_path = request_page.delete_a_template
    expect(page).to have_current_path(request_path, ignore_query: true)
  end

  it 'allow firm users to export a request under archive tab', archive_request: true, testrail_id: '4928' do
    request_path = request_page.archive_request_tab
    expect(page).to have_current_path(request_path, ignore_query: true)
  end

  it 'allow firm users to export a request under pending Request tab', pending_request: true, testrail_id: '4929' do
    request_path = request_page.pending_request_tab
    expect(page).to have_current_path(request_path, ignore_query: true)
  end

  it 'allow firm users to export a request under open request tab', request_under_open_tab: true, testrail_id: '4930' do
    request_path = request_page.request_under_open_tab
    expect(page).to have_current_path(request_path, ignore_query: true)
  end

  it 'allow firm users to reorder a y/n question with conditions within the section while creating a new request', question_with_condition: true, testrail_id: '4931' do
    request_path = request_page.question_with_condition
    expect(page).to have_current_path(request_path, ignore_query: true)
  end

  it 'allow firm users to reorder a section while creating a new request', reorder_section: true, testrail_id: '4932' do
    request_path = request_page.reorder_section
    expect(page).to have_current_path(request_path, ignore_query: true)
  end

  it 'allow firm users to cannot move a question to another section while creating a new request.', cannot_move_section: true, testrail_id: '4933' do
    request_page.go_to_requests_from_add_new
    request_path = request_page.cannot_move_section
    expect(page).to have_current_path(request_path, ignore_query: true)
  end

  it 'allow client user to answer a short answer question under all requests page', client_answers_a_short_question: true, testrail_id: '3110' do
    request_path = request_page.client_answers_a_short_question
    expect(page).to have_current_path(request_path, ignore_query: true)
  end

  it 'allow firm users to reorder a Y/N question without conditions within the section while creating a new request.', question_without_condition: true, testrail_id: '4934' do
    request_path = request_page.question_without_condition
    expect(page).to have_current_path(request_path, ignore_query: true)
  end

  it 'allow firm users to reorder a short answer question within the section while creating a new request', reorder_short_answer: true, testrail_id: '4935' do
    request_path = request_page.reorder_short_answer
    expect(page).to have_current_path(request_path, ignore_query: true)
  end

  it 'allow firm users to answer a file upload question under requested status in questionnaire request page', question_under_requested_status: true, testrail_id: '3111' do
    request_path = request_page.question_under_requested_status
    expect(page).to have_current_path(request_path, ignore_query: true)
  end

  it 'allow firm users to answer short answer question under in progress status in questionnaire request page.', short_answer_under_progress: true, testrail_id: '3112' do
    request_path = request_page.short_answer_under_progress
    expect(page).to have_current_path(request_path, ignore_query: true)
  end

  it 'allow client user to save answers/responses automatically', save_responses: true, testrail_id: '2675' do
    request_path = request_page.save_responses
    expect(page).to have_current_path(request_path, ignore_query: true)
  end

  it 'allow client user to answer file upload question under in progress', answer_file_upload_under_inprogress_tab: true, testrail_id: '3113' do
    request_path = request_page.answer_file_upload_under_inprogress_tab
    expect(page).to have_current_path(request_path, ignore_query: true)
  end

  it 'allow firm users to answer a request with a YES/No question type in a CONDITION', question_type_condition: true, testrail_id: '4540' do
    request_path = request_page.question_type_condition
    expect(page).to have_current_path(request_path, ignore_query: true)
  end

  it 'allow firm users to import organizer pdf file in the system', import_organizer: true, testrail_id: '4909' do
    request_path = request_page.import_organizer
    expect(page).to have_current_path(request_path, ignore_query: true)
  end

  it 'allow firm users to send the uploaded Organizer as a Request', send_uploaded_organizer: true, testrail_id: '4910' do
    request_path = request_page.send_uploaded_organizer
    expect(page).to have_current_path(request_path, ignore_query: true)
  end

  it 'allow firm users to reorder a file upload question within the section while creating a new request', create_new_request: true, testrail_id: '4936' do
    request_path = request_page.create_new_request
    expect(page).to have_current_path(request_path, ignore_query: true)
  end

  it 'allow firm users to clear response/answer in a questionnaire', clear_response: true, testrail_id: '2683' do
    request_path = request_page.clear_response
    expect(page).to have_current_path(request_path, ignore_query: true)
  end

  it 'allow firm users to validate that the response still remains in the response field after trying to navigate away from the question.', navigate_away_question: true, testrail_id: '2646' do
    request_path = request_page.navigate_away_question
    expect(page).to have_current_path(request_path, ignore_query: true)
  end

  def request_page
    @request_page ||= RequestPage.new
  end
end
