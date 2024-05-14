require_relative './base_page'
require_relative './login_page'

class MessagePage < BasePage
  def go_to_inbox
    login_to_app
    find('span', text: 'Inbox').click
  end

  def verify_recipients_in_message
    subject = send_a_message("Test message")
    find('span', text: "Sent").click
    find_all('div[role="button"]').first.click
    page.current_path
  end

  def archiving_a_message
    subject = send_a_message("Test message")
    find('span', text: "Sent").click
    find_all('div[role="button"]').first.click
    find('svg[data-testid="ArchiveIcon"]').click
    sleep(1)
    click_on "Archive"
  end

  def send_message_with_attachment
    send_a_message("Test message", "404.png")
  end

  def draft_message
    find('svg[data-testid="AddIcon"]').click
    find('div[role="button"]').click
    find_all('button', text: 'Select').first.click
    fill_in ':r7:', with: "Adnan QA"
    page.has_text?('Adnan QA QA')
    find_all('span', text: 'contact')[1].click
    click_on 'OK'
    find('svg[data-testid="ChevronLeftIcon"]').click
    find('span', text: "Drafts").click
    find_all('div[role="button"]')[1].click
  end

  def send_a_message(message, attachment = nil)
    find('svg[data-testid="AddIcon"]').click
    find('div[role="button"]').click
    find_all('button', text: 'Select').first.click
    fill_in ':r7:', with: "Adnan QA"
    page.has_text?('Adnan QA QA')
    find_all('span', text: 'contact')[1].click
    click_on 'OK'
    fill_in ':r4:', with: "Test"
    fill_in ':r5:', with: "Testing send message"
    if attachment
      find('svg[data-testid="AttachFileIcon"]').click
      file_input = find('input[name="files"]', visible: :all)
      file_input.attach_file(fixtures_path('images', attachment))
      click_button("Add attachment")
    end
    click_on "Send"
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
