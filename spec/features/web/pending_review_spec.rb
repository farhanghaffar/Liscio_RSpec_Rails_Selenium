# frozen_string_literal: true

require 'spec_helper'
require_relative '../../pages/web/pending_review_page'

RSpec.describe 'Pending Reviews', js: true, type: :feature do
  it 'allow firm users to go back to pending review screen using back button', go_back_to_pending_review_screen_using_back_button: true, testrail_id: '4900' do
    pending_review_path = pending_review_page.go_back_to_pending_review_screen_using_back_button
    expect(page).to have_current_path(pending_review_path, ignore_query: true)
  end

  it 'ensures firm user can save request in drafts tab using save and exit', save_request_in_drafts: true, testrail_id: '4901' do
    pending_review_path = pending_review_page.save_request_in_drafts
    expect(page).to have_current_path(pending_review_path, ignore_query: true)
  end

  it 'ensures firm user can edit request under drafts tab', edit_request_under_draft_tab: true, testrail_id: '4902' do
    pending_review_path = pending_review_page.edit_request_under_draft_tab
    expect(page).to have_current_path(pending_review_path, ignore_query: true)
  end

  it 'ensures firm user can delete/remove request under drafts tab', delete_request_under_drafts_tab: true, testrail_id: '4903' do
    pending_review_path = pending_review_page.delete_request_under_drafts_tab
    expect(page).to have_current_path(pending_review_path, ignore_query: true)
  end

  it 'ensures firm user can edit request in pending review', edit_request_under_pending_reviews: true, testrail_id: '4896' do
    pending_review_path = pending_review_page.edit_request_under_pending_reviews
    expect(page).to have_current_path(pending_review_path, ignore_query: true)
  end

  it 'ensures firm user can update a request in pending reviews', update_request_under_pending_reviews: true, testrail_id: '4899' do
    pending_review_path = pending_review_page.update_request_under_pending_reviews
    expect(page).to have_current_path(pending_review_path, ignore_query: true)
  end

  it 'ensures client user can upload XLS file', upload_xls_file: true, testrail_id: '4904' do
    pending_review_path = pending_review_page.upload_xls_file
    expect(page).to have_current_path(pending_review_path, ignore_query: true)
  end

  it 'ensure client user can upload image file', upload_image_file: true, testrail_id: '4905' do
    pending_review_path = pending_review_page.upload_image_file
    expect(page).to have_current_path(pending_review_path, ignore_query: true)
  end

  it 'ensure client user can upload PDF file', upload_pdf_file: true, testrail_id: '4906' do
    pending_review_path = pending_review_page.upload_pdf_file
    expect(page).to have_current_path(pending_review_path, ignore_query: true)
  end

  it 'ensures client user can upload multiple files', upload_mulitple_files: true, testrail_id: '4907' do
    pending_review_path = pending_review_page.upload_mulitple_files
    expect(page).to have_current_path(pending_review_path, ignore_query: true)
  end

  it 'ensures client user can remove the uploaded file', remove_uploaded_file: true, testrail_id: '4908' do
    pending_review_path = pending_review_page.remove_uploaded_file
    expect(page).to have_current_path(pending_review_path, ignore_query: true)
  end

  def pending_review_page
    @pending_review_page ||= PendingReviewPage.new
  end
end
