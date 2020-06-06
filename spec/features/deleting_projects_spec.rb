require "rails_helper"

RSpec.feature "Users can delete projects" do
  scenario "successfully" do
    FactoryBot.create(:project, name: "Visual Studio Code")

    visit "/"
    click_link "Visual Studio Code"
    click_link "Delete Project"

    expect(page).to have_content "Project has been deleted."
    expect(page.current_url).to eq projects_url
    expect(page).to have_no_content "Visual Studio Code"
  end
end
