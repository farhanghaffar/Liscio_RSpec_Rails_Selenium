class BasePage
  include RSpec::Matchers
  include Capybara::DSL

  def user_yml
    "#{RSPEC_ROOT}/fixtures/acceptance/user.yml"
  end

  def existing_valid_user
    YAML.load_file(user_yml)
  end

  def fixtures_path
    Pathname.new("#{RSPEC_ROOT}/fixtures")
  end

  def page_refresh
    current_path = page.current_url
    visit current_path
  end

  def client_initials
    existing_valid_user['active_liscio_client']['initails']
  end

  def client_full_name
    existing_valid_user['active_liscio_client']['full_name']
  end

  def client_associated_account
    existing_valid_user['active_liscio_client']['associated_account']
  end

  def firm_client_email
    existing_valid_user['firm_client']['email']
  end

  def update_saved_password(new_password)
    updated_user = existing_valid_user
    updated_user['user']['password'] = new_password
    File.write(user_yml, updated_user.to_yaml)
  end

  def wait_for_text(target_div, text)
    expect(target_div).to have_content(text)
  end

  def wait_for_selector(target_selector)
    expect(page).to have_selector(target_selector)
  end

  def wait_for_loading_animation
    page.has_selector?('#loading', visible: true)
    sleep 0.5
    page.has_selector?('#loading', visible: false)
  end
end
