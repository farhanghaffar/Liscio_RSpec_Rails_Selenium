# frozen_string_literal: true

require 'spec_helper'
require_relative '../../pages/web/account_page'

RSpec.describe 'Account workflow', js: true, type: :feature do
  it 'allows users to close expanded email', close_expanded_mail: true, testrail_id: '4539' do
    account_page.go_to_account

    accounts_path = account_page.close_expanded_mail
    expect(page).to have_current_path(accounts_path)
  end

  describe 'view accounts', account_view: true do
    it 'allows users to not be able to view restricted accounts as an employee user', restricted_account_disable_employee: true, testrail_id: '3406' do
      accounts_path = account_page.unable_to_view_as_employee_user
      expect(page).to have_current_path(accounts_path, ignore_query: true)
    end

    it 'allows users to be able to view unrestricted accounts as an employee user', view_restricted_account_as_employee: true, testrail_id: '3407' do
      account_page.go_to_account_as_employee

      accounts_path = account_page.view_restricted_account_as_employee
      expect(page).to have_current_path(accounts_path, ignore_query: true)
    end

    it 'allows users to be able to view unrestricted accounts as a firm user', view_restricted_account: true, testrail_id: '3408' do
      account_page.go_to_account

      accounts_path = account_page.able_to_view_restricted_account
      expect(page).to have_current_path(accounts_path, ignore_query: true)
    end

    it 'allows users to not be able to view restricted accounts as a firm user', restricted_account_disable_firm: true, testrail_id: '3409' do
      account_page.go_to_account

      accounts_path = account_page.unable_to_view_as_firm_user
      expect(page).to have_current_path(accounts_path, ignore_query: true)
    end
  end

  describe 'Cst alerts', cst_alerts: true do
    it 'allows users to be able to receive a notification for a message sent to me as firm admin', receive_notification: true, testrail_id: '3781' do
      account_page.go_to_message_from_add_new_as_firm_admin
      accounts_path = account_page.receive_message_notification
      expect(page).to have_current_path(accounts_path, ignore_query: true)
    end

    it 'allows users to be able to receive a notification for a message sent to me as employee', receive_notification: true, testrail_id: '3782' do
      account_page.go_to_message_from_add_new
      accounts_path = account_page.receive_message_notification
      expect(page).to have_current_path(accounts_path, ignore_query: true)
    end

    it 'allows users to be able to receive a notification if a client updated something in their account information as admin', receive_notification_on_update: true, testrail_id: '3783' do
      account_page.go_to_account
      accounts_path = account_page.receive_message_notification_on_update
      expect(page).to have_current_path(accounts_path, ignore_query: true)
    end

    it 'allows users to be able to receive a notification if a client updated something in their account information as an employee', receive_notification_in_employee: true, testrail_id: '3784' do
      account_page.go_to_account
      accounts_path = account_page.receive_message_notification_on_employee
      expect(page).to have_current_path(accounts_path, ignore_query: true)
    end

    it 'allows users to be able to receive a notification if a client updated something in their account information as a specialist', receive_notification_on_client: true, testrail_id: '3785' do
      account_page.go_to_account_with_client
      accounts_path = account_page.receive_message_notification_on_client
      expect(page).to have_current_path(accounts_path, ignore_query: true)
    end

    it 'allows users to be able to receive a notification for a message sent to me as a admin', receive_notification_as_admin: true, testrail_id: '3786' do
      account_page.go_to_message_from_add_new
      accounts_path = account_page.receive_message_notification
      expect(page).to have_current_path(accounts_path, ignore_query: true)
    end

    it 'allows users to not be able to receive a notification for client account update if im not part of cst', receive_notification_as_employee: true, testrail_id: '3787' do
      account_page.go_to_account
      accounts_path = account_page.receive_message_notification_as_employee
      expect(page).to have_current_path(accounts_path, ignore_query: true)
    end

    it 'allows users to not be able to receive a notification for client account update if im not part of cst', receive_notification_as_employee: true, testrail_id: '3788' do
      account_page.go_to_account
      accounts_path = account_page.receive_message_notification_as_employee
      expect(page).to have_current_path(accounts_path, ignore_query: true)
    end

    it 'allows users to be able to receive a notification if an account contact uploaded a file for the account', account_contact_uploaded: true, testrail_id: '3789' do
      account_page.go_to_files
      accounts_path = account_page.account_contact_uploaded_file
      expect(page).to have_current_path(accounts_path, ignore_query: true)
    end

    it 'allows users to be able to receive a notification if an account contact uploaded a file for the account as employee', account_contact_uploaded_as_employee: true, testrail_id: '3790' do
      account_page.go_to_files
      accounts_path = account_page.account_contact_uploaded_file_employee
      expect(page).to have_current_path(accounts_path, ignore_query: true)
    end

    it 'allows users to be not able to receive a notification from the message i am sending out', not_receive_message: true, testrail_id: '4246' do
      account_page.go_to_message_from_add_new
      accounts_path = account_page.receive_message_notification
      expect(page).to have_current_path(accounts_path, ignore_query: true)
    end

    it 'allows users to be able to receive a notification for a message sent to me', receive_message: true, testrail_id: '4247' do
      account_page.go_to_message_from_add_new
      accounts_path = account_page.receive_message
      expect(page).to have_current_path(accounts_path, ignore_query: true)
    end

    it 'allows users to be able to receive a notification if a client updated something in their account information', receive_message_notification: true, testrail_id: '4248' do
      accounts_path = account_page.unable_to_view_as_employee_user
      expect(page).to have_current_path(accounts_path, ignore_query: true)
    end


    it 'allows users to be able to receive a notification if a client updated something in their account information', receive_message_as_employee: true, testrail_id: '4249' do
      accounts_path = account_page.receive_notification_as_cst_admin
      expect(page).to have_current_path(accounts_path, ignore_query: true)
    end

    it 'allows users to be able to receive a notification if a client updated something in their account information', receive_message_as_client: true, testrail_id: '4250' do
      account_page.go_to_account_with_client
      accounts_path = account_page.receive_message_notification_on_client
      expect(page).to have_current_path(accounts_path, ignore_query: true)
    end

    it 'allows users to be not able to receive a notification if a client updated something in their account information', receive_message_as_client: true, testrail_id: '4251' do
      account_page.go_to_account
      accounts_path = account_page.unable_to_view_as_firm_user
      expect(page).to have_current_path(accounts_path, ignore_query: true)
    end

    it 'allows users to be not able to receive a notification if a client updated something in their account information', receive_message_as_client: true, testrail_id: '4252' do
      accounts_path = account_page.unable_to_view_as_employee_user
      expect(page).to have_current_path(accounts_path, ignore_query: true)
    end

    it 'allows users to not be able to receive a notification for client account update if i am not part of cst', receive_message_not_cst: true, testrail_id: '4253' do
      account_page.go_to_message_from_add_new
      accounts_path = account_page.receive_message_not_cst
      expect(page).to have_current_path(accounts_path, ignore_query: true)
    end

    it 'allows users to be able to receive a notification if an account contact uploaded a file for the account', receive_message_on_file_uploaded: true, testrail_id: '4254' do
      account_page.go_to_files
      accounts_path = account_page.account_contact_uploaded_file
      expect(page).to have_current_path(accounts_path, ignore_query: true)
    end

    it 'allows users to be able to receive a notification if an account contact uploaded a file for the account', file_uploaded_as_employee: true, testrail_id: '4255' do
      account_page.go_to_files
      accounts_path = account_page.account_contact_uploaded_file_employee
      expect(page).to have_current_path(accounts_path, ignore_query: true)
    end

    it 'allows users to able to receive a notification if an account contact uploaded a file for the account as specialist', file_uploaded_as_specialist: true, testrail_id: '4256' do
      account_page.go_to_account_with_client
      accounts_path = account_page.receive_message_notification_on_client
      expect(page).to have_current_path(accounts_path, ignore_query: true)
    end

    it 'allows members of cst should receive notification whenever a client contact updated details under the account', receive_notification_as_cst_admin: true, testrail_id: '4257' do
      account_path = account_page.receive_notification_as_cst_admin
      expect(page).to have_current_path(account_path, ignore_query: true)
    end
  end

  describe 'Accounts', accounts: true do
    it 'allows users to add an account from add new > account', add_account_from_add_new: true, testrail_id: '3390' do
      account_page.go_to_account_from_add_new
      accounts_path = account_page.create_account_from_add_new
      expect(page).to have_current_path(accounts_path, ignore_query: true)
    end

    it 'allows users to add an account from accounts > + account', add_account_from_accounts: true, testrail_id: '3391' do
      account_page.go_to_account
      accounts_path = account_page.create_account_from_accounts
      expect(page).to have_current_path(accounts_path, ignore_query: true)
    end

    it 'allows users to add an account from contacts > + account', add_account_from_contacts: true, testrail_id: '3392' do
      account_page.go_to_contact
      accounts_path = account_page.create_account_from_contacts
      expect(page).to have_current_path(accounts_path, ignore_query: true)
    end

    it 'allows user to ensure visibility is properly restricted or granted', ensure_visibility_is_restricted: true, testrail_id: '3393' do
      account_path = account_page.ensure_visibility_is_restricted
      expect(page).to have_current_path(account_path, ignore_query: true)
    end

    it 'allows users to ensure visibility is properly restricted or granted', ensure_visibility: true, testrail_id: '3393' do
      account_page.go_to_account
      accounts_path = account_page.ensure_user_visibility
      expect(page).to have_current_path(accounts_path, ignore_query: true)
    end

    it 'allows users to ensure visibility is properly restricted or granted', visibility_properly_granted: true, testrail_id: '3393' do
      account_page.go_to_account
      accounts_path = account_page.ensure_visibility_granted
      expect(page).to have_current_path(accounts_path, ignore_query: true)
    end
  end

  it 'allows client user to view account information', view_account_information: true, testrail_id: '4262' do
    account_path = account_page.view_account_information
    expect(page).to have_current_path(account_path, ignore_query: true)
  end

  it 'allows client user to to edit organization information', edit_organization_information: true, testrail_id: '4263' do
    account_path = account_page.edit_organization_information
    expect(page).to have_current_path(account_path, ignore_query: true)
  end

  it 'allows client to edit additional details', edit_additional_details: true, testrail_id: '4264' do
    account_path = account_page.edit_additional_details
    expect(page).to have_current_path(account_path, ignore_query: true)
  end

  it 'allows client to view and edit technology solutions section', edit_technology_section: true, testrail_id: '4265' do
    account_path = account_page.edit_technology_section
    expect(page).to have_current_path(account_path, ignore_query: true)
  end

  it 'allows client to view and edit bank account details section', edit_bank_account_details: true, testrail_id: '4266' do
    account_path = account_page.edit_bank_account_details
    expect(page).to have_current_path(account_path, ignore_query: true)
  end

  it 'allows client to add log in details to be shared with the firm', add_log_details: true, testrail_id: '4267' do
    account_path = account_page.add_log_details
    expect(page).to have_current_path(account_path, ignore_query: true)
  end

  it 'allows client to view and edit payroll details', edit_payroll_details: true, testrail_id: '4268' do
    account_path = account_page.edit_payroll_details
    expect(page).to have_current_path(account_path, ignore_query: true)
  end

  it 'allows user to manually share files from add new > file', share_file_via_add_new_file: true, testrail_id: '3153' do
    account_path = account_page.share_file_via_add_new_file
    expect(page).to have_current_path(account_path, ignore_query: true)
  end

  it 'allows user to manually share files from dashboard > files', share_file_from_dashboard: true, testrail_id: '3154' do
    account_path = account_page.share_file_from_dashboard
    expect(page).to have_current_path(account_path, ignore_query: true)
  end

  it 'allows user to manually share files from accounts > files', share_file_from_accounts: true, testrail_id: '3155' do
    account_path = account_page.share_file_from_accounts
    expect(page).to have_current_path(account_path, ignore_query: true)
  end

  it 'allows user to manually share files from contacts > files', share_file_from_contacts: true, testrail_id: '3156' do
    account_path = account_page.share_file_from_contacts
    expect(page).to have_current_path(account_path, ignore_query: true)
  end

  it 'allows users to send eDocs to an account with multiple contacts.', send_edoc_to_multiple: true, testrail_id: '3399' do
    account_page.go_to_contact
    accounts_path = account_page.send_edoc_to_multiple
    expect(page).to have_current_path(accounts_path, ignore_query: true)
  end

  def account_page
    @account_page ||= AccountPage.new
  end
end
