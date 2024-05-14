# frozen_string_literal: true

require 'spec_helper'
require_relative '../../pages/web/edoc_page'

RSpec.describe 'eDoc workflow', js: true, type: :feature do
  # TODO: is this C3364?
  it 'allows users to display a template list modal', template_list: true do
    edoc_page.go_to_edoc

    edoc_page.goto_create_edoc
    expect(page).to have_current_path('/new_esign')
  end

  it 'allows users to sign an agreement as the sole signatory', sign_an_agreement: true, testrail_id: '2540' do
    edoc_page.go_to_edoc

    edoc_path = edoc_page.sign_an_agreement
    expect(page).to have_current_path(edoc_path)
  end

  it 'allows users to close out an eDocument task with one signatory', close_edoc: true, testrail_id: '2541' do
    edoc_page.go_to_home
    edoc_path = edoc_page.go_to_close_an_edoc
    expect(page).to have_current_path(edoc_path)
  end

  it 'allows users to prepare an eDocument for multiple signatories without a signing order', prepare_edoc_for_multiple_signatories: true, testrail_id: '2545' do
    edoc_page.go_to_edoc_from_add_new

    edoc_path = edoc_page.prepare_edoc_for_multiple_signatories
    expect(page).to have_current_path(edoc_path)
  end

  it 'allows users to sign an agreement with multiple signatories without a signing order', sign_multiple_without_order: true, testrail_id: '2546' do
    edoc_page.go_to_edoc
    edoc_path = edoc_page.sign_an_agreement
    expect(page).to have_current_path(edoc_path)
  end

  it 'allows users to view signing tasks between signatories without a signing order', view_signing_tasks_without_order: true, testrail_id: '2547' do
    edoc_page.go_to_tasks
    edoc_path = edoc_page.view_signing_tasks_in_order
    expect(page).to have_current_path(edoc_path)
  end

  it 'allows users to view signing tasks between signatories in a signing order', view_signing_tasks_in_order: true, testrail_id: '2544' do
    edoc_page.go_to_tasks
    edoc_path = edoc_page.view_signing_tasks_in_order
    expect(page).to have_current_path(edoc_path)
  end

  it 'allows users to sign an agreement with multiple signatories in a signing order', sign_multiple_in_order: true, testrail_id: '2543' do
    edoc_page.go_to_edoc
    edoc_path = edoc_page.sign_an_agreement
    expect(page).to have_current_path(edoc_path)
  end

  it 'allow users to be able to create a new eDoc and added an attachment [DEV-226]', should_direct_to_authoring_page: true, testrail_id: '2559' do
    edoc_path = edoc_page.should_direct_to_authoring_page
    expect(page).to have_current_path(edoc_path, ignore_query: true)
  end

  it 'allows firm users to send an eDoc and ensures document is not stuck in drafts', edoc_are_struck: true, testrail_id: '4204' do
    edoc_page.go_to_edoc

    edoc_path = edoc_page.ensure_edoc_are_not_struck
    expect(page).to have_current_path(edoc_path, ignore_query: true)
  end

  it 'allows users to prepare an eDoc for a single signer with one signing field', signer_with_signing_field: true, testrail_id: '2578' do
    edoc_page.go_to_edoc_from_add_new
    edoc_path = edoc_page.signer_with_one_signing_field
    expect(page).to have_current_path(edoc_path, ignore_query: true)
  end

  it 'allows users to view a comment confirming sender signed an agreement', confirm_signed_agreement: true, testrail_id: '2579' do
    edoc_page.go_to_home
    edoc_path = edoc_page.confirm_signed_agreement
    expect(page).to have_current_path(edoc_path, ignore_query: true)
  end

  it 'allows users to be able to see active contacts who have not signed into the mobile app yet in sending a bulk invite', download_mobile_app: true, testrail_id: '4198' do
    edoc_path = edoc_page.go_to_bulk_actions
    expect(page).to have_current_path(edoc_path, ignore_query: true)
  end

  describe 'Filters & search bar', edoc_filter_and_search: true do
    it 'allows users to filter edocs by requestor', filter_edocs_by_requestor: true, testrail_id: '4175' do
      edoc_page.go_to_edoc
      edoc_path = edoc_page.filter_by_requestor
      expect(page).to have_current_path(edoc_path, ignore_query: true)
    end

    it 'allows users to filter edocs by account', filter_edocs_by_account: true, testrail_id: '4176' do
      edoc_page.go_to_edoc
      edoc_path = edoc_page.filter_by_account
      expect(page).to have_current_path(edoc_path, ignore_query: true)
    end

    it 'allows users to filter edocs by signer', filter_edocs_by_signer: true, testrail_id: '4177' do
      edoc_page.go_to_edoc
      edoc_path = edoc_page.filter_by_signer
      expect(page).to have_current_path(edoc_path, ignore_query: true)
    end

    it 'allows users to filter edocs by name using the search bar feature', filter_edocs_by_search_bar: true, testrail_id: '4178' do
      edoc_page.go_to_edoc
      edoc_path = edoc_page.filter_by_search_bar
      expect(page).to have_current_path(edoc_path, ignore_query: true)
    end

    it 'allows users to combine or remove multiple filters when searching for existing eDocs', combine_or_remove_filters: true, testrail_id: '4179' do
      edoc_page.go_to_edoc
      edoc_path = edoc_page.remove_or_combine_filters
      expect(page).to have_current_path(edoc_path, ignore_query: true)
    end
  end

  it 'allow firm users to send an eDocument', send_an_edoc: true, testrail_id: '2584' do
    edoc_path = edoc_page.send_an_edoc
    expect(page).to have_current_path(edoc_path, ignore_query: true)
  end

  it 'disallow firm users to view eDocs uploaded by restricted accounts', should_not_view_edoc_updloaded_by_restricted_account: true, testrail_id: '4300' do
    edoc_path = edoc_page.should_not_view_edoc_updloaded_by_restricted_account
    expect(page).to have_current_path(edoc_path, ignore_query: true)
  end

  it 'allow firm admin users to jump to the task where the eDoc is assigned from viewing eDoc source', jump_to_task_from_edoc: true, testrail_id: '4301' do
    edoc_path = edoc_page.jump_to_task_from_edoc
    expect(page).to have_current_path(edoc_path, ignore_query: true)
  end

  it 'allow firm users to create a template from eDocs section', create_template_from_edocs_section: true, testrail_id: '4302' do
    edoc_path = edoc_page.create_template_from_edocs_section
    expect(page).to have_current_path(edoc_path, ignore_query: true)
  end

  it 'allow firm users to send an eDocument out using a template', send_edoc_using_a_template: true, testrail_id: '4303' do
    edoc_path = edoc_page.send_edoc_using_a_template
    expect(page).to have_current_path(edoc_path, ignore_query: true)
  end

  it 'allow firm users to send an eDocument out using multiple templates', send_edoc_using_multiple_templates: true, testrail_id: '4304' do
    edoc_path = edoc_page.send_edoc_using_multiple_templates
    expect(page).to have_current_path(edoc_path, ignore_query: true)
  end

  it 'allow firm users to use text formatting in creating an eDoc', using_text_formatting_in_creating_edoc: true, testrail_id: '4307' do
    edoc_path = edoc_page.using_text_formatting_in_creating_edoc
    expect(page).to have_current_path(edoc_path, ignore_query: true)
  end

  it 'allow firm users to attach templates and attachments in creating a new eDoc', attach_templates_and_attachments: true, testrail_id: '4308' do
    edoc_path = edoc_page.attach_templates_and_attachments
    expect(page).to have_current_path(edoc_path, ignore_query: true)
  end

  it 'allow client to view eDocs with proper formatting', allow_client_to_view_edoc_with_formatting: true, testrail_id: '4309' do
    edoc_path = edoc_page.allow_client_to_view_edoc_with_formatting
    expect(page).to have_current_path(edoc_path, ignore_query: true)
  end

  it 'allow user to receive and see a signed eDoc attached to a message', receive_and_see_signed_edoc: true, testrail_id: '2577' do
    edoc_path = edoc_page.receive_and_see_signed_edoc
    expect(page).to have_current_path(edoc_path, ignore_query: true)
  end

  it 'allows users to confirm no duplicate comments or files display for a closed eDoc task', confirm_no_duplicate: true, testrail_id: '2580' do
    edoc_page.go_to_home
    edoc_path = edoc_page.confirm_no_duplicate
    expect(page).to have_current_path(edoc_path, ignore_query: true)
  end

  it 'allow users to prepare a new eDocument from dashboard > add new', create_edoc_from_dashboard_add_new: true, testrail_id: '2548' do
    edoc_path = edoc_page.create_edoc_from_dashboard_add_new
    expect(page).to have_current_path(edoc_path, ignore_query: true)
  end

  def edoc_page
    @edoc_page ||= EdocPage.new
  end
end
