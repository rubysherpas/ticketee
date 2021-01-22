require "rails_helper"

RSpec.feature "Users can remove unwanted tags from a ticket" do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project) }
  let(:ticket) do
    FactoryBot.create(:ticket,
      project: project,
      author: user,
      tags: [FactoryBot.create(:tag, name: "This Tag Must Die")]
    )
  end

  before do
    login_as(user)
    visit project_ticket_path(project, ticket)
  end

  scenario "successfully", js: true do
    within tag("This Tag Must Die") do
      click_link "Remove tag"
    end
    expect(page).to_not have_content "This Tag Must Die"
  end
end
