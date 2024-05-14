# frozen_string_literal: true

require 'spec_helper'
require_relative '../../pages/web/file_page'

RSpec.describe 'File workflow', js: true, type: :feature do
  it 'ensures content is not blocked with an error when previewing a PDF', content_block: true, testrail_id: '2593' do
    file_page.go_to_files

    file_path = file_page.ensure_content_are_not_blocked
    expect(page).to have_current_path(file_path, ignore_query: true)
  end

  it 'allows users to attach a file to messages from dashboard HOME', attach_files_from_dashboard: true, testrail_id: '2555' do
    file_page.go_to_messages_from_home
    file_page.attach_files_with_message
    expect(page).to have_current_path('/')
  end

  it 'allows users to attach a file to tasks from ADD NEW Task', attach_files_from_task: true, testrail_id: '2522' do
    file_page.go_to_tasks_from_add_new
    current_path = page.current_url
    visit current_path
    file_page.attach_files_with_task
    expect(page).to have_current_path('/')
  end

  it 'allows users to attach a file from ADD NEW > eDoc', attach_files_from_edoc: true, testrail_id: '2523' do
    file_page.go_to_edoc_from_add_new
    current_path = page.current_url
    visit current_path
    file_page.attach_files_with_edoc
    expect(page).to have_current_path('/esign_list')
  end

  describe 'File upload', file_upload: true do

    it 'allows users to upload and attach a file via add New from home dashboard', upload_file_from_home: true, testrail_id: '103' do
      file_page.go_to_file_from_add_new

      file_path = file_page.upload_file_from_home
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to upload and attach a file into an existing message', upload_file_from_message: true, testrail_id: '104' do
      file_page.go_to_message

      file_path = file_page.upload_file_from_reply_section
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to upload and attach a file via new tasks from home dashboard', upload_file_from_tasks: true, testrail_id: '105' do
      file_page.go_to_tasks_from_add_new

      file_path = file_page.upload_file_from_tasks
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to upload and attach a file into existing tasks from home dashboard', upload_file_existing_tasks: true, testrail_id: '106' do
      file_page.go_to_tasks

      file_path = file_page.upload_file_from_existing_tasks
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to upload and attach a file inside an account > in focus tab', upload_file_from_accounts: true, testrail_id: '107' do
      file_page.go_to_accounts

      file_path = file_page.upload_file_account_infocus
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to upload and attach a file inside an account > files tab', upload_file_from_files: true, testrail_id: '108' do
      file_page.go_to_accounts

      file_path = file_page.upload_file_account_files
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to upload and attach a file inside a contact > files tab', upload_file_from_contacts: true, testrail_id: '109' do
      file_page.go_to_contacts

      file_path = file_page.upload_file_contact_files
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to upload and attach a file through bulk message from home dashboard', upload_file_from_bulk: true, testrail_id: '110' do
      file_page.goto_new_message_from_bulk_action

      file_path = file_page.upload_file_bulk_actions
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to upload and attach a file through bulk edocs from home dashboard', upload_file_from_edocs: true, testrail_id: '2590' do
      file_page.goto_send_edoc_from_bulk_action

      file_path = file_page.upload_file_send_edocs
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to upload and attach a file through bulk get signature from home dashboard', upload_file_from_get_sign: true, testrail_id: '2591' do
      file_page.goto_get_sign_from_bulk_action

      file_path = file_page.upload_file_get_sign
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to upload and attach a file inside an existing billing invoice from home dashboard', upload_file_from_billing: true, testrail_id: '2592' do
      file_page.go_to_billing

      file_path = file_page.upload_file_billing
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to upload and attach a file inside through Emails when adding a reply', upload_file_from_reply: true, testrail_id: '2589' do
      file_page.go_to_emails

      file_path = file_page.upload_adding_reply
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to upload and attach while creating new template from dashboard > admin', upload_file_while_creating_template: true, testrail_id: '2604' do
      file_path = file_page.upload_file_while_creating_template

      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to upload and attach in existing templates from dashboard > admin', upload_file_in_existing_template: true, testrail_id: '2587' do
      file_path = file_page.upload_file_in_existing_template

      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to upload and attach a firm-only file', upload_file_firm_only: true, testrail_id: '3400' do
      file_page.go_to_file_from_add_new

      file_path = file_page.upload_firm_only_file
      expect(page).to have_current_path(file_path, ignore_query: true)
    end
  end

  describe 'File view', file_view: true do

    it 'allows users to be able to view all types of files under home dashboard > files section', all_types_files_under_files: true, testrail_id: '3728' do
      file_path = file_page.check_files_under_files

      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to view all types of files under accounts > files section', all_types_files_under_accounts: true, testrail_id: '3729' do
      file_path = file_page.check_files_under_accounts

      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to view all types of files under contacts > files section', all_types_files_under_contacts: true, testrail_id: '3730' do
      file_path = file_page.check_files_under_contacts

      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to not be able to see files related to unrestricted accounts/contacts', files_under_contacts_accounts: true, testrail_id: '3731' do
      file_path = file_page.check_files_under_accounts

      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to see files related to restricted contacts/accounts', see_files_and_accounts: true, testrail_id: '3732' do
      file_path = file_page.check_files_restricted_accounts

      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to not be able to see files related to restricted accounts/contacts', unable_to_see_files_and_accounts: true, testrail_id: '3733' do
      file_path = file_page.check_files_under_accounts

      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to see files related to restricted accounts/contacts as employee', able_to_see_files_and_accounts: true, testrail_id: '3734' do
      file_path = file_page.check_files_under_accounts

      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to only able to see files that are related to the account where i am part of client service team', only_see_files_related_account: true, testrail_id: '3735' do
      file_path = file_page.only_see_files_under_accounts

      expect(page).to have_current_path(file_path, ignore_query: true)
    end

  end

  describe 'File edit as a firm admin', file_edit_as_firm_admin: true do
    it 'allows users to be able to edit file via clicking file name directly from the file list', edit_file: true, testrail_id: '3754' do
      file_page.go_to_files

      file_path = file_page.edit_file_via_click_filename
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to not be able to save changes made to file with incomplete mandatory details', edit_file_with_incomplete_details: true, testrail_id: '3755' do
      file_page.go_to_files

      file_path = file_page.not_able_to_edit_file
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to do bulk file tags edit', bulk_files_edit: true, testrail_id: '3756' do
      file_page.go_to_files

      file_path = file_page.edit_bulk_file
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to do bulk file year edit', bulk_files_edit_year: true, testrail_id: '3757' do
      file_page.go_to_files

      file_path = file_page.edit_bulk_file_year
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to do bulk file month edit', bulk_files_edit_month: true, testrail_id: '3758' do
      file_page.go_to_files

      file_path = file_page.edit_bulk_file_month
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to do bulk remove tags from multiple files', bulk_files_remove_tag: true, testrail_id: '3759' do
      file_page.go_to_files

      file_path = file_page.remove_tag_bulk_files
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to do bulk remove year from multiple files', bulk_files_remove_year: true, testrail_id: '3760' do
      file_page.go_to_files

      file_path = file_page.remove_year_bulk_files
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to do bulk remove month from multiple files', bulk_files_remove_month: true, testrail_id: '3761' do
      file_page.go_to_files

      file_path = file_page.remove_month_bulk_files
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to attach multiple tags to a file when editing', attach_multiple_tags: true, testrail_id: '3770' do
      file_page.go_to_files

      file_path = file_page.attach_multiple_tags_to_file
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to remove system generated tags from a file when editing', remove_multiple_tags: true, testrail_id: '3771' do
      file_page.go_to_files

      file_path = file_page.remove_multiple_tags_to_file
      expect(page).to have_current_path(file_path, ignore_query: true)
    end
  end

  describe 'File edit as a firm client', file_edit_as_firm_client: true do
    it 'allows users to be able to edit file via clicking file name directly from the file list', edit_file_as_client: true, testrail_id: '3762' do
      file_page.go_to_files_as_client

      file_path = file_page.edit_file_via_click_filename
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to not be able to save changes made to file with incomplete mandatory details', incomplete_details_client: true, testrail_id: '3763' do
      file_page.go_to_files_as_client

      file_path = file_page.not_able_to_edit_file
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to do bulk file tags edit', bulk_files_edit_client: true, testrail_id: '3764' do
      file_page.go_to_files_as_client

      file_path = file_page.edit_bulk_file
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to do bulk file year edit', bulk_files_edit_year_client: true, testrail_id: '3765' do
      file_page.go_to_files_as_client

      file_path = file_page.edit_bulk_file_year
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to do bulk file month edit', bulk_files_edit_month_client: true, testrail_id: '3766' do
      file_page.go_to_files_as_client

      file_path = file_page.edit_bulk_file_month
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to do bulk remove tags from multiple files', bulk_files_remove_tag_client: true, testrail_id: '3767' do
      file_page.go_to_files_as_client

      file_path = file_page.remove_tag_bulk_files
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to do bulk remove year from multiple files', bulk_files_remove_year_client: true, testrail_id: '3768' do
      file_page.go_to_files_as_client

      file_path = file_page.remove_year_bulk_files
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to do bulk remove month from multiple files', bulk_files_remove_month_client: true, testrail_id: '3769' do
      file_page.go_to_files_as_client

      file_path = file_page.remove_month_bulk_files
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to attach multiple tags to a file when editing', attach_multiple_tags_client: true, testrail_id: '3772' do
      file_page.go_to_files_as_client

      file_path = file_page.attach_multiple_tags_to_file
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to remove system generated tags from a file when editing', remove_multiple_tags_client: true, testrail_id: '3773' do
      file_page.go_to_files_as_client

      file_path = file_page.remove_multiple_tags_to_file
      expect(page).to have_current_path(file_path, ignore_query: true)
    end
  end

  describe 'File source jump', source_jump: true do
    it 'allows users to be able to be redirected to task where a file was attached by clicking source', redirect_to_task_via_source: true, testrail_id: '3805' do
      file_page.go_to_files

      file_path = file_page.redirect_task_via_source
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to be redirected to message where a file was attached by clicking source', redirect_to_message_via_source: true, testrail_id: '3806' do
      file_page.go_to_files

      file_path = file_page.redirect_message_via_source
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to be redirected to note where a file was attached by clicking source', redirect_to_note_via_source: true, testrail_id: '3807' do
      file_page.go_to_files

      file_path = file_page.redirect_note_via_source
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to be redirected to bill where a file was attached by clicking source', redirect_to_bill_via_source: true, testrail_id: '3808' do
      file_page.go_to_files

      file_path = file_page.redirect_bill_via_source
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to view more details where a file is attached when source is manual', view_details_via_manual_source: true, testrail_id: '3809' do
      file_page.go_to_files

      file_path = file_page.view_more_details_via_manual
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to view more details where a file is attached when source is multiple', view_details_via_multiple_source: true, testrail_id: '3810' do
      file_page.go_to_files

      file_path = file_page.view_more_details_via_multiple_source
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to be redirected to task where a file was attached by clicking source', redirect_to_task_via_source_client: true, testrail_id: '3811' do
      file_page.go_to_files_as_client

      file_path = file_page.redirect_task_via_source
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to be redirected to message where a file was attached by clicking source', redirect_to_message_via_source_client: true, testrail_id: '3812' do
      file_page.go_to_files_as_client

      file_path = file_page.redirect_message_via_source
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to be redirected to note where a file was attached by clicking source', redirect_to_note_via_source_client: true, testrail_id: '3813' do
      file_page.go_to_files_as_client

      file_path = file_page.redirect_note_via_source_client
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to be redirected to bill where a file was attached by clicking source', redirect_to_bill_via_source_client: true, testrail_id: '3814' do
      file_page.go_to_files_as_client

      file_path = file_page.redirect_bill_via_source_client
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to view more details where a file is attached when source is manual', view_details_via_manual_source_client: true, testrail_id: '3815' do
      file_page.go_to_files_as_client

      file_path = file_page.view_more_details_via_manual
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to view more details where a file is attached when source is multiple', view_details_via_multiple_source_client: true, testrail_id: '3816' do
      file_page.go_to_files_as_client

      file_path = file_page.view_details_via_multiple_source_client
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to verify a signed GET A SIGNATURE task with Engagement Letter file from ACCOUNTS > FILES', verify_engagment_letter_accounts: true, testrail_id: '3893' do
      file_page.go_to_accounts

      file_path = file_page.verify_engagment_letter_on_accounts
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to verify a signed GET A SIGNATURE tasks with Engagement Letter file from CONTACTS > FILES', verify_engagment_letter_contacts: true, testrail_id: '3894' do
      file_page.go_to_contacts

      file_path = file_page.verify_engagment_letter_on_contacts
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to verify the Engagement Letter under FILE.', verify_engagment_letter_files: true, testrail_id: '3886' do
      file_page.go_to_files

      file_path = file_page.verify_engagment_letter_on_files
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to verify the Consent to Release document under FILE.', verify_release_doc_files: true, testrail_id: '3887' do
      file_page.go_to_files

      file_path = file_page.verify_release_doc_on_files
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

  end

  describe 'File attachment', file_attachment: true do
    it 'allows users to be able to attach files to an existing template without an attachment', attach_file_to_existing_templates: true, testrail_id: '2725' do
      file_page.goto_templates_from_admin

      file_path = file_page.attach_files_with_existing_templates
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to attach files in creating new edocs template', attach_file_to_edoc_template: true, testrail_id: '2726' do
      file_page.goto_templates_from_admin

      file_path = file_page.attach_files_with_edoc_template
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to attach files in creating new message template', attach_file_to_message_template: true, testrail_id: '3745' do
      file_page.goto_templates_from_admin

      file_path = file_page.attach_files_with_message_template
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to attach files in creating new task template', attach_file_to_task_template: true, testrail_id: '3746' do
      file_page.goto_templates_from_admin

      file_path = file_page.attach_files_with_task_template
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to attach files in creating new invoice template', attach_file_to_invoice_template: true, testrail_id: '3747' do
      file_page.goto_templates_from_admin

      file_path = file_page.attach_files_with_invoice_template
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to attach files to an existing template with an existing attachment', attach_file_to_existing_attachment: true, testrail_id: '3797' do
      file_page.goto_templates_from_admin

      file_path = file_page.attach_files_with_existing_attachment
      expect(page).to have_current_path(file_path, ignore_query: true)
    end
  end

  describe 'Files filter', files_filter: true do
    it 'allows users to be able to see files list sorted by date added by default', files_list_sorted_by_date: true, testrail_id: '4209' do
      file_page.go_to_files

      file_path = file_page.files_list_sorted_by_added_date
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to do a keyword search in files list', keyword_search_files_list: true, testrail_id: '4210' do
      file_page.go_to_files

      file_path = file_page.files_list_keyword_search
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to filter files list via file type', filter_files_via_file_type: true, testrail_id: '4211' do
      file_page.go_to_files

      file_path = file_page.files_filter_via_type
      expect(page).to have_current_path(file_path, ignore_query: true)
    end

    it 'allows users to be able to filter files list via source', filter_files_via_file_source: true, testrail_id: '4212' do
      file_page.go_to_files

      file_path = file_page.files_filter_via_source
      expect(page).to have_current_path(file_path, ignore_query: true)
    end
  end

  it 'allows users to not be able to see files from restricted accounts', see_files_restricted_accounts: true, testrail_id: '4193' do
    file_page.go_to_accounts

    file_path = file_page.files_restricted_accounts
    expect(page).to have_current_path(file_path, ignore_query: true)
  end

  it 'allows users to manually upload multiple files with large sizes.', manually_upload_file: true, testrail_id: '4046' do
    file_page.go_to_file_from_add_new

    file_path = file_page.manually_upload_file_large_size
    expect(page).to have_current_path(file_path, ignore_query: true)
  end

  def file_page
    @file_page ||= FilePage.new
  end
end
