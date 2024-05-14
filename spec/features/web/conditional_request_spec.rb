# frozen_string_literal: true

require 'spec_helper'
require_relative '../../pages/web/conditional_request_page'

RSpec.describe 'Conditional request workflow', js: true, type: :feature do
  it 'allow firm users to add file upload question under conditional in a template', add_file_upload_question_under_condtitional: true, testrail_id: '4924' do
    conditional_request_path = conditional_request_page.add_file_upload_question_under_condtitional
    expect(page).to have_current_path(conditional_request_path, ignore_query: true)
  end

  it 'allow firm users to add yes/no question under conditional in an existing request in drafts tab', add_yes_no_question_under_conditional_in_existing_request: true, testrail_id: '4925' do
    conditional_request_path = conditional_request_page.add_yes_no_question_under_conditional_in_existing_request
    expect(page).to have_current_path(conditional_request_path, ignore_query: true)
  end

  def conditional_request_page
    @conditional_request_page ||= ConditionalRequestPage.new
  end
end
