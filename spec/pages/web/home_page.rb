require_relative './base_page'
require_relative './login_page'

class HomePage < BasePage
  def go_to_edocs
    login_to_app
    within('.Sidebar') do
      click_on 'EDOCS'
    end
  end

  def ensure_box_border_is_visible
    page.has_selector?('.tdBtn')
    find_all('.tdBtn').first.click
    wait_for_loading_animation

    expect(page).to have_current_path('/esign_list')
    iframe = find('iframe[id^="tiny-react_"]')
    find_all('a[href]', text: 'TASK').last.click

    # Verify a loading animation displays
    wait_for_loading_animation
    expect(current_path).to include('/task/detail')

    page_refresh
    page.has_selector?('.btn-link')
    find('.btn-link').click
    click_on 'Edit Task'

    verify_description_has_border
    page.current_path
  end

  def verify_description_has_border
    page.has_selector?('#taskTitle')
    sleep(3)
    page.has_selector?('div[role="application"]')
    border = find('div[role="application"]').native.style('border')
    expect(border).to include('2px solid') # Uncomment after bug fix
    # expect(border).to include('0px none')
    # expect(border).to include('2px solid')
    # Border has value of 0px none which should be solid
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
