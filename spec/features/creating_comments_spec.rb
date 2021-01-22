require "rails_helper"

RSpec.feature "Users can comment on tickets" do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project) }
  let(:ticket) { FactoryBot.create(:ticket,
    project: project, author: user) }

  before do
    login_as(user)
  end

  scenario "with valid attributes" do
    visit project_ticket_path(project, ticket)

    within(".comments") do
      fill_in "Text", with: "Added a comment!"
      click_button "Create Comment"
    end

    expect(page).to have_content "Comment has been created."

    within(".comments") do
      expect(page).to have_content "Added a comment!"
    end
  end

  scenario "with invalid attributes" do
    visit project_ticket_path(project, ticket)
    click_button "Create Comment"

    expect(page).to have_content "Comment has not been created."
  end

  scenario "when changing a ticket's state" do
    FactoryBot.create(:state, name: "Open")
    visit project_ticket_path(project, ticket)

    within(".comments") do
      fill_in "Text", with: "This is a real issue"
      select "Open", from: "State"
      click_button "Create Comment"
    end


    expect(page).to have_content "Comment has been created."
    within(".ticket .attributes .state") do
      expect(page).to have_content "Open"
    end

    within(".comments") do
      expect(page).to have_content "state set to Open"
    end

  end
end
