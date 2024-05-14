# frozen_string_literal: true

require 'spec_helper'
require_relative '../../pages/web/task_schedule_page'

RSpec.describe 'Task schedule workflow', js: true, type: :feature do

  it 'allows users to set a weekly task', set_weekly_task: true, testrail_id: '2612' do
    task_schedule_page.go_to_task_to_do
    task_schedule_page.set_weekly_schedule
    expect(page).to have_current_path('/')
  end

  it 'allows users to set a weekly task with multiple repeat days', task_with_multiple_days: true, testrail_id: '2706' do
    task_schedule_page.go_to_task_to_do
    task_schedule_page.set_task_with_multiple_days
    expect(page).to have_current_path('/')
  end

  it 'allows users to set a monthly task', set_monthly_task: true, testrail_id: '2613' do
    task_schedule_page.go_to_task_to_do
    task_schedule_page.set_monthly_task
    expect(page).to have_current_path('/')
  end

  it 'allows users to set a yearly task', set_yearly_task: true, testrail_id: '2614' do
    task_schedule_page.go_to_task_to_do
    task_schedule_page.set_yearly_task
    expect(page).to have_current_path('/')
  end

  it 'allows users to set a recurring on schedule task', set_recurring_on_schedule: true, testrail_id: '2615' do
    task_schedule_page.go_to_tasks
    task_schedule_page.set_recurring_schedule_task
    expect(page).to have_current_path('/task/new')
  end

  it 'allows users to set a recurring when completed task', set_recurring_when_completed: true, testrail_id: '2616' do
    task_schedule_page.go_to_tasks
    task_schedule_page.set_recurring_when_completed_task
    expect(page).to have_current_path('/task/new')
  end

  it 'allows users to modify the due date of an existing task', edit_task: true, testrail_id: '2631' do
    task_schedule_page.go_to_home
    task_schedule_page.edit_due_date_of_task
    expect(page).to have_current_path('/')
  end

  it 'allows users to modify the recurring date of an existing task', modify_recurring_date: true, testrail_id: '2632' do
    task_schedule_page.go_to_task_to_do
    task_schedule_page.set_monthly_task
    task_schedule_page.edit_recurring_date_of_task
    expect(page).to have_current_path('/')
  end

  it 'allows users to set a recurring task to end on a specific date that covers the whole repeat cycle', repeat_whole_cycle: true, testrail_id: '2691' do
    task_schedule_page.go_to_task_to_do
    task_schedule_page.set_yearly_task
    task_schedule_page.recurring_whole_repeat_cycle
    expect(page).to have_current_path(%r{^.*/$})
  end

  it 'allows users to set a recurring task to end on a specific date that does not the whole repeat cycle', not_repeat_whole_cycle: true, testrail_id: '2701' do
    task_schedule_page.go_to_task_to_do
    task_schedule_page.set_monthly_task
    task_schedule_page.not_recurring_repeat_cycle
    expect(page).to have_current_path('/')
  end

  it 'allows users to be delete a recurring schedule set in an existing task C2692', delete_task: true, testrail_id: '2692' do
    task_schedule_page.go_to_home
    task_schedule_page.delete_an_existing_task
    expect(page).to have_current_path('/')
  end

  it 'allows users should be able to modify the recurring type of an existing task', modify_existing_task: true, testrail_id: '2724' do
    task_schedule_page.go_to_home
    task_schedule_page.modify_existing_task
    expect(page).to have_current_path('/')
  end


  def task_schedule_page
    @task_schedule_page ||= TaskSchedulePage.new
  end
end
