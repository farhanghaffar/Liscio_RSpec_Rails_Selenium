# frozen_string_literal: true

require 'spec_helper'
require_relative '../../pages/web/home_page'

RSpec.describe 'Home workflow', js: true, type: :feature do
  it 'ensures outline of description box displays', description_box: true, testrail_id: '2582' do
    home_page.go_to_edocs

    task_path = home_page.ensure_box_border_is_visible
    expect(page).to have_current_path(task_path, ignore_query: true)
  end

  def home_page
    @home_page ||= HomePage.new
  end
end
