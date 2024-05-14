require_relative './base_page'
class LoginPage < BasePage
  def visit_login_page
    visit 'https://uatolympus.lisciostaging.com'
  end

  def sign_in(email: '', password: '')
    fill_in 'email', with: email
    fill_in 'password', with: password

    submit
  end

  def sign_in_with_valid_user
    sign_in(email: existing_valid_user['user']['email'], password: existing_valid_user['user']['password'])
  end

  def ensure_correct_credientials
    page.has_selector?('svg[data-testid="MenuIcon"]')
    find_all('svg[data-testid="MenuIcon"]').first.click
    expect(page).to have_content('Home')
    expect(page).to have_content('Inbox')
  end

  def ensure_login_page_rendered
    visit_login_page
    expect(page).to have_css('img[alt="Lisico"]')
  end

  def go_to_forgot_password
    visit_login_page
    page.has_text?('Forgot your password?')
    click_button 'Forgot your password?'
    fill_in 'email', with: existing_valid_user['user']['email']
    click_on 'Submit'
    page.has_text?("You entered #{existing_valid_user['user']['email']}. If this email address is associated with your Liscio account then we will email you the instructions for resetting your password. If you don't receive our email, then please look for it in your spam folder or double check the spelling of your email address.")

    get_reset_password_link
  end

  def get_reset_password_link
    visit_login_page
    sign_in_with_valid_user

    within('.Sidebar') do
      click_on 'EMAILS'
    end

    page.has_selector?('.EmDay')
    expect(find_all('.EmDay').first.text).to eq('TODAY')

    page.has_selector?('.EmOne')
    find_all('.EmOne').first.text

    reset_password_mail = find_all('.EmOne').first
    reset_password_mail.find('span', text: 'Olympus').click

    latest_email_to_reset_password = find_all('.emailsData').last
    page.has_selector?('iframe')
    email = latest_email_to_reset_password.find('iframe')

    within_frame email do
      find('a', text: 'Reset Password').click
    end

    switch_to_window windows.last
    page.has_text?('Password Reset')

    # current_password = Test#123
    new_password = existing_valid_user['user']['password'] + '456'
    # new_password = Test#123456

    fill_in 'new_password', with: new_password
    fill_in 'confirm_password', with: new_password
    click_on 'Submit'

    expect(page).to have_current_path('/login')
    update_saved_password(new_password)

    sign_in(email: existing_valid_user['user']['email'], password: new_password)
    ensure_correct_credientials
  end

  def sign_in_with_google
    click_on 'Sign in with Google'

    page.has_selector?('h1')
    expect(find('h1').text).to eq('Sign in')
    page.has_text?('Create account')
  end

  def sign_in_with_microsoft
    click_on 'Sign in with Office 365'
    page.has_selector?('input')
  end

  private

  def submit
    click_on 'Sign In'
  end
end
