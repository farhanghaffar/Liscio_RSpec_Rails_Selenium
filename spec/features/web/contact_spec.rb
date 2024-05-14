# frozen_string_literal: true

require 'spec_helper'
require_relative '../../pages/web/contact_page'

RSpec.describe 'Contact workflow', js: true, type: :feature do
  it 'allows firm users to change a contact\'s email', update_email: true, testrail_id: '2568' do
    contact_page.go_to_contact
    contact_page.go_to_contact_details

    expected_path = %r{/contact/edit/\d+}
    expect(page).to have_current_path(expected_path)
  end

  it 'allows users to archive a contact', archive: true, testrail_id: '3429' do
    contact_page.go_to_contact
    contact_detail_path = contact_page.archive_contact

    expect(page).to have_current_path(contact_detail_path)
  end

  it 'allows users to unarchive a contact', unarchive: true, testrail_id: '3430' do
    contact_page.go_to_contact
    contact_detail_path = contact_page.unarchive_contact

    expect(page).to have_current_path(contact_detail_path)
  end

  it 'allows users to ensure feature visibility is properly restricted or granted', ensure_features: true, testrail_id: '3431' do
    contact_page.go_to_accounts
    contact_detail_path = contact_page.ensure_features_visibility

    expect(page).to have_current_path(contact_detail_path)
  end

  it 'allows users to add a contact from add new > contact', add_contact_from_add_new: true, testrail_id: '3394' do
    contact_page.goto_contact_from_add_new
    contact_detail_path = contact_page.create_contact_from_add_new

    expect(page).to have_current_path(contact_detail_path)
  end

  it 'allows users to add a contact from contacts > + contact', add_contact_from_contacts: true, testrail_id: '3395' do
    contact_page.go_to_contact
    contact_detail_path = contact_page.create_contact_from_contacts

    expect(page).to have_current_path(contact_detail_path)
  end

  it 'allows users to add a contact from accounts > + contact', add_contact_from_accounts: true, testrail_id: '3396' do
    contact_page.go_to_accounts
    contact_detail_path = contact_page.create_contact_from_accounts

    expect(page).to have_current_path(contact_detail_path)
  end

  it 'allows users to deactivate a contact', deactivate_contact: true, testrail_id: '3382' do
    contact_page.go_to_contact
    contact_detail_path = contact_page.deactivate_contact_from_contacts

    expect(page).to have_current_path(contact_detail_path)
  end

  it 'allows users to re-activate the deactivated contact', re_activate_contact: true, testrail_id: '3387' do
    contact_page.go_to_contact
    contact_detail_path = contact_page.re_activate_contact_from_contacts

    expect(page).to have_current_path(contact_detail_path)
  end

  it 'allow users to be able to unarchive a contact', unarchive_contact: true, testrail_id: '3427' do
    contact_page.go_to_contact
    contact_path = contact_page.unarchive_contact
    expect(page).to have_current_path(contact_path, ignore_query: true)
  end

  it 'allow users to be able to ensure feature visibility is properly restricted or granted', feature_visibility: true, testrail_id: '3428' do
    contact_page.go_to_contact
    contact_path = contact_page.ensure_features_visibility
    expect(page).to have_current_path(contact_path, ignore_query: true)
  end

  it 'allow firm users to successfully invite a contact', invite_a_contact: true, testrail_id: '2569' do
    contact_path = contact_page.invite_a_contact
    expect(page).to have_current_path(contact_path, ignore_query: true)
  end

  def contact_page
    @contact_page ||= ContactPage.new
  end
end
