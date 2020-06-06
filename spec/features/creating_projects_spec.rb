require "rails_helper"

RSpec.feature "Users can create new projects" do
  before do
    login_as(FactoryBot.create(:user, :admin))
    visit "/"

    click_link "New Project"
  end

  scenario "with valid attributes" do
    fill_in "Name", with: "Visual Studio Code"
    fill_in "Description", with: "Code Editing. Redefined"
    click_button "Create Project"

    expect(page).to have_content "Project has been created."

    project = Project.find_by(name: "Visual Studio Code")
    expect(page.current_url).to eq project_url(project)

    title = "Visual Studio Code - Projects - Ticketee"
    expect(page).to have_title title
  end

  scenario "when providing invalid attributes" do
    click_button "Create Project"

    expect(page).to have_content "Project has not been created."
    expect(page).to have_content "Name can't be blank"
  end
end
