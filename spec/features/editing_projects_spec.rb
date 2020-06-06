require "rails_helper"

RSpec.feature "Users can edit existing projects" do
  before do
    FactoryBot.create(:project, name: "Visual Studio Code")

    visit "/"
    click_link "Visual Studio Code"
    click_link "Edit Project"
  end

  scenario "with valid attributes" do
    fill_in "Name", with: "VS Code"
    click_button "Update Project"

    expect(page).to have_content "Project has been updated."
    expect(page).to have_content "VS Code"
  end

  scenario "when providing invalid attributes" do
    fill_in "Name", with: ""
    click_button "Update Project"

    expect(page).to have_content "Project has not been updated."
  end
end
