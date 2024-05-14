class BasePage
  include RSpec::Matchers
  include Capybara::DSL

  def user_yml
    "#{RSPEC_ROOT}/fixtures/acceptance/user.yml"
  end

  def existing_valid_user
    YAML.load_file(user_yml)
  end

  def page_refresh
    current_path = page.current_url
    visit current_path
  end

  def update_saved_password(new_password)
    updated_user = existing_valid_user
    updated_user['user']['password'] = new_password
    File.write(user_yml, updated_user.to_yaml)
  end
end
