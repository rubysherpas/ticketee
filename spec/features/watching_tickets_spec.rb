require "rails_helper"

RSpec.feature "Users can watch and unwatch tickets" do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project) }
  let(:ticket) do
    FactoryBot.create(:ticket, project: project, author: user)
  end

  before do
    ticket.watchers << user
    login_as(user)
    visit project_ticket_path(project, ticket)
  end

  scenario "toggles between unwatching and watching a ticket" do
    within(".watchers") do
      expect(page).to have_content user.email
    end

    click_link "Unwatch"
    message = "You are no longer watching this ticket."
    expect(page).to have_content(message)

    within(".watchers") do
      expect(page).to_not have_content user.email
    end

    click_link "Watch"
    expect(page).to have_content "You are now watching this ticket."

    within(".watchers") do
      expect(page).to have_content user.email
    end
  end
end
