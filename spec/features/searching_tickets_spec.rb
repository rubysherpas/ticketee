require "rails_helper"

RSpec.feature "Users can search for tickets matching specific criteria" do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project) }
  let(:open) { State.create(name: "Open") }
  let(:closed) { State.create(name: "Closed") }

  let!(:ticket_1) do
    tags = [FactoryBot.create(:tag, name: "Iteration 1")]
    FactoryBot.create(:ticket, name: "Create projects",
      project: project, author: user, tags: tags, state: open)
  end

  let!(:ticket_2) do
    tags = [FactoryBot.create(:tag, name: "Iteration 2")]
    FactoryBot.create(:ticket, name: "Create users",
      project: project, author: user, tags: tags, state: closed)
  end

  before do
    login_as(user)
    visit project_path(project)
  end

  scenario "searching by tag" do
    fill_in "Search", with: %q{tag:"Iteration 1"}
    click_button "Search"
    within(".tickets") do
      expect(page).to have_link "Create projects"
      expect(page).to_not have_link "Create users"
    end
  end

  scenario "searching by state" do
    fill_in "Search", with: "state:Open"
    click_button "Search"
    within(".tickets") do
      expect(page).to have_link "Create projects"
      expect(page).to_not have_link "Create users"
    end
  end

  scenario "when clicking on a tag" do
    click_link "Create projects"
    within(".ticket .attributes .tags") do
      click_link "Iteration 1"
    end

    within(".tickets") do
      expect(page).to have_content "Create projects"
      expect(page).to_not have_content "Create users"
    end
  end
end
