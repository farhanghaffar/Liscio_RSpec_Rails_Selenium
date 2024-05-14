require_relative './base_page'
require_relative './login_page'

class TaskSchedulePage < BasePage
  def go_to_home
    login_to_app
    within('.Sidebar') do
      click_on 'HOME'
    end
  end

  def go_to_tasks
    login_to_app
    within('.Sidebar') do
      click_on 'TASKS'
    end
  end

  def go_to_task_to_do
    login_to_app
    within('.Sidebar') do
      find('span', text: 'ADD NEW').click
    end
    page.has_selector?('div[role="menuitem"]')
    find('div[role="menuitem"]', text: 'Task').click
    find('div[role="menuitem"]', text: 'To Do').click
    sleep(2)
    current_path = page.current_url
    visit current_path
  end

  def fill_in_info
    sleep(3)
    find('#react-select-3-input').click

    # Select For Employee
    page.send_keys('Adnan')
    page.has_text?('Adnan Ghaffar')
    page.send_keys(:tab)

    # Fill in Subject field
    find_by_id('react-select-8-input').click
    page.send_keys('Testing')
    page.send_keys(:tab)

    # Click on Set Recurring beside Due Date field
    find_by_id('taskRecurringDropdown').click
  end

  def go_to_edit_page
    # From Home Dashboard, click on an existing task under My Tasks section
    page.has_text?('My Tasks')
    page.has_selector?('span')
    find_all('span', text: "Testing").first.click
    page_refresh

    # Click on the three dots (...) on the top right corner
    find_all('.icon-more').first.click

    # Select Edit Task
    click_on "Edit Task"
  end

  def fill_info_from_task_page
    sleep(3)
    page_refresh
    # Select For Account: ABC Testing Inc
    page.has_text?('+ Task')
    click_link '+ Task'

    # Select For Account: ABC Testing Inc
    find_by_id('react-select-3-input').click
    page.send_keys('Abc testing')
    page.has_text?('ABC Testing Inc.')
    page.send_keys(:tab)

    # Select For Contact: QA Test UAT Mail
    find_by_id('react-select-5-input').click
    page.send_keys('Qa test')
    page.has_text?('QA Tests UAT Mail')
    page.send_keys(:tab)

    # Fill in Subject field
    find_by_id('react-select-7-input').click
    page.send_keys('Testing')
    page.send_keys(:tab)
  end

  def click_on_buttons
    # Click on Done button
    click_on "Done"

    # Click on Create Task button
    click_on "Create Task"
  end

  def set_weekly_schedule
    fill_in_info
    find_all('.btn-primary')[1].click
    find_all('.btn-outline-light')[3].click
    page.has_text?('Never')
    page.has_text?('When Completed')

    click_on_buttons
  end

  def set_task_with_multiple_days
    fill_in_info

    # Set recur type to On Schedule
    page.has_text?('On Schedule')
    find('label', text: 'On Schedule', visible: :all).click

    click_on_buttons
  end

  def set_monthly_task
    fill_in_info

    # Select Monthly frequency
    find_all('.btn-outline-light').first.click

    # Set a specific day when you want to have the task recur (for example, 1st of the month, 10th, 20th)
    find_by_id('react-select-9-input').click
    page.send_keys('10')
    page.send_keys(:tab)

    page.has_text?('Never')
    page.has_text?('When Completed')

    click_on_buttons
  end

  def set_yearly_task
    fill_in_info

    # Select Yearly frequency
    find_all('.btn-outline-light')[1].click

    # Set a specific day and month when you want to have the task recur (for example, 1st of March, 10th of April)
    find_by_id('react-select-9-input').click
    page.send_keys('10')
    page.send_keys(:tab)

    page.has_text?('Never')

    # Set recur type to On Schedule
    page.has_text?('On Schedule')
    find('label', text: 'On Schedule', visible: :all).click

    click_on_buttons
  end

  def set_recurring_schedule_task
    fill_info_from_task_page

    # Click on Set Recurring beside Due Date field
    find_by_id('taskRecurringDropdown').click
    find_all('.btn-primary')[1].click
    find_all('.btn-outline-light')[7].click

    # Set recur type to On Schedule
    page.has_text?('On Schedule')
    find('label', text: 'On Schedule', visible: :all).click

    click_on_buttons
  end

  def set_recurring_when_completed_task
    fill_info_from_task_page

    # Click on Set Recurring beside Due Date field
    find_by_id('taskRecurringDropdown').click
    page.has_text?('Never')
    page.has_text?('When Completed')

    click_on_buttons
  end

  def edit_due_date_of_task
    go_to_edit_page

    find('.w-100').click

    # Change the current set date to a later date
    find_all('div[role="option"]').last.click

    # Click on Update Task button
    click_on "Update Task"
  end

  def edit_recurring_date_of_task
    within('.Sidebar') do
      click_on 'HOME'
    end

    # Select Edit Task
    go_to_edit_page

    # Click on the Recurs Monthly indicator beside the Due Date field
    find_by_id('taskRecurringDropdown').click

    # Change the frequency to Weekly
    find_all('.btn-outline-light')[0].click

    # Select the day today as the day you prefer the task to be created [if today is Wednesday, select Wednesday]
    find_all('.btn-primary')[1].click
    find_all('.btn-outline-light')[3].click

    selected_day = find_all('.btn-primary')[1].text
    current_day = Time.now.strftime('%a').upcase.chop

    # Set recurring period to On: [date 2 weeks from today]
    page.has_text?('On')
    find_all('label', text: 'On', visible: :all).first.click
    find_all('.date-text')[1].click

    target_date = Date.today + 2.weeks
    formatted_target_date = target_date.strftime("%d")
    # There can be overlapping last week of previous month, so select the last date
    find_all('div[role="option"]', text: formatted_target_date.to_i.to_s).last.click

    # Click on Done button
    click_on "Done"

    # Click on Update Task button
    click_on "Update Task"
  end

  def recurring_whole_repeat_cycle
    within('.Sidebar') do
      click_on 'HOME'
    end

    # Select Edit Task
    go_to_edit_page

    # Click on the Recurs Yearly indicator beside the Due Date field
    find_by_id('taskRecurringDropdown').click

    # Change the frequency to Monthly
    find_all('.btn-outline-light')[1].click

    # Set repeat date to every 2nd day of the month
    find_by_id('react-select-10-input').click
    page.send_keys('2')
    page.send_keys(:tab)

    # Set recurring period end date to On: [date 2 months from today]
    page.has_text?('On')
    find_all('label', text: 'On', visible: :all).first.click
    find_all('.date-text')[1].click

    find('.react-datepicker__navigation--next').click
    find('.react-datepicker__navigation--next').click

    target_date = Date.today + 2.months
    formatted_target_date = target_date.strftime("%e").strip
    find_all('div[role="option"]', text: formatted_target_date).first.click

    # Set recur type to When Completed
    page.has_text?('When Completed')
    find('label', text: 'When Completed', visible: :all).click

    # Click on Done button
    click_on "Done"

    # Click on Update Task button
    click_on "Update Task"
  end

  def not_recurring_repeat_cycle
    within('.Sidebar') do
      click_on 'HOME'
    end

    # Select Edit Task
    go_to_edit_page

    # Click on the Recurs Monthly indicator beside the Due Date field
    find_by_id('taskRecurringDropdown').click

    find_all('.btn-outline-light')[1].click

    # Set repeat date to every 5th day of the month March
    find_by_id('react-select-9-input').click
    page.send_keys('5')
    page.send_keys(:tab)

    find_by_id('react-select-10-input').click
    page.send_keys('Mar')
    page.send_keys(:tab)

    # Set recurring period end date to On: [2 years from today but set date to 4th of March]
    page.has_text?('On')
    find_all('label', text: 'On', visible: :all).first.click
    find_all('.date-text')[1].click

    current_date = Date.new(Date.today.year, 3, 4)
    two_years_later_date = current_date + 2.years
    formatted_date = two_years_later_date.strftime('%Y/%m/%d')

    input_element = find('.react-datepicker-ignore-onclickoutside')
    input_element.set(formatted_date)
    find_all('div[role="option"]', text: two_years_later_date.strftime('%e').strip)[1].click

    # Click on Done button
    click_on "Done"

    # Click on Update Task button
    click_on "Update Task"
  end

  def delete_an_existing_task
    # Select Edit Task
    go_to_edit_page

    # Click on the Recurs [frequency] indicator beside the Due Date field
    find_by_id('taskRecurringDropdown').click

    # Click on Delete Recurring at the bottom of the dropdown window
    find('span', text: "Delete Recurring").click

    # Click on Update Task button
    click_on "Update Task"
  end

  def modify_existing_task
    go_to_edit_page

    find('.w-100').click

    find_all('div[role="option"]').last.click

    click_on "Update Task"
  end

  private

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
