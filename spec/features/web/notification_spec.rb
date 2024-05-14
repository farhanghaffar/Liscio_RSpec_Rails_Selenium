# frozen_string_literal: true

require 'spec_helper'
require_relative '../../pages/web/notification_page'

RSpec.describe 'Notification workflow', js: true, type: :feature do
  it 'allows users to mark as read', mark_all_as_read: true, testrail_id: '2556' do
    notification_page.go_to_notification

    notification_page.mark_as_read
    expect(page).to have_current_path('/')
  end

  it 'allow users to view all new or unread notifications', view_new_and_unread_notifications: true, testrail_id: '2570' do
    notification_path = notification_page.view_new_and_unread_notifications
    expect(page).to have_current_path(notification_path, ignore_query: true)
  end

  it 'allows users to filter by date and notifcation type', filter_by: true, testrail_id: '2571' do
    notification_page.go_to_notification

    notification_page.check_all_filters
    expect(page).to have_current_path('/notifications')
  end

  it 'allows users to be redirected to the actual message upon clicking a message notification', redirect_to_actual_message: true, testrail_id: '267' do
    notification_page.go_to_message_from_add_new

    notifications_path = notification_page.redirect_to_message
    expect(page).to have_current_path(notifications_path, ignore_query: true)
  end

  it 'allow users to view old notifications after marking all as read', view_old_notifications: true, testrail_id: '2557' do
    notification_path = notification_page.view_old_notifications
    expect(page).to have_current_path(notification_path, ignore_query: true)
  end

  def notification_page
    @notification_page ||= NotificationPage.new
  end
end
